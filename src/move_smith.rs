// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! This is the core generation logic for MoveSmith.
//! Each MoveSmith instance can generates a single Move program consisting of
//! multiple modules and a script.
//! Each generated unit should be runnable as a transactional test.
//! The generation is deterministic. Using the same input Unstructured byte
//! sequence would lead to the same output.
//!
//! The generation for modules is divided into two phases:
//! 1. Generate the skeleton of several elements so that they can be referenced later.
//!     - Generate module names
//!     - Generate struct names and abilities
//!     - Generate function names and signatures
//! 2. Fill in the details of the generated elements.
//!     - Fill in struct fields
//!     - Fill in function bodies

use crate::{
    ast::*,
    codegen::CodeGenerator,
    config::GenerationConfig,
    env::Env,
    names::{Identifier, IdentifierKind as IDKinds, Scope, ROOT_SCOPE},
    types::{
        Ability, HasType, StructType, StructTypeConcrete, Type, TypeArgs, TypeParameter,
        TypeParameters,
    },
    utils::{choose_idx_weighted, choose_item_weighted},
};
use arbitrary::{Arbitrary, Error, Result, Unstructured};
use log::{info, trace, warn};
use num_bigint::BigUint;
use std::{
    cell::{Ref, RefCell, RefMut},
    collections::{BTreeMap, BTreeSet},
    fmt::Write,
};

/// Keeps track of the generation state.
pub struct MoveSmith {
    // The output code
    modules: Vec<RefCell<Module>>,
    script: Option<Script>,
    runs: RefCell<Vec<Identifier>>,

    // Bookkeeping
    env: RefCell<Env>,
}

impl MoveSmith {
    /// Create a new MoveSmith instance with the given configuration.
    pub fn new(config: &GenerationConfig) -> Self {
        let env = Env::new(config);
        Self {
            modules: Vec::new(),
            script: None,
            runs: RefCell::new(Vec::new()),
            env: RefCell::new(env),
        }
    }

    fn env(&self) -> Ref<Env> {
        self.env.borrow()
    }

    fn env_mut(&self) -> RefMut<Env> {
        self.env.borrow_mut()
    }

    /// Get the generated compile unit.
    pub fn get_compile_unit(&self) -> CompileUnit {
        let modules = self
            .modules
            .iter()
            .map(|m| m.borrow().clone())
            .collect::<Vec<Module>>();
        let runs = self.runs.borrow().clone();
        CompileUnit {
            modules,
            scripts: match &self.script {
                Some(s) => vec![s.clone()],
                None => Vec::new(),
            },
            runs,
        }
    }

    /// Generate a Move program consisting of multiple modules and a script.
    /// Consumes the given Unstructured instance to guide the generation.
    ///
    /// Script is generated after all modules are generated so that the script can call functions.
    pub fn generate(&mut self, u: &mut Unstructured) -> Result<()> {
        self.env_mut().initialize(u);
        trace!("Configuration: {:#?}", self.env());
        let num_modules = self.env().config.num_modules.select(u)?;
        trace!("NUM: generating {} modules", num_modules);

        for _ in 0..num_modules {
            self.modules
                .push(RefCell::new(self.generate_module_skeleton(u)?));
        }
        info!("Done generating skeletons");

        for m in self.modules.iter() {
            self.fill_module(u, m)?;
        }
        info!("Done fill in skeletons");

        // Note: disable script generation for now since intermediate states are not compared
        // we use `//# run`` to execute the functions instead
        self.script = None;

        self.post_process(u)?;

        for m in self.modules.iter() {
            self.add_runners(u, m)?;
        }

        Ok(())
    }

    /// Post process the generated Move module to fix simple errors
    pub fn post_process(&self, u: &mut Unstructured) -> Result<()> {
        for m in self.modules.iter() {
            self.post_process_module(u, m)?;
        }
        Ok(())
    }

    pub fn post_process_module(
        &self,
        u: &mut Unstructured,
        module: &RefCell<Module>,
    ) -> Result<()> {
        for s in module.borrow().structs.iter() {
            self.post_process_struct(u, s)?;
        }

        // Handle acquires from function calls
        let mut acquires_map = BTreeMap::new();
        let mut call_map = BTreeMap::new();
        for f in module.borrow().functions.iter() {
            let fref = f.borrow();
            let name = fref.signature.name.clone();
            acquires_map.insert(name.clone(), RefCell::new(fref.signature.acquires.clone()));

            let call_exprs = fref.all_exprs(Some(|e| matches!(e, Expression::FunctionCall(_))));

            let mut calls = BTreeSet::new();
            for ce in call_exprs {
                if let Expression::FunctionCall(c) = ce {
                    calls.insert(c.name.clone());
                }
            }
            call_map.insert(name, calls);
        }

        let mut updated = true;
        while updated {
            updated = false;
            for (caller, callees) in call_map.iter() {
                let caller_acquires = acquires_map.get(caller).unwrap();
                for callee in callees.iter() {
                    if callee == caller {
                        continue;
                    }
                    let callee_acquires = acquires_map.get(callee).unwrap();
                    for acq in callee_acquires.borrow().iter() {
                        if !caller_acquires.borrow().contains(acq) {
                            caller_acquires.borrow_mut().insert(acq.clone());
                            updated = true;
                        }
                    }
                }
            }
        }

        for f in module.borrow().functions.iter() {
            let name = f.borrow().signature.name.clone();
            if let Some(acquires) = acquires_map.get(&name) {
                f.borrow_mut().signature.acquires = acquires.take();
            }
        }

        Ok(())
    }

    pub fn post_process_struct(
        &self,
        u: &mut Unstructured,
        st: &RefCell<StructDefinition>,
    ) -> Result<()> {
        let types_code = st
            .borrow()
            .fields
            .iter()
            .map(|(_, ty)| ty.inline())
            .collect::<Vec<String>>()
            .join(",");

        for tp in st.borrow_mut().type_parameters.type_parameters.iter_mut() {
            let tp_name = tp.name.name.clone();
            tp.is_phantom = bool::arbitrary(u)?;
            if types_code.contains(&tp_name) {
                tp.is_phantom = false;
            }
        }
        Ok(())
    }

    pub fn post_process_function(
        &self,
        _u: &mut Unstructured,
        function: &RefCell<Function>,
    ) -> Result<()> {
        if function.borrow().body.is_none() {
            return Ok(());
        }

        let self_name = function.borrow().signature.name.inline();
        if self_name.contains("runner") {
            return Ok(());
        }

        let body_code = function.borrow().body.as_ref().unwrap().inline();

        // If a function calls itself, we cannot inline it
        if body_code.contains(&self_name) {
            function.borrow_mut().signature.inline = false;
        }

        // Handles acquires from direct resource operations
        let mut acquires = BTreeSet::new();
        let fref = function.borrow();
        let exprs = fref.all_exprs(Some(|e| matches!(e, Expression::Resource(_))));
        for expr in exprs {
            use ResourceOperationKind::*;
            if let Expression::Resource(r) = expr {
                if matches!(r.kind, MoveFrom | BorrowGlobal | BorrowGlobalMut) {
                    // acquires.insert(r.name.clone().unwrap());
                    acquires.insert(r.typ.get_name());
                }
            }
        }
        drop(fref);

        function.borrow_mut().signature.acquires = acquires;

        Ok(())
    }

    /// Generate a script that calls functions from the generated modules.
    #[allow(dead_code)]
    fn generate_script(&self, u: &mut Unstructured) -> Result<Script> {
        let mut script = Script { main: Vec::new() };

        let mut all_funcs: Vec<RefCell<Function>> = Vec::new();
        for m in self.modules.iter() {
            for f in m.borrow().functions.iter() {
                all_funcs.push(f.clone());
            }
        }
        let num_calls = self.env().config.num_calls_in_script.select(u)?;
        trace!("NUM: generating {} calls in the script", num_calls);
        for _ in 0..num_calls {
            let func = u.choose(&all_funcs)?;
            let mut call = self.generate_call_to_function(
                u,
                &ROOT_SCOPE,
                &func.borrow().signature,
                None,
                false,
            )?;
            call.name = self.env().id_pool.flatten_access(&call.name);
            script.main.push(call);
        }

        Ok(script)
    }

    /// Generate a module skeleton with only struct and function skeletions.
    fn generate_module_skeleton(&self, u: &mut Unstructured) -> Result<Module> {
        let hardcoded_address = Scope(Some("0xCAFE".to_string()));
        let (name, scope) = self.get_next_identifier(IDKinds::Module, &hardcoded_address);

        // Struct names
        let mut structs = Vec::new();
        let num_structs = self.env().config.num_structs_in_module.select(u)?;
        trace!("NUM: generating {} struct skeletons", num_structs);
        for _ in 0..num_structs {
            structs.push(RefCell::new(self.generate_struct_skeleton(u, &scope)?));
        }

        // Generate a struct with all abilities to avoid having no type to choose for some type parameters
        let (struct_name, _) = self.get_next_identifier(IDKinds::Struct, &scope);
        let struct_typ = Type::new_struct(&struct_name, None);
        self.env_mut()
            .type_pool
            .insert_mapping(&struct_name, &struct_typ);
        self.env_mut().type_pool.register_type(struct_typ);
        structs.push(RefCell::new(StructDefinition {
            name: struct_name,
            abilities: Vec::from(Ability::ALL),
            type_parameters: TypeParameters::default(),
            fields: Vec::new(),
        }));
        info!("Done generating struct skeletons");

        // Function signatures
        let mut functions = Vec::new();
        let num_funcs = self.env().config.num_functions_in_module.select(u)?;
        trace!("NUM: generating {} function skeletons", num_funcs);
        for _ in 0..num_funcs {
            functions.push(RefCell::new(self.generate_function_skeleton(u, &scope)?));
        }
        info!("Done generating function skeletons");

        Ok(Module {
            uses: vec![Use {
                address: "0x1".to_string(),
                module: Identifier::new_str("vector", IDKinds::Module),
            }],
            name,
            functions,
            structs,
            constants: vec![Constant {
                name: Identifier::new_str("ADDR", IDKinds::Var),
                typ: Type::Address,
                value: Expression::AddressLiteral("@0xBEEF".to_string()),
            }],
        })
    }

    /// Fill in the skeletons
    fn fill_module(&self, u: &mut Unstructured, module: &RefCell<Module>) -> Result<()> {
        let scope = self
            .env()
            .id_pool
            .get_scope_for_children(&module.borrow().name);
        // Struct fields
        for s in module.borrow().structs.iter() {
            self.fill_struct(u, s, &scope)?;
        }

        // Generate function bodies and runners
        for f in module.borrow().functions.iter().rev() {
            self.fill_function(u, f)?;
        }

        Ok(())
    }

    fn add_runners(&self, u: &mut Unstructured, module: &RefCell<Module>) -> Result<()> {
        trace!("Generating runners for module: {:?}", module.borrow().name);
        // For runners, we don't want complex expressions to reduce input
        // consumption and to avoid wasting mutation
        self.env_mut().expr_depth.set_max_depth(0);

        let mut all_runners = Vec::new();
        for f in module.borrow().functions.iter() {
            all_runners.extend(self.generate_runners(u, f)?);
        }

        // Reset the expression depth because we will also genereate other modules
        self.env_mut().expr_depth.reset_max_depth();

        // Insert the runners to the module and add run tasks to the whole compile unit
        // Each task is simply the flat name of the runner function
        for r in all_runners.into_iter() {
            let module_flat = self.env().id_pool.flatten_access(&module.borrow().name);

            let runner_name = format!("{}::{}", module_flat.name, r.signature.name.name);
            let run_flat = Identifier::new(runner_name, IDKinds::Function);
            self.runs.borrow_mut().push(run_flat);
            module.borrow_mut().functions.push(RefCell::new(r));
        }

        Ok(())
    }

    /// Generate a runner function for a callee function.
    /// The runner function does not have parameters so that
    /// it can be easily called with `//# run`.
    /// The runner function only contains one function call and have the same return type as the callee.
    fn generate_runners(
        &self,
        u: &mut Unstructured,
        callee: &RefCell<Function>,
    ) -> Result<Vec<Function>> {
        let signature = callee.borrow().signature.clone();
        let mut runners = Vec::new();
        let num_runs = self.env().config.num_runs_per_func.select(u)?;
        trace!(
            "NUM: generating {} runners for function: {:?}",
            num_runs,
            signature
        );
        for i in 0..num_runs {
            let sref_dec = Statement::Decl(Declaration {
                names: vec![self.env().type_pool.get_signer_ref_var()],
                typs: vec![Type::Ref(Box::new(Type::Signer))],
                value: Some(Expression::Reference(Box::new(Expression::Variable(
                    VariableAccess {
                        name: self.env().type_pool.get_signer_var(),
                        copy: false,
                    },
                )))),
                emit_type: false,
            });

            // Generate a call to the target function
            let call = Expression::FunctionCall(self.generate_call_to_function(
                u,
                &ROOT_SCOPE,
                &signature,
                None,
                false,
            )?);

            // If the callee returns a type parameter, we ignore the return.
            let new_ret = match &signature.return_type {
                Some(Type::TypeParameter(_)) => None,
                Some(t) => Some(t.clone()),
                None => None,
            };

            // Generate a body with only one statement/return expr
            let body = match new_ret.is_none() {
                true => Block {
                    name: Identifier::new_str("_block_runner", IDKinds::Block),
                    stmts: vec![sref_dec, Statement::Expr(call)],
                    return_expr: None,
                },
                false => Block {
                    name: Identifier::new_str("_block_runner", IDKinds::Block),
                    stmts: vec![sref_dec],
                    return_expr: Some(call),
                },
            };

            // Use a special name for the runner function
            // These names are not properly stored in the id_pool so they
            // should not be used elsewhere other than with `//# run`
            let runner = Function {
                signature: FunctionSignature {
                    inline: false,
                    type_parameters: TypeParameters::default(),
                    name: Identifier::new(
                        format!("{}_runner_{}", signature.name.name, i),
                        IDKinds::Function,
                    ),
                    parameters: vec![(self.env().type_pool.get_signer_var(), Type::Signer)],
                    return_type: new_ret,
                    acquires: signature.acquires.clone(),
                },
                visibility: Visibility { public: true },
                body: Some(body),
            };
            runners.push(runner);
        }
        Ok(runners)
    }

    // Generate a struct skeleton with name and random abilities.
    fn generate_struct_skeleton(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<StructDefinition> {
        let (name, struct_scope) = self.get_next_identifier(IDKinds::Struct, parent_scope);

        // Generate type parameters for the struct
        // NOTE: All parameters will have copy+drop for now to avoid having no expression to generate
        let mut type_parameters = Vec::new();
        let num_tps = self.env().config.num_type_params_in_struct.select(u)?;
        trace!(
            "NUM: generating {} type parameters for struct: {:?}",
            num_tps,
            name
        );
        for _ in 0..num_tps {
            type_parameters.push(self.generate_type_parameter(
                u,
                &struct_scope,
                false,
                Some(vec![Ability::Copy, Ability::Drop]),
                None,
            )?);
        }
        let type_parameters = TypeParameters { type_parameters };

        // Generate the `has` abilities for the struct
        let mut ability_choices = vec![Ability::Store, Ability::Key];
        // NOTE: again copy+drop by default for now
        let mut abilities = vec![Ability::Drop, Ability::Copy];
        for _ in 0..u.int_in_range(0..=0)? {
            let idx = u.int_in_range(0..=(ability_choices.len() - 1))?;
            abilities.push(ability_choices.remove(idx));
        }

        // Register the struct type and name
        let struct_typ = Type::new_struct(&name, Some(&type_parameters));
        self.env_mut().type_pool.insert_mapping(&name, &struct_typ);
        self.env_mut().type_pool.register_type(struct_typ);
        Ok(StructDefinition {
            name,
            abilities,
            type_parameters,
            fields: Vec::new(),
        })
    }

    /// Fill in the struct fields with random types.
    fn fill_struct(
        &self,
        u: &mut Unstructured,
        st: &RefCell<StructDefinition>,
        parent_scope: &Scope,
    ) -> Result<()> {
        let struct_scope = self.env().id_pool.get_scope_for_children(&st.borrow().name);
        let num_fields = self.env().config.num_fields_in_struct.select(u)?;
        trace!(
            "NUM: generating {} fields for struct: {:?}",
            num_fields,
            st.borrow().name
        );
        for _ in 0..num_fields {
            let (name, _) = self.get_next_identifier(IDKinds::Var, &struct_scope);

            let typ = loop {
                match u.int_in_range(0..=2)? {
                    // More chance to use basic types than struct types
                    0 | 1 => {
                        break self.get_random_type(
                            u,
                            &struct_scope,
                            true,
                            false,
                            true,
                            false,
                            false,
                        )?
                    },
                    // Use another struct as the field
                    2 => {
                        // We can no longer generate struct types if we reach the limit
                        if self.env_mut().reached_struct_type_field_limit(u) {
                            break self.get_random_type(
                                u,
                                &struct_scope,
                                true,
                                false,
                                false,
                                false,
                                false,
                            )?;
                        }

                        // Get all structs in scope and satisfy the ability requirements
                        let candidates = self.get_usable_struct_type(
                            st.borrow().abilities.clone(),
                            parent_scope,
                            &st.borrow().name,
                        );
                        if !candidates.is_empty() {
                            let struc_def = u.choose(&candidates)?;

                            let constraints = st.borrow().abilities.clone();
                            let mut new_typ = struc_def.get_type();

                            // Check if a struct needs type parameters
                            if self.is_type_concretizable(&new_typ, &struct_scope) {
                                new_typ = self
                                    .concretize_type(
                                        u,
                                        &new_typ,
                                        &struct_scope,
                                        constraints,
                                        Some(&st.borrow().get_type()),
                                    )
                                    .unwrap();
                            }

                            // We can only use fully concretized type as a field
                            if let Type::StructConcrete(_) = &new_typ {
                                // Check if we create a cyclic data type
                                if !self.check_struct_reachable(&new_typ, &st.borrow().name, None) {
                                    self.env_mut().inc_struct_type_field_counter();
                                    break new_typ;
                                }
                            }
                        }
                    },
                    _ => panic!("Invalid type"),
                }
            };
            // Keeps track of the type of the field
            self.env_mut().type_pool.insert_mapping(&name, &typ);
            st.borrow_mut().fields.push((name, typ));
        }
        Ok(())
    }

    /// Return all struct definitions that:
    /// * with in the same module (TODO: allow cross module reference)
    /// * have the desired abilities
    /// * if key is in desired abilities, the struct must have store ability
    /// * does not create loop in the struct hierarchy
    fn get_usable_struct_type(
        &self,
        desired: Vec<Ability>,
        scope: &Scope,
        parent_struct_id: &Identifier,
    ) -> Vec<StructDefinition> {
        let ids = self
            .env()
            .get_identifiers(None, Some(IDKinds::Struct), Some(scope));
        ids.iter()
            .filter_map(|s| {
                let struct_def = self.get_struct_definition_with_identifier(s).unwrap();
                if !desired.iter().all(|a| struct_def.abilities.contains(a)) {
                    return None;
                }
                if desired.contains(&Ability::Key)
                    && !struct_def.abilities.contains(&Ability::Store)
                {
                    return None;
                }
                let source_typ = self.env().type_pool.get_type(s).unwrap();
                if self.check_struct_reachable(&source_typ, parent_struct_id, None) {
                    return None;
                }
                Some(struct_def)
            })
            .collect()
    }

    /// Check if the struct is reachable from another struct.
    fn check_struct_reachable(
        &self,
        source: &Type,
        sink: &Identifier,
        checked: Option<&mut BTreeSet<Type>>,
    ) -> bool {
        if source.get_name() == *sink {
            return true;
        }

        // Initialize a set to keep track of visited types
        let mut tmp_binding = BTreeSet::new();
        let checked = match checked {
            Some(c) => c,
            None => &mut tmp_binding,
        };

        if checked.contains(source) {
            return false;
        } else {
            checked.insert(source.clone());
        }

        // Check all reachable structs
        let mut reached_sts = BTreeSet::new();
        self.get_all_used_struct_in_type(source, &mut reached_sts);

        for st in reached_sts.iter() {
            if st.get_name() == *sink {
                return true;
            }
            // Recursive check the next level
            if self.check_struct_reachable(st, sink, Some(checked)) {
                return true;
            }
        }
        false
    }

    /// Get list of reachable struct types from a given type.
    fn get_all_used_struct_in_type(&self, typ: &Type, reached: &mut BTreeSet<Type>) {
        if reached.contains(typ) {
            return;
        }

        // Process fields
        let st_name = match typ {
            Type::Struct(st) => &st.name,
            Type::StructConcrete(st) => &st.name,
            _ => return,
        };
        let st_def = self.get_struct_definition_with_identifier(st_name).unwrap();
        for (_, field_typ) in st_def.fields.iter() {
            if !reached.contains(field_typ) {
                reached.insert(field_typ.clone());
                self.get_all_used_struct_in_type(field_typ, reached);
            }
        }

        // Process type arguments
        if let Type::StructConcrete(st) = typ {
            for arg in st.type_args.type_args.iter() {
                reached.insert(arg.clone());
                self.get_all_used_struct_in_type(arg, reached);
            }
        }
    }

    /// Get the struct definition with the given identifier.
    fn get_struct_definition_with_identifier(&self, id: &Identifier) -> Option<StructDefinition> {
        for m in self.modules.iter() {
            for s in m.borrow().structs.iter() {
                if &s.borrow().name == id {
                    return Some(s.borrow().clone());
                }
            }
        }
        None
    }

    /// Generate a function skeleton with name and signature.
    fn generate_function_skeleton(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<Function> {
        let (name, scope) = self.get_next_identifier(IDKinds::Function, parent_scope);
        let signature: FunctionSignature = self.generate_function_signature(u, &scope, name)?;

        let func = Function {
            signature,
            visibility: Visibility { public: true },
            body: None,
        };
        trace!("Generated function signature: {:?}", func.inline());
        Ok(func)
    }

    /// Fill in the function body and return statement.
    fn fill_function(&self, u: &mut Unstructured, function: &RefCell<Function>) -> Result<()> {
        let scope = self
            .env()
            .id_pool
            .get_scope_for_children(&function.borrow().signature.name);
        let signature = function.borrow().signature.clone();
        self.env_mut().curr_func_signature = Some(signature.clone());
        trace!(
            "Creating block for the body of function: {:?}",
            signature.name
        );

        // Before generating the function body,
        // we need to make sure that the arguments are alive
        for (arg, _) in signature.parameters.iter() {
            self.env_mut().live_vars.mark_alive(&scope, arg);
        }

        let body = self.generate_block(u, &scope, None, signature.return_type.clone())?;
        function.borrow_mut().body = Some(body);
        self.post_process_function(u, function)?;
        self.env_mut().curr_func_signature = None;
        Ok(())
    }

    /// Generate a function signature with random number of parameters and return type.
    ///
    /// We need to make sure that if the return type is a type parameter,
    /// at least one of the parameters have this type.
    /// Otherwise, we cannot instantiate this type for return.
    fn generate_function_signature(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        name: Identifier,
    ) -> Result<FunctionSignature> {
        // First generate type parameters so that they can be used in the parameters and return type
        let mut type_parameters = Vec::new();
        let num_tps = self.env().config.num_type_params_in_func.select(u)?;
        trace!(
            "NUM: generating {} type parameters for function: {:?}",
            num_tps,
            name
        );
        for _ in 0..num_tps {
            type_parameters.push(self.generate_type_parameter(
                u,
                parent_scope,
                false,
                // TODO: again, default copy+drop for now
                Some(vec![Ability::Copy, Ability::Drop]),
                // TODO: remove this when implementing global storage
                Some(vec![Ability::Key]),
            )?);
        }

        let num_params = self.env().config.num_params_in_func.select(u)?;
        let mut parameters = vec![(
            self.env().type_pool.get_signer_ref_var(),
            Type::Ref(Box::new(Type::Signer)),
        )];

        trace!(
            " NUM: generating {} parameters for function: {:?}",
            num_params,
            name
        );
        for _ in 0..num_params {
            let (name, _) = self.get_next_identifier(IDKinds::Var, parent_scope);
            let typ = self.get_random_type(u, parent_scope, true, false, true, false, true)?;
            self.env_mut().type_pool.insert_mapping(&name, &typ);
            parameters.push((name, typ));
        }

        // More chance to have return type than not
        // so that we can compare the the return value
        let return_type = match u.int_in_range(0..=10)? > 2 {
            true => Some(self.get_random_type(u, parent_scope, true, false, true, false, true)?),
            false => None,
        };

        // Check whether the return type exists in the parameters if the return
        // type is a type parameter.
        // If not in params, we insert one more parameter so that we have
        // something to return
        let ret_ty_to_check = match &return_type {
            Some(ret_ty @ Type::TypeParameter(_)) => Some(ret_ty),
            Some(Type::Ref(ret_ty)) => Some(ret_ty.as_ref()),
            Some(Type::MutRef(ret_ty)) => Some(ret_ty.as_ref()),
            _ => None,
        };

        if let Some(ret_ty) = ret_ty_to_check {
            if !parameters.iter().any(|(_, param_ty)| param_ty == ret_ty) {
                let (name, _) = self.get_next_identifier(IDKinds::Var, parent_scope);
                self.env_mut().type_pool.insert_mapping(&name, ret_ty);
                parameters.push((name, ret_ty.clone()));
            }
        }

        let mut inline = false;
        if !self.env_mut().reached_inline_function_limit(u) && bool::arbitrary(u)? {
            inline = true;
            self.env_mut().inc_inline_func_counter();
        }

        Ok(FunctionSignature {
            inline,
            type_parameters: TypeParameters { type_parameters },
            name,
            parameters,
            return_type,
            acquires: BTreeSet::new(),
        })
    }

    /// Generate a type parameter with random abilities.
    /// Abilities in `include` will always be included.
    /// Abilities in `exclude` will not be used.
    fn generate_type_parameter(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        allow_phantom: bool,
        include: Option<Vec<Ability>>,
        exclude: Option<Vec<Ability>>,
    ) -> Result<TypeParameter> {
        let (name, _) = self.get_next_identifier(IDKinds::TypeParameter, parent_scope);

        let is_phantom = match allow_phantom {
            true => bool::arbitrary(u)?,
            false => false,
        };

        let mut abilities = Vec::new();
        let inc = include.unwrap_or_default();
        let exc = exclude.unwrap_or_default();

        // Choose abilities
        for i in [Ability::Copy, Ability::Drop, Ability::Store, Ability::Key].into_iter() {
            if exc.contains(&i) {
                continue;
            }

            if inc.contains(&i) || bool::arbitrary(u)? {
                abilities.push(i);
            }
        }

        let tp = TypeParameter {
            name: name.clone(),
            abilities,
            is_phantom,
        };

        let type_for_tp = Type::TypeParameter(tp.clone());

        // Register the type parameter so that its siblings can reference it
        self.env_mut().type_pool.register_type(type_for_tp.clone());

        // Links the type parameter to its name so that later we can
        // retrieve the type from the name
        self.env_mut()
            .type_pool
            .insert_mapping(&type_for_tp.get_name(), &type_for_tp);

        Ok(tp)
    }

    /// Generate an expression block
    fn generate_block(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        num_stmts: Option<usize>,
        ret_typ: Option<Type>,
    ) -> Result<Block> {
        trace!(
            "Generating block with parent scope: {:?}, depth: {}",
            parent_scope,
            self.env().expr_depth.curr_depth()
        );
        let (name, block_scope) = self.get_next_identifier(IDKinds::Block, parent_scope);
        trace!("Created block scope: {:?}", block_scope);

        let reach_limit = self.env().expr_depth.will_reached_depth_limit(1);
        let stmts = if reach_limit {
            warn!("Max expr depth will be reached in this block, skipping generating body");
            Vec::new()
        } else {
            let num_stmts =
                num_stmts.unwrap_or(self.env_mut().config.num_stmts_in_block.select_once(u)?);
            trace!("Generating {} statements for block", num_stmts);
            self.generate_statements(u, &block_scope, num_stmts)?
        };
        let return_expr = match ret_typ {
            Some(ref typ) => Some(self.generate_block_return(u, &block_scope, typ)?),
            None => None,
        };
        trace!("Done generating block: {:?}", block_scope);
        Ok(Block {
            name,
            stmts,
            return_expr,
        })
    }

    /// Generate a return expression
    /// Prefer to return a variable in scope if possible
    fn generate_block_return(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        typ: &Type,
    ) -> Result<Expression> {
        let var_acc = self.generate_varible_access(u, parent_scope, false, Some(typ))?;
        match var_acc {
            Some(va) => Ok(Expression::Variable(va)),
            None => Ok(self.generate_expression_of_type(u, parent_scope, typ, true, true)?),
        }
    }

    /// Generate a list of statements.
    fn generate_statements(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        num_stmts: usize,
    ) -> Result<Vec<Statement>> {
        let mut stmts = Vec::new();
        let mut num_addtional = self
            .env_mut()
            .config
            .num_additional_operations_in_func
            .select_once(u)?;
        trace!(
            "NUM: generating {} statements with {} additional operations",
            num_stmts,
            num_addtional
        );

        for i in 0..num_stmts {
            trace!("Generating statement #{}", i + 1);
            if num_addtional > 0 && bool::arbitrary(u)? {
                stmts.push(self.generate_additional_operation(u, parent_scope)?);
                num_addtional -= 1;
            } else {
                stmts.push(self.generate_statement(u, parent_scope)?);
            }

            trace!("Done generating statement #{}", i + 1);
        }
        Ok(stmts)
    }

    fn generate_additional_operation(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<Statement> {
        Ok(match bool::arbitrary(u)? {
            true => self.generate_resource_operation(u, parent_scope)?,
            false => self.generate_vector_operation(u, parent_scope)?,
        })
    }

    /// Generate a random statement.
    fn generate_statement(&self, u: &mut Unstructured, parent_scope: &Scope) -> Result<Statement> {
        let weights = vec![6, 4, 6];
        let idx = choose_idx_weighted(u, &weights)?;
        match idx {
            0 => Ok(Statement::Decl(self.generate_declaration(u, parent_scope)?)),
            1 => Ok(Statement::Expr(self.generate_expression(u, parent_scope)?)),
            2 => Ok(self.generate_vector_operation(u, parent_scope)?),
            _ => panic!("Invalid statement type"),
        }
    }

    fn generate_new_vector_literal(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<Statement> {
        let (name, _) = self.get_next_identifier(IDKinds::Var, parent_scope);

        let weight = [
            10, // Random type empty vector
            10, // Random type non-empty vector
            5,  // Byte string
            5,  // Hex string
        ];
        let idx = choose_idx_weighted(u, &weight)?;

        // Generate element type and record return type in environment
        let elem_typ = match idx {
            0 | 1 => {
                let typ = self.get_random_type(u, parent_scope, true, true, true, true, false)?;
                let con_typ = self
                    .concretize_type(u, &typ, parent_scope, vec![], None)
                    .unwrap_or(typ);
                self.env_mut()
                    .type_pool
                    .insert_mapping(&name, &Type::Vector(Box::new(con_typ.clone())));
                con_typ
            },
            2 | 3 => {
                self.env_mut()
                    .type_pool
                    .insert_mapping(&name, &Type::Vector(Box::new(Type::U8)));
                Type::U8
            },
            _ => panic!("Invalid new vector type"),
        };

        let literal = match idx {
            0 => VectorLiteral::Empty(elem_typ.clone()),
            1 => {
                let typ = elem_typ.clone();
                let mut elems = vec![];
                // Choose a small size for the initial vector length
                for _ in 0..u.int_in_range(1..=3)? {
                    // Do not generate too large expressions for vector elements
                    self.env_mut().expr_depth.set_max_depth(2);
                    elems.push(self.generate_expression_of_type(
                        u,
                        parent_scope,
                        &typ,
                        true,
                        false,
                    )?);
                    self.env_mut().expr_depth.reset_max_depth();
                }
                VectorLiteral::Multiple(typ, elems)
            },
            2 => {
                let mut s = String::new();
                let num_bytes = self.env().config.hex_byte_str_size.select(u)?;
                for _ in 0..num_bytes {
                    if u.int_in_range(0..=10)? > 8 {
                        // Choose an escape character
                        let idx = u.int_in_range(0..=6)?;
                        let hex_escape = match idx {
                            6 => format!("\\x{:02x}", u8::arbitrary(u)?),
                            _ => String::new(),
                        };

                        let c = match idx {
                            0 => "\\n",
                            1 => "\\r",
                            2 => "\\t",
                            3 => "\\\\",
                            4 => "\\0",
                            5 => "\\\"",
                            6 => &hex_escape,
                            _ => panic!("Invalid escape character choice"),
                        };
                        s.push_str(c);
                    } else {
                        // Choose a random ascii
                        let c = u.int_in_range(32..=126)? as u8 as char;
                        if c == '"' || c == '\\' {
                            s.push('\\');
                        }
                        s.push(c);
                    }
                }
                VectorLiteral::ByteString(s)
            },
            3 => {
                let mut hex = String::new();
                let num_bytes = self.env().config.hex_byte_str_size.select(u)?;
                for _ in 0..num_bytes {
                    hex.push_str(&format!("{:02x}", u8::arbitrary(u)?));
                }
                VectorLiteral::HexString(hex)
            },
            _ => panic!("Invalid vector operation"),
        };
        trace!("Generated new vector literal: {}", literal.inline());
        Ok(Statement::Decl(Declaration {
            names: vec![name],
            typs: vec![Type::Vector(Box::new(elem_typ))],
            value: Some(Expression::VectorLiteral(literal)),
            emit_type: true,
        }))
    }

    fn generate_vector_operation(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<Statement> {
        use Expression as E;
        use VectorOperationKind::*;

        let op = self.random_vector_operation_kind(u)?;
        trace!("Generating vector operation: {:?}", op);

        let vec_ids = self.env().get_vector_identifiers(None, parent_scope);
        trace!("Available vector identifiers: {:?}", vec_ids);

        // Create vectors first, 3 is arbitrarily chosen
        let num_vecs_needed = match op {
            Empty | Singleton => 0,
            Append => 2,
            _ => 1,
        };

        if vec_ids.len() < num_vecs_needed {
            trace!("Creating new vector, now has: {}", vec_ids.len());
            return self.generate_new_vector_literal(u, parent_scope);
        }

        let (vec_id, elem_typ) = match op.op_use_vec_type() {
            // The opreation does not require a vector to be present
            // In this case, we need to pick a random concretized type for the new vector
            VecOpVecType::None => {
                let vec_id = Identifier::new_str("placeholder", IDKinds::Var);
                let typ = self.get_random_type(u, parent_scope, true, true, true, true, false)?;
                let elem_typ = self
                    .concretize_type(u, &typ, parent_scope, vec![], None)
                    .unwrap_or(typ);
                (vec_id, elem_typ)
            },
            // The operation work on an existing vector
            _ => {
                assert!(!vec_ids.is_empty());
                let vec_id = u.choose(&vec_ids)?.clone();
                let elem_typ = match self.env().type_pool.get_type(&vec_id) {
                    Some(Type::Vector(inner)) => inner.as_ref().clone(),
                    _ => panic!("Invalid vector type"),
                };
                (vec_id, elem_typ)
            },
        };

        let var_acc = E::Variable(VariableAccess {
            name: vec_id.clone(),
            copy: false,
        });

        let mut args = match op.op_use_vec_type() {
            VecOpVecType::None => vec![],
            VecOpVecType::Own => vec![var_acc],
            VecOpVecType::Ref => vec![E::Reference(Box::new(var_acc))],
            VecOpVecType::MutRef => vec![E::MutReference(Box::new(var_acc))],
        };

        if matches!(op, Append) {
            let mut other_vec_ids = self.env().get_vector_identifiers(
                Some(&Type::Vector(Box::new(elem_typ.clone()))),
                parent_scope,
            );
            other_vec_ids.retain(|id| id != &vec_id);
            if other_vec_ids.is_empty() {
                trace!(
                    "Cannot find another vector to append to, defaulting to generating a new vector"
                );
                return self.generate_new_vector_literal(u, parent_scope);
            } else {
                let other_vec_id = u.choose(&other_vec_ids)?.clone();
                args.push(E::Variable(VariableAccess {
                    name: other_vec_id,
                    copy: false,
                }));
            }
        }

        for arg_type in op.args_types(&elem_typ) {
            // Do not generate too large expressions for vector operation arguments
            self.env_mut().expr_depth.set_max_depth(2);
            args.push(self.generate_expression_of_type(u, parent_scope, &arg_type, true, false)?);
            self.env_mut().expr_depth.reset_max_depth();
        }

        trace!(
            "Generated arguments for vector operation {:?}: {:?}",
            op,
            args
        );

        let ret_typs = match op.ret_type(&elem_typ) {
            None => vec![],
            Some(Type::Tuple(typs)) => typs,
            Some(typ) => vec![typ],
        };

        let mut ret_ids = vec![];
        for ret_typ in &ret_typs {
            let (name, _) = self.get_next_identifier(IDKinds::Var, parent_scope);
            self.env_mut().live_vars.mark_alive(parent_scope, &name);
            // record the return typ
            self.env_mut().type_pool.insert_mapping(&name, ret_typ);
            ret_ids.push(name);
        }

        let vec_expr = E::VectorOperation(VectorOperation { elem_typ, op, args });

        Ok(match ret_ids.is_empty() {
            true => Statement::Expr(vec_expr),
            false => Statement::Decl(Declaration {
                names: ret_ids,
                typs: ret_typs,
                value: Some(vec_expr),
                emit_type: true,
            }),
        })
    }

    fn random_vector_operation_kind(&self, u: &mut Unstructured) -> Result<VectorOperationKind> {
        use VectorOperationKind::*;
        let op_weights = vec![
            (Empty, 15),
            (Singleton, 15),
            (Length, 10),
            (Borrow, 10),
            (BorrowMut, 10),
            (PushBack, 10),
            (PopBack, 2),
            (DestroyEmpty, 2),
            (Swap, 10),
            (Reverse, 10),
            (Append, 10),
            (IsEmpty, 10),
            (Contains, 10),
            (IndexOf, 10),
            (Remove, 5),
            (SwapRemove, 5),
        ];
        choose_item_weighted(u, &op_weights)
    }

    fn generate_resource_operation(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<Statement> {
        use ResourceOperationKind as RK;
        let kind = RK::arbitrary(u)?;

        let name = match kind {
            // Only move_to does not return a value
            RK::MoveTo => None,
            _ => {
                let (name, _) = self.get_next_identifier(IDKinds::Var, parent_scope);
                self.env_mut().live_vars.mark_alive(parent_scope, &name);

                Some(name)
            },
        };

        let typs = self.get_types_with_abilities(parent_scope, &[Ability::Key], true);
        let typ = u.choose(&typs)?.clone();
        assert!(!typ.is_some_ref());

        // Record the type for the newly declared variable
        let ret_typ = match kind {
            RK::MoveTo => None,
            RK::MoveFrom => Some(typ.clone()),
            RK::BorrowGlobal => Some(Type::Ref(Box::new(typ.clone()))),
            RK::BorrowGlobalMut => Some(Type::MutRef(Box::new(typ.clone()))),
            RK::Exists => Some(Type::Bool),
        };

        if let Some(ret_typ) = &ret_typ {
            self.env_mut()
                .type_pool
                .insert_mapping(&name.clone().unwrap(), ret_typ);
        }

        let mut args = vec![];

        if !matches!(kind, RK::MoveTo) {
            // Get address for non-move_to operations
            args.push(self.generate_expression_of_type(
                u,
                parent_scope,
                &Type::Address,
                true,
                false,
            )?);
        } else {
            // for the move_to operation, we first need a signer
            // and an item to move
            args.push(self.generate_expression_of_type(
                u,
                parent_scope,
                &Type::Ref(Box::new(Type::Signer)),
                true,
                false,
            )?);
            args.push(self.generate_expression_of_type(u, parent_scope, &typ, true, true)?);
        }

        let res_op = Expression::Resource(ResourceOperation { kind, typ, args });

        Ok(match name {
            Some(name) => Statement::Decl(Declaration {
                names: vec![name],
                typs: vec![ret_typ.unwrap()],
                value: Some(res_op),
                emit_type: true,
            }),
            None => Statement::Expr(res_op),
        })
    }

    /// Generate an assignment to an existing variable.
    ///
    /// There must be at least one variable in the scope and the type of the variable
    /// must have been decided.
    ///
    /// TODO: LHS can be an expression!!!
    fn generate_assignment(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<Option<Assignment>> {
        trace!("Generating assignment");
        let idents = self
            .env()
            .get_identifiers(None, Some(IDKinds::Var), Some(parent_scope));
        if idents.is_empty() {
            return Ok(None);
        }
        let ident = u.choose(&idents)?.clone();
        let typ = self.env().type_pool.get_type(&ident).unwrap();

        let mut deref = false;
        let rhs_typ = match typ {
            Type::MutRef(inner) => {
                deref = true;
                inner.as_ref().clone()
            },
            _ => typ,
        };

        let expr = self.generate_expression_of_type(u, parent_scope, &rhs_typ, true, true)?;

        Ok(Some(Assignment {
            name: ident,
            value: expr,
            deref,
        }))
    }

    /// Generate a random declaration.
    fn generate_declaration(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<Declaration> {
        let (name, _) = self.get_next_identifier(IDKinds::Var, parent_scope);

        // Mark newly created variable as alive
        self.env_mut().live_vars.mark_alive(parent_scope, &name);

        // TODO: we should not omit type parameter as we can call a function to get an object of that type
        let mut typ = self.get_random_type(u, parent_scope, true, true, false, false, true)?;
        trace!(
            "Generating declaration for {} of type: {:?}",
            name.inline(),
            typ.inline()
        );

        // Concretize the chosen type if needed
        if self.is_type_concretizable(&typ, parent_scope) {
            typ = self
                .concretize_type(u, &typ, parent_scope, vec![], None)
                .unwrap();
        }

        let value = Some(self.generate_expression_of_type(u, parent_scope, &typ, true, true)?);
        // Keeps track of the type of the newly created variable
        self.env_mut().type_pool.insert_mapping(&name, &typ);

        // Only ignore small portion of type annotations
        let emit_type = match u.int_in_range(0..=3)? {
            0..=2 => true,
            3 => false,
            _ => panic!("Invalid number for choosing emit_type"),
        };

        Ok(Declaration {
            typs: vec![typ],
            names: vec![name],
            value,
            emit_type,
        })
    }

    /// Generate a random top-level expression (like a statement).
    ///
    /// This is used only for generating statements, so some kinds of expressions are omitted.
    ///
    /// To avoid infinite recursion, we limit the depth of the expression tree.
    fn generate_expression(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<Expression> {
        trace!("Generating expression from scope: {:?}", parent_scope);
        // Increment the expression depth
        // Reached the maximum depth, generate a dummy number literal
        if self.env().expr_depth.reached_depth_limit() {
            warn!("Max expr depth reached in scope: {:?}", parent_scope);
            return Ok(Expression::NumberLiteral(
                self.generate_number_literal(u, None, None, None)?,
            ));
        }

        self.env_mut().expr_depth.increase_depth();

        // If no function is callable, then skip generating function calls.
        let func_call_weight = match self.get_callable_functions(parent_scope).is_empty() {
            true => 0,
            false => 10,
        };

        // Check if there are any assignable variables in the current scope
        let assign_weight = match self
            .env()
            .get_identifiers(None, Some(IDKinds::Var), Some(parent_scope))
            .is_empty()
        {
            true => 0,
            false => 5,
        };

        // Decides how often each expression type should be generated
        let weights = vec![
            3,                // BinaryOperation
            5,                // If-Else
            1,                // Block
            func_call_weight, // FunctionCall --> 0 or 10
            assign_weight,    // Assignment   --> 0 or 5
        ];

        let idx = choose_idx_weighted(u, &weights)?;
        trace!(
            "Chosing expression kind, idx chosen is {}, weight is {:?}",
            idx,
            weights
        );

        let expr = match idx {
            // Generate a binary operation
            0 => Expression::BinaryOperation(Box::new(self.generate_binary_operation(
                u,
                parent_scope,
                None,
            )?)),
            // Generate an if-else expression with unit type
            1 => Expression::IfElse(Box::new(self.generate_if(u, parent_scope, None)?)),
            // Generate a block
            2 => {
                let ret_typ = match bool::arbitrary(u)? {
                    true => {
                        Some(self.get_random_type(u, parent_scope, true, true, true, true, true)?)
                    },
                    false => None,
                };
                let block = self.generate_block(u, parent_scope, None, ret_typ)?;
                Expression::Block(Box::new(block))
            },
            // Generate a function call
            3 => {
                let call = self.generate_function_call(u, parent_scope)?;
                match call {
                    Some(c) => Expression::FunctionCall(c),
                    None => panic!("No callable functions"),
                }
            },
            // Generate an assignment expression
            4 => {
                let assign = self.generate_assignment(u, parent_scope)?;
                match assign {
                    Some(a) => Expression::Assign(Box::new(a)),
                    None => panic!("No assignable variables"),
                }
            },
            _ => panic!("Invalid expression type"),
        };

        // Decrement the expression depth
        self.env_mut().expr_depth.decrease_depth();
        Ok(expr)
    }

    // TODO: the concretization system can be simplified and moved to a separate place
    /// Concretize a type parameter or a type with type parameters.
    ///
    /// If the type cannot be concretized further (e.g. primitive,
    /// fully concretized struct, type parameters defined in current function),
    /// None will be returned.
    fn concretize_type(
        &self,
        u: &mut Unstructured,
        typ: &Type,
        parent_scope: &Scope,
        constraints: Vec<Ability>,
        parent_type: Option<&Type>,
    ) -> Option<Type> {
        trace!("Concretizing type: {:?} in scope: {:?}", typ, parent_scope);
        if !self.is_type_concretizable(typ, parent_scope) {
            trace!("Type {:?} cannot be concretized", typ);
            return None;
        }

        self.env_mut().type_depth.increase_depth();

        let concretized = match typ {
            Type::TypeParameter(tp) => {
                self.concretize_type_parameter(u, tp, parent_scope, constraints, parent_type)
            },
            Type::Struct(st) => self.concretize_struct(u, parent_scope, st, constraints),
            Type::Ref(inner) => {
                match self.concretize_type(u, inner, parent_scope, constraints, parent_type) {
                    Some(concrete_inner) => Type::Ref(Box::new(concrete_inner)),
                    None => Type::Ref(inner.clone()),
                }
            },
            Type::MutRef(inner) => {
                match self.concretize_type(u, inner, parent_scope, constraints, parent_type) {
                    Some(concrete_inner) => Type::MutRef(Box::new(concrete_inner)),
                    None => Type::Ref(inner.clone()),
                }
            },
            _ => panic!("{:?} cannot be concretized.", typ),
        };

        self.env_mut().type_depth.decrease_depth();
        trace!("Concretized type {:?} to: {:?}", typ, concretized);
        Some(concretized)
    }

    fn concretize_struct(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        st: &StructType,
        constraints: Vec<Ability>,
    ) -> Type {
        if st.type_parameters.type_parameters.is_empty() {
            return Type::new_concrete_struct(&st.name, None);
        }

        let mut type_args = Vec::new();
        for tp in st.type_parameters.type_parameters.iter() {
            // accumulate the ability requirements
            let mut constraint_union = constraints.clone();
            for ability in tp.abilities.iter() {
                if !constraint_union.contains(ability) {
                    constraint_union.push(ability.clone());
                }
            }

            // Try to concretize the type and check if the concretized type
            // will create a cycle, if so, retry concretziation
            let concretized: Option<Type> = loop {
                let candidate = self.concretize_type(
                    u,
                    &Type::TypeParameter(tp.clone()),
                    parent_scope,
                    constraint_union.clone(),
                    Some(&Type::Struct(st.clone())),
                );
                match &candidate {
                    Some(c) => {
                        if !self.check_struct_reachable(c, &st.name, None) {
                            break candidate;
                        }
                    },
                    None => break candidate,
                }
            };
            match concretized {
                Some(c) => type_args.push(c),
                // TP is not concretizable: it's a local type parameter
                None => type_args.push(Type::TypeParameter(tp.clone())),
            }
        }

        Type::new_concrete_struct(&st.name, Some(&TypeArgs { type_args }))
    }

    /// The given `tp` must be concretizable!!!
    ///
    /// Find all types in scope (including non-concrete types) that
    ///     1. Satisfy the constraints
    ///     2. Satisfy the requirement of the type parameter
    ///
    /// Randomly choose one type.
    ///
    /// If the chosen one is a non-concrete, return it.
    ///
    /// If the chosen one is a non-concrete,concretize the chosen type with
    /// the union of the required abilities of the type parameter and the original constraints.
    ///
    fn concretize_type_parameter(
        &self,
        u: &mut Unstructured,
        tp: &TypeParameter,
        parent_scope: &Scope,
        mut constraints: Vec<Ability>,
        parent_type: Option<&Type>,
    ) -> Type {
        // TODO: better to use set... but this will never get large
        for ability in tp.abilities.iter() {
            if !constraints.contains(ability) {
                constraints.push(ability.clone());
            }
        }

        // !!! We didn't check if the choices are empty
        // !!! The assumption is that we can find a concrete type that satisfies
        // !!! the constraints of the type parameter.
        // !!! This is ensured because we insert a struct with all abilities
        // !!! to all modules
        let mut choices = self.get_types_with_abilities(parent_scope, &constraints, true);
        if self.env().type_depth.reached_depth_limit() {
            warn!("Max type depth reached, choosing concrete types");
            choices.retain(|t| t.is_concrete())
        }
        // When concretizing a field whose type is a type parameter, we need to make sure
        // the concretized type does not create a loop
        if let Some(parent_typ) = parent_type {
            choices.retain(|t| !self.check_struct_reachable(t, &parent_typ.get_name(), None))
        }
        let chosen = u.choose(&choices).unwrap().clone();

        match self.is_type_concretizable(&chosen, parent_scope) {
            true => self
                .concretize_type(u, &chosen, parent_scope, constraints, parent_type)
                .unwrap(),
            false => chosen,
        }
    }

    // Check whether a type can be further concretized
    // For primitive types, no
    // For structs, TODO
    // For type parameters, if it is immediately defined in the parent scope,
    // then we cannot further concretize it.
    // If it is defined else where (e.g. struct definition), we can further
    // concretize it using concrete types or local type parameters.
    fn is_type_concretizable(&self, typ: &Type, parent_scope: &Scope) -> bool {
        match typ {
            Type::TypeParameter(_) => {
                // Check if the type parameter is define in parent scope
                let tp_scope = self
                    .env()
                    .id_pool
                    .get_parent_scope_of(&typ.get_name())
                    .unwrap();
                let calling_func_scope = parent_scope.remove_hidden_scopes();
                // The type parameter can be further concretized if it's not
                // defined immediately in the parent_scope
                tp_scope != calling_func_scope
            },
            Type::Struct(st) => !st.type_parameters.type_parameters.is_empty(),
            Type::Ref(inner) => self.is_type_concretizable(inner, parent_scope),
            Type::MutRef(inner) => self.is_type_concretizable(inner, parent_scope),
            _ => false,
        }
    }

    /// Generate a return expression
    /// If `typ` is None, will return ()
    fn generate_return_expr(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<Expression> {
        let sig = self.env().curr_func_signature.clone();
        let inner = match sig {
            Some(sig) => match sig.return_type {
                Some(t) => Some(Box::new(self.generate_expression_of_type(
                    u,
                    parent_scope,
                    &t,
                    true,
                    true,
                )?)),
                None => None,
            },
            None => None,
        };

        Ok(Expression::Return(inner))
    }

    /// Generate an abort expression with an expression of type `U64` as the abort code.
    fn generate_abort(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        code: Option<u64>,
    ) -> Result<Expression> {
        let code = Box::new(match code {
            Some(c) => Expression::NumberLiteral(NumberLiteral {
                value: BigUint::from(c),
                typ: Type::U64,
            }),
            None => self.generate_expression_of_type(u, parent_scope, &Type::U64, true, true)?,
        });
        Ok(Expression::Abort(code))
    }

    /// Generate an expression of the given type or its subtype.
    ///
    /// `allow_var`: allow using variable access, this is disabled for script
    /// `allow_call`: allow using function calls
    fn generate_expression_of_type(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        typ: &Type,
        allow_var: bool,
        allow_call: bool,
    ) -> Result<Expression> {
        trace!("Remaining length of the input: {}", u.len());
        if u.len() > 16 {
            let bytes = u.peek_bytes(16).unwrap();
            let hex_string: String = bytes.iter().fold(String::new(), |mut acc, byte| {
                write!(&mut acc, "{:02x}", byte).unwrap();
                acc
            });
            trace!("Next few bytes: 0x{}", hex_string);
        }
        if self.env().check_timeout() {
            // Just return a random error...
            return Err(Error::IncorrectFormat);
        }
        trace!(
            "Generating expression of type {:?} in scope {:?}",
            typ,
            parent_scope
        );
        // Check whether the current type pool contains a concrete type
        // for the given type parameter.
        // If so, directly use the concrete type.
        let concrete_type = if let Type::TypeParameter(_) = typ {
            self.env().type_pool.get_concrete_type(&typ.get_name())
        } else {
            None
        };

        let typ = match &concrete_type {
            Some(concrete) => concrete,
            None => typ,
        };
        trace!("Concretized type is: {:?}", typ);

        // Check for `&signer` and `address` types
        // We hardcode these two types
        match typ {
            Type::Ref(inner) => {
                if let Type::Signer = inner.as_ref() {
                    return Ok(Expression::Variable(VariableAccess {
                        name: self.env().type_pool.get_signer_ref_var(),
                        copy: false,
                    }));
                }
            },
            Type::Address => {
                return Ok(Expression::Variable(VariableAccess {
                    name: self.env().type_pool.get_address_var(),
                    copy: false,
                }))
            },
            _ => (),
        }

        // Store default choices that do not require recursion
        // If other options are available, will not use these
        let mut default_choices: Vec<Expression> = Vec::new();
        // Store candidate expressions for the given type
        let mut choices: Vec<Expression> = Vec::new();

        // Directly generate a value for basic types
        let some_candidate = match typ {
            Type::U8 | Type::U16 | Type::U32 | Type::U64 | Type::U128 | Type::U256 => {
                Some(Expression::NumberLiteral(self.generate_number_literal(
                    u,
                    Some(typ),
                    None,
                    None,
                )?))
            },
            Type::Bool => Some(Expression::Boolean(bool::arbitrary(u)?)),
            Type::Struct(st) => Some(self.generate_struct_pack(u, parent_scope, &st.name)?),
            Type::StructConcrete(st) => {
                Some(self.generate_struct_pack_concrete(u, parent_scope, st)?)
            },
            // Here we always try to concretize the type.
            // It's tricky to avoid infinite loop:
            // If the type is concretized, then it's guarenteed that the call to
            // `generate_expression_of_type` will not hit this branch and enter
            // the true branch of `if` again, so we don't need to increment the counter.
            // If the type is already fully conretized, then we do not need to generate
            // a candidate because some candidate must have been generated from
            // creating new object or from variables.
            // However, we must assert that `allow_var` is enabled.
            Type::TypeParameter(_) => {
                if let Some(concretized) = self.concretize_type(u, typ, parent_scope, vec![], None)
                {
                    Some(self.generate_expression_of_type(
                        u,
                        parent_scope,
                        &concretized,
                        allow_var,
                        allow_call,
                    )?)
                } else {
                    // In this branch, we have a type parameter that cannot be
                    // further concretized, thus the only expression we can
                    // generate is to access a variable of this type
                    assert!(allow_var);
                    None
                }
            },
            // We handle references separately after checking for variables
            Type::Ref(_) => None,
            Type::MutRef(_) => None,
            Type::Vector(_) => {
                assert!(allow_var || allow_call);
                None
            },
            _ => unimplemented!(),
        };

        if let Some(candidate) = some_candidate {
            if let Type::TypeParameter(_) = typ {
                // Keep the expression for the concrete type
                choices.push(candidate.clone());
            }
            default_choices.push(candidate);
        }

        // Access identifier with the given type
        if allow_var {
            let var_acc = self.generate_varible_access(u, parent_scope, true, Some(typ));
            if let Some(va) = var_acc? {
                let expr = Expression::Variable(va);
                default_choices.push(expr.clone());
                choices.push(expr);
            }
        }

        // If the default choice is empty here and we are working on a
        // reference type but cannot find a variable, in this case, we could
        // generate the inner type.
        //
        // If the type if not a reference, we need to faul back to abort
        if default_choices.is_empty() {
            trace!(
                "No default choices for type: {} <-- should be a ref",
                typ.inline()
            );
            let ref_expr = match typ {
                Type::Ref(inner) => Some(Expression::Reference(Box::new(
                    self.generate_expression_of_type(
                        u,
                        parent_scope,
                        inner,
                        allow_var,
                        allow_call,
                    )?,
                ))),
                Type::MutRef(inner) => Some(Expression::MutReference(Box::new(
                    self.generate_expression_of_type(
                        u,
                        parent_scope,
                        inner,
                        allow_var,
                        allow_call,
                    )?,
                ))),
                _ => None,
            };
            if let Some(e) = ref_expr {
                default_choices.push(e.clone());
                choices.push(e);
            } else {
                // Abort can always be treated as a default choice for any type
                default_choices.push(self.generate_abort(u, parent_scope, Some(112233))?);
            }
        }

        // Now we have collected all candidate expressions that do not require recursion
        // We can perform the expr_depth check here
        assert!(
            !default_choices.is_empty(),
            "No default choices for type: {:?}",
            typ
        );
        if self.env().expr_depth.reached_depth_limit() {
            warn!("Max expr depth reached while gen expr of type: {:?}", typ);
            return Ok(u.choose(&default_choices)?.clone());
        }

        self.env_mut().expr_depth.increase_depth();

        // TODO: merge this into the other selections
        if u.ratio(
            (self.env().config.return_abort_possibility * 1000.0) as u64,
            1000u64,
        )? {
            let can_use_return = match &self.env().curr_func_signature {
                Some(sig) => !sig.inline,
                None => false,
            };

            let expr = if can_use_return && bool::arbitrary(u)? {
                self.generate_return_expr(u, parent_scope)
            } else {
                self.generate_abort(u, parent_scope, None)
            };

            self.env_mut().expr_depth.decrease_depth();
            return expr;
        }

        let callables: Vec<FunctionSignature> = self
            .get_callable_functions(parent_scope)
            .into_iter()
            .filter(|f| f.return_type == Some(typ.clone()))
            .collect();

        let func_call_weight = match (allow_call, !callables.is_empty()) {
            (true, true) => 5,
            (_, _) => 0,
        };

        let binop_weight = match typ.is_num_or_bool() {
            true => 5,
            false => 0,
        };

        // Since we cannot have ref to ref, we cannot use a deref to get a ref
        // i.e. here if we want a `u8`, deref can give us `*(var1)` if `var1` is `&u8`
        // but we cannot get `&u8` from deref
        let deref_weight = match typ.is_some_ref() {
            true => 0,
            false => 2,
        };

        let weights = vec![
            2,                // If-Else
            func_call_weight, // FunctionCall
            binop_weight,     // BinaryOperation
            deref_weight,     // Dereference
        ];

        let idx = choose_idx_weighted(u, &weights)?;
        trace!(
            "Selecting expression of type kind, idx is {}, weights: {:?}",
            idx,
            weights
        );
        match idx {
            0 => {
                let if_else = self.generate_if(u, parent_scope, Some(typ.clone()))?;
                choices.push(Expression::IfElse(Box::new(if_else)));
            },
            1 => {
                assert!(!callables.is_empty());
                let func = u.choose(&callables)?;
                let call =
                    self.generate_call_to_function(u, parent_scope, func, Some(typ), true)?;
                choices.push(Expression::FunctionCall(call));
            },
            2 => {
                // Generate a binary operation with the given type
                // Binary operations can output numerical and boolean values
                assert!(typ.is_num_or_bool());
                let binop = self.generate_binary_operation(u, parent_scope, Some(typ.clone()))?;
                choices.push(Expression::BinaryOperation(Box::new(binop)));
            },
            3 => {
                // Generate a dereference expression
                assert!(!typ.is_ref());
                let deref = self.generate_dereference(u, parent_scope, typ)?;
                choices.push(deref);
            },
            _ => panic!("Invalid option for expression generation"),
        };

        // Decrement the expression depth
        self.env_mut().expr_depth.decrease_depth();

        let use_choice = match choices.is_empty() {
            true => default_choices,
            false => choices,
        };
        Ok(u.choose(&use_choice)?.clone())
    }

    /// Generate a valid varibale access
    /// If `typ` is given, the chosen varibale will have the same type.
    #[allow(unused_assignments)]
    fn generate_varible_access(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        allow_copy: bool,
        typ: Option<&Type>,
    ) -> Result<Option<VariableAccess>> {
        let idents = self.env().live_variables(parent_scope, typ);
        // No live variable to use in the scope
        // TODO: consider generate a declaration with assignment here?
        if idents.is_empty() {
            return Ok(None);
        }

        let chosen = u.choose(&idents)?.clone();
        let abilities = self.derive_abilities_of_var(&chosen);

        // Randomly choose to explicitly copy or not
        let mut copy = if allow_copy && abilities.contains(&Ability::Copy) {
            bool::arbitrary(u)?
        } else {
            false
        };

        // Use copy always to avoid running out of instanecs of type parameters
        copy = true;

        if !copy {
            self.env_mut().live_vars.mark_moved(parent_scope, &chosen);
        } else {
            warn!("{:?} does not have copy ability", chosen);
        }

        // Note: since we assume everything is copyable, we can arbitrarily
        // drop the copy annotation.
        if bool::arbitrary(u)? {
            copy = false;
        }

        Ok(Some(VariableAccess { name: chosen, copy }))
    }

    /// Generate a deference expression of type `typ`
    ///
    /// This function will try to select an existing variable to dereference if possible.
    ///
    /// If no variable is available, it will generate a new expression that is the reference
    /// of the gien type.
    fn generate_dereference(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        typ: &Type,
    ) -> Result<Expression> {
        let mut idents = self.env().live_variables(parent_scope, Some(typ));

        let ref_typ = Type::Ref(Box::new(typ.clone()));
        // TODO: if things are not copyable by default, we need to check for copy here
        idents.retain(|i| self.env().type_pool.get_type(i).unwrap() == ref_typ);

        let inner_expr = match idents.is_empty() {
            true => self.generate_expression_of_type(u, parent_scope, &ref_typ, true, true)?,
            false => {
                let chosen = u.choose(&idents)?.clone();
                Expression::Variable(VariableAccess {
                    name: chosen,
                    copy: false,
                })
            },
        };
        Ok(Expression::Dereference(Box::new(inner_expr)))
    }

    /// Generate an If expression
    /// `typ` is the expected type of the expression.
    /// If `typ` is None, the type of the If will be unit and whether to have an
    /// else expression is randomly decided.
    ///
    /// If `typ` is not None, both If and Else will be generated with the same type.
    fn generate_if(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        typ: Option<Type>,
    ) -> Result<IfExpr> {
        trace!("Generating if expression of type: {:?}", typ);
        let typ = match &typ {
            Some(t) => match self.is_type_concretizable(t, parent_scope) {
                true => Some(
                    self.concretize_type(u, t, parent_scope, vec![], None)
                        .unwrap(),
                ),
                false => Some(t.clone()),
            },
            None => None,
        };
        trace!("Generating if expression with concretized type: {:?}", typ);

        trace!("Generating condition for if expression");
        let condition =
            self.generate_expression_of_type(u, parent_scope, &Type::Bool, true, true)?;

        trace!("Generating block for if true branch");
        let body = self.generate_block(u, parent_scope, None, typ.clone())?;

        // When the If expression has a non-unit type
        // We have to generate an Else expression to match the type
        let else_expr = match (&typ, bool::arbitrary(u)?) {
            (Some(_), _) => Some(self.generate_else(u, parent_scope, typ.clone())?),
            (None, true) => Some(self.generate_else(u, parent_scope, None)?),
            (None, false) => None,
        };

        Ok(IfExpr {
            condition,
            body,
            else_expr,
        })
    }

    /// Generate an Else expression.
    /// The `typ` should be the same as the expected type of the previous If expression.
    fn generate_else(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        typ: Option<Type>,
    ) -> Result<ElseExpr> {
        trace!("Generating block for else branch");
        let body = self.generate_block(u, parent_scope, None, typ.clone())?;
        Ok(ElseExpr { typ, body })
    }

    /// Generate a random binary operation.
    /// `typ` can specify the desired output type.
    /// `typ` can only be a basic numerical type or boolean.
    fn generate_binary_operation(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        typ: Option<Type>,
    ) -> Result<BinaryOperation> {
        trace!("Generating binary operation");
        let chosen_typ = match typ {
            Some(t) => match t.is_num_or_bool() {
                true => t,
                false => panic!("Invalid type for binary operation"),
            },
            None => self.get_random_type(u, parent_scope, true, false, false, false, false)?,
        };

        if chosen_typ.is_bool() {
            let weights = vec![
                2, // num op
                3, // bool op
                5, // equality check
            ];
            match choose_idx_weighted(u, &weights)? {
                0 => self.generate_numerical_binop(u, parent_scope, Some(chosen_typ)),
                1 => self.generate_boolean_binop(u, parent_scope),
                2 => self.generate_equality_check(u, parent_scope, None),
                _ => panic!("Invalid option for binary operation"),
            }
        } else {
            self.generate_numerical_binop(u, parent_scope, Some(chosen_typ))
        }
    }

    /// Generate a random binary operation for numerical types
    /// Tries to reduce the chance of abort, but aborts can still happen
    /// If `typ` is provided, the generated expr will have this type
    /// `typ` can only be a basic numerical type or boolean.
    fn generate_numerical_binop(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        typ: Option<Type>,
    ) -> Result<BinaryOperation> {
        use NumericalBinaryOperator as OP;
        // Select the operator
        let op = match &typ {
            // A desired output type is specified
            Some(typ) => {
                let ops = match (typ.is_numerical(), typ.is_bool()) {
                    // The output should be numerical
                    (true, false) => vec![
                        OP::Add,
                        OP::Sub,
                        OP::Mul,
                        OP::Mod,
                        OP::Div,
                        OP::BitAnd,
                        OP::BitOr,
                        OP::BitXor,
                        OP::Shl,
                        OP::Shr,
                    ],
                    // The output should be boolean
                    (false, true) => vec![OP::Le, OP::Ge, OP::Leq, OP::Geq],
                    // Numerical Binop cannot produce other types
                    (false, false) => panic!("Invalid output type for num binop"),
                    // A type cannot be both numerical and boolean
                    (true, true) => panic!("Impossible type"),
                };
                u.choose(&ops)?.clone()
            },
            // No desired type, all operators are allowed
            None => OP::arbitrary(u)?,
        };

        let typ = match &typ {
            Some(Type::U8) | Some(Type::U16) | Some(Type::U32) | Some(Type::U64)
            | Some(Type::U128) | Some(Type::U256) => typ.unwrap(),
            // To generate a boolean, we can select any numerical type
            // If a type is not provided, we also randomly select a numerical type
            Some(Type::Bool) | None => {
                self.get_random_type(u, parent_scope, false, false, false, false, false)?
            },
            Some(_) => panic!("Invalid type"),
        };
        let (lhs, rhs) = match op {
            // Sum can overflow. Sub can underflow.
            // To reduce the chance these happend, only pick a RHS from a smaller type.
            // TODO: currently RHS can only be a number literal
            // TODO: once casting is supported, we can pick a variable with a smaller type
            OP::Add | OP::Sub => {
                let lhs = self.generate_expression_of_type(u, parent_scope, &typ, true, true)?;
                let value = match typ {
                    Type::U8 => BigUint::from(u.int_in_range(0..=127)? as u32),
                    Type::U16 => BigUint::from(u8::arbitrary(u)?),
                    Type::U32 => BigUint::from(u16::arbitrary(u)?),
                    Type::U64 => BigUint::from(u32::arbitrary(u)?),
                    Type::U128 => BigUint::from(u64::arbitrary(u)?),
                    Type::U256 => BigUint::from(u128::arbitrary(u)?),
                    _ => panic!("Invalid type"),
                };
                let rhs = Expression::NumberLiteral(NumberLiteral {
                    value,
                    typ: typ.clone(),
                });
                (lhs, rhs)
            },
            // The result can overflow, we choose u8 for RHS to be extra safe
            // TODO: can also try casting
            OP::Mul => {
                let lhs = self.generate_expression_of_type(u, parent_scope, &typ, true, true)?;
                let rhs = Expression::NumberLiteral(NumberLiteral {
                    value: BigUint::from(u.int_in_range(0..=255)? as u32),
                    typ: typ.clone(),
                });
                (lhs, rhs)
            },
            // RHS cannot be 0
            OP::Mod | OP::Div => {
                let lhs = self.generate_expression_of_type(u, parent_scope, &typ, true, true)?;
                let rhs = Expression::NumberLiteral(self.generate_number_literal(
                    u,
                    Some(&typ),
                    Some(BigUint::from(1u32)),
                    None,
                )?);
                (lhs, rhs)
            },
            // RHS should be U8
            // Number of bits to shift should be less than the number of bits in LHS
            OP::Shl | OP::Shr => {
                let num_bits = match typ {
                    Type::U8 => 8,
                    Type::U16 => 16,
                    Type::U32 => 32,
                    Type::U64 => 64,
                    Type::U128 => 128,
                    Type::U256 => 256,
                    _ => panic!("Invalid type"),
                };
                let num_shift = u.int_in_range(0..=num_bits - 1)? as u32;
                let lhs = self.generate_expression_of_type(u, parent_scope, &typ, true, true)?;
                let rhs = Expression::NumberLiteral(NumberLiteral {
                    value: BigUint::from(num_shift),
                    typ: Type::U8,
                });
                (lhs, rhs)
            },
            // The rest is ok as long as LHS and RHS are the same type
            _ => {
                let lhs = self.generate_expression_of_type(u, parent_scope, &typ, true, true)?;
                let rhs = self.generate_expression_of_type(u, parent_scope, &typ, true, true)?;
                (lhs, rhs)
            },
        };
        Ok(BinaryOperation {
            op: BinaryOperator::Numerical(op.clone()),
            lhs,
            rhs,
        })
    }

    /// Generate a random binary operation for boolean
    fn generate_boolean_binop(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<BinaryOperation> {
        let op = BooleanBinaryOperator::arbitrary(u)?;
        let lhs = self.generate_expression_of_type(u, parent_scope, &Type::Bool, true, true)?;
        let rhs = self.generate_expression_of_type(u, parent_scope, &Type::Bool, true, true)?;
        Ok(BinaryOperation {
            op: BinaryOperator::Boolean(op),
            lhs,
            rhs,
        })
    }

    /// Generate an equality check expression.
    /// `typ` can specify the desired type for both operands.
    /// If `typ` is not provided, it will be randomly selected.
    fn generate_equality_check(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        typ: Option<Type>,
    ) -> Result<BinaryOperation> {
        trace!(
            "Generating equality check with desired operand type: {:?}",
            typ
        );
        let op = EqualityBinaryOperator::arbitrary(u)?;
        let mut chosen_typ = match typ {
            Some(t) => t,
            None => self.get_random_type(u, parent_scope, true, true, true, true, true)?,
        };
        if self.is_type_concretizable(&chosen_typ, parent_scope) {
            chosen_typ = self
                .concretize_type(u, &chosen_typ, parent_scope, vec![], None)
                .unwrap();
        }
        trace!("Chosen operand type for equality check: {:?}", chosen_typ);
        let lhs = self.generate_expression_of_type(u, parent_scope, &chosen_typ, true, true)?;
        let rhs = self.generate_expression_of_type(u, parent_scope, &chosen_typ, true, true)?;
        Ok(BinaryOperation {
            op: BinaryOperator::Equality(op),
            lhs,
            rhs,
        })
    }

    /// Generate a struct initialization expression.
    /// This is `pack` in the parser AST.
    fn generate_struct_pack(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        struct_name: &Identifier,
    ) -> Result<Expression> {
        trace!("Generating struct pack for {:?}", struct_name.inline());
        let struct_def = self
            .get_struct_definition_with_identifier(struct_name)
            .unwrap();

        // First we concretize the type parameters of the struct
        let (type_args, unregister) = self.concretize_type_parameters(
            u,
            parent_scope,
            &struct_def.type_parameters,
            None,
            Some(&struct_def.get_type()),
        )?;

        // Generate expressions for each field
        let mut fields = Vec::new();
        for (name, typ) in struct_def.fields.iter() {
            let expr = self.generate_expression_of_type(u, parent_scope, typ, true, true)?;
            fields.push((name.clone(), expr));
        }

        // Pop out the registered type parameter mappings
        unregister();

        Ok(Expression::StructPack(StructPack {
            name: struct_def.name.clone(),
            type_args,
            fields,
        }))
    }

    fn generate_struct_pack_concrete(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        st_concrete: &StructTypeConcrete,
    ) -> Result<Expression> {
        trace!(
            "Generating concrete struct pack for {:?}",
            st_concrete.inline()
        );

        let struct_def = self
            .get_struct_definition_with_identifier(&st_concrete.name)
            .unwrap();

        let mut fields = Vec::new();

        for (name, typ) in struct_def.fields.iter() {
            let expr = match typ {
                Type::TypeParameter(param) => {
                    // Find the concrete type for this type parameter
                    // TODO: known issue: if one field is a struct with type parameters unconcretized,
                    // TODO: we need to concretize them according to the type parameters of this parent struct
                    let idx = struct_def
                        .type_parameters
                        .find_idx_of_parameter(param)
                        .unwrap();
                    let concrete_type = st_concrete.type_args.get_type_arg_at_idx(idx).unwrap();
                    self.generate_expression_of_type(u, parent_scope, &concrete_type, true, true)?
                },
                Type::StructConcrete(st) => {
                    let mut st = st.clone();
                    let new_args = st
                        .type_args
                        .type_args
                        .iter()
                        .map(|arg| {
                            if let Type::TypeParameter(tp) = arg {
                                let idx = struct_def
                                    .type_parameters
                                    .find_idx_of_parameter(tp)
                                    .unwrap();
                                st_concrete.type_args.get_type_arg_at_idx(idx).unwrap()
                            } else {
                                arg.clone()
                            }
                        })
                        .collect();
                    st.type_args.type_args = new_args;
                    self.generate_struct_pack_concrete(u, parent_scope, &st)?
                },
                _ => self.generate_expression_of_type(u, parent_scope, typ, true, true)?,
            };
            fields.push((name.clone(), expr));
        }

        Ok(Expression::StructPack(StructPack {
            name: struct_def.name.clone(),
            type_args: st_concrete.type_args.clone(),
            fields,
        }))
    }

    /// Generate a random function call.
    fn generate_function_call(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
    ) -> Result<Option<FunctionCall>> {
        let callables = self.get_callable_functions(parent_scope);
        if callables.is_empty() {
            return Ok(None);
        }

        let func = u.choose(&callables)?.clone();
        Ok(Some(self.generate_call_to_function(
            u,
            parent_scope,
            &func,
            None,
            true,
        )?))
    }

    /// Generate a call to the given function.
    /// If the function returns a type parameter, the `ret_type` can specify
    /// the desired concrete type for this function.
    fn generate_call_to_function(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        func: &FunctionSignature,
        desired_ret_type: Option<&Type>,
        allow_var: bool,
    ) -> Result<FunctionCall> {
        trace!("Generating call to function: {:?}", func.name.inline());

        // Check if return type is a type parameter
        let desired_types = func
            .type_parameters
            .type_parameters
            .iter()
            .map(|tp| match desired_ret_type {
                Some(ret) => {
                    if ret == &Type::TypeParameter(tp.clone()) {
                        Some(ret.clone())
                    } else {
                        None
                    }
                },
                None => None,
            })
            .collect();

        // Concretize the type parameters of the function
        let (type_args, unregister) = self.concretize_type_parameters(
            u,
            parent_scope,
            &func.type_parameters,
            Some(desired_types),
            None,
        )?;
        trace!(
            "Generated concrete type args for function call to {:?}: {:?}",
            func.name.inline(),
            type_args.inline()
        );

        // Generate arguments using the selected concrete types
        let mut args = Vec::new();
        for (_, typ) in func.parameters.iter() {
            let expr = self.generate_expression_of_type(u, parent_scope, typ, allow_var, false)?;
            args.push(expr);
        }

        unregister();

        trace!("Done generating call to function: {:?}", func.name);
        Ok(FunctionCall {
            name: func.name.clone(),
            type_args,
            args,
        })
    }

    /// Concretize a list of type parameters into types.
    /// If some concrete types are desired, they should be put into `desired_types`
    /// at the corresponding index.
    /// If `desired_types` is not None, it must have the same length as the number
    /// of type parameters in `params`.
    ///
    /// This function registers the concrete types in the type pool.
    /// After handling this instance of concretization, the caller must
    /// call the returned function to unregister the concrete types.
    /// e.g. after generating expressions for function call arguments, the caller
    /// must unregister the concrete types for the type parameters.
    fn concretize_type_parameters(
        &self,
        u: &mut Unstructured,
        parent_scope: &Scope,
        params: &TypeParameters,
        desired_types: Option<Vec<Option<Type>>>,
        parent_type: Option<&Type>,
    ) -> Result<(TypeArgs, Box<dyn FnOnce() + '_>)> {
        let desired_types = match desired_types {
            Some(types) => types,
            None => vec![None; params.type_parameters.len()],
        };

        assert_eq!(params.type_parameters.len(), desired_types.len());

        let mut param_types = Vec::new();
        let mut type_args = Vec::new();
        for (tp, desired) in params.type_parameters.iter().zip(desired_types.into_iter()) {
            let typ_param = Type::TypeParameter(tp.clone());
            param_types.push(typ_param.clone());
            let concrete_type = match desired {
                Some(t) => t,
                None => self
                    .concretize_type(u, &typ_param, parent_scope, vec![], parent_type)
                    .unwrap_or(typ_param.clone()),
            };
            trace!("Got concretized type: {:?}", concrete_type);
            // Keep track of the concrete types we decided here
            self.env_mut()
                .type_pool
                .register_concrete_type(&typ_param.get_name(), &concrete_type);
            trace!(
                "Inserted concrete type for type parameter: {:?}, concrete is: {:?}",
                typ_param.get_name(),
                concrete_type
            );
            type_args.push(concrete_type);
        }

        // Create a handler to unregister the concrete types
        let unregister = Box::new(move || {
            for typ_param in param_types.iter() {
                self.env_mut()
                    .type_pool
                    .unregister_concrete_type(&typ_param.get_name());
            }
        });

        Ok((TypeArgs { type_args }, unregister))
    }

    /// Generate a random numerical literal.
    /// If the `typ` is `None`, a random type will be chosen.
    /// If the `typ` is `Some(Type::{U8, ..., U256})`, a literal of the given type will be used.
    ///
    /// `min` and `max` are used to generate a number within the given range.
    /// Both bounds are inclusive.
    fn generate_number_literal(
        &self,
        u: &mut Unstructured,
        typ: Option<&Type>,
        min: Option<BigUint>,
        max: Option<BigUint>,
    ) -> Result<NumberLiteral> {
        let typ = match typ {
            Some(t) => t.clone(),
            None => self.get_random_type(u, &ROOT_SCOPE, false, false, false, false, false)?,
        };

        let mut value = match &typ {
            Type::U8 => BigUint::from(u8::arbitrary(u)?),
            Type::U16 => BigUint::from(u16::arbitrary(u)?),
            Type::U32 => BigUint::from(u32::arbitrary(u)?),
            Type::U64 => BigUint::from(u64::arbitrary(u)?),
            Type::U128 => BigUint::from(u128::arbitrary(u)?),
            Type::U256 => BigUint::from_bytes_be(u.bytes(32)?),
            _ => panic!("Expecting number type"),
        };

        // Note: We are not uniformly sampling from the range [min, max].
        // Instead, all out-of-range values are clamped to the bounds.
        if let Some(min) = min {
            value = value.max(min);
        }

        if let Some(max) = max {
            value = value.min(max);
        }

        Ok(NumberLiteral { value, typ })
    }

    /// Returns one of the basic types that does not require a type argument.
    ///
    /// First choose a category of types, then choose a type from that category.
    #[allow(clippy::too_many_arguments)]
    fn get_random_type(
        &self,
        u: &mut Unstructured,
        scope: &Scope,
        allow_bool: bool,
        allow_struct: bool,
        allow_type_param: bool,
        only_instantiatable: bool,
        allow_reference: bool,
    ) -> Result<Type> {
        let bool_weight = match allow_bool {
            true => 10,
            false => 0,
        };
        // Try to use smaller ints more often to reduce input consumption
        let basics = vec![
            (Type::U8, 15),
            (Type::U16, 15),
            (Type::U32, 15),
            (Type::U64, 1),
            (Type::U128, 1),
            (Type::U256, 1),
            (Type::Bool, bool_weight),
        ];

        let mut categories = vec![basics];
        let mut category_weights = vec![10];

        // Choose struct types in scope
        // Every struct has the same weight
        if allow_struct {
            let struct_ids = self
                .env()
                .get_identifiers(None, Some(IDKinds::Struct), Some(scope));
            let structs = struct_ids
                .iter()
                .map(|id: &Identifier| {
                    let st = self.get_struct_definition_with_identifier(id).unwrap();
                    (st.get_type(), 1)
                })
                .collect::<Vec<(Type, u32)>>();
            if !structs.is_empty() {
                categories.push(structs);
                category_weights.push(10);
            }
        }

        // Choose type parameters in scope
        // Every type parameter has the same weight
        if allow_type_param {
            let mut params = self
                .env()
                .get_identifiers(None, Some(IDKinds::TypeParameter), Some(scope))
                .into_iter()
                .map(|id| self.env().type_pool.get_type(&id).unwrap())
                .collect::<Vec<Type>>();

            // Filter out types that are not instantiatable (type param not in args)
            if only_instantiatable {
                params = self.filter_instantiatable_types(scope, params);
            }

            let param_cat: Vec<(Type, u32)> = params
                .into_iter()
                .map(|typ| (typ, 1))
                .collect::<Vec<(Type, u32)>>();

            if !param_cat.is_empty() {
                categories.push(param_cat);
                category_weights.push(5);
            }
        }

        if allow_reference {
            let mut refs = vec![];
            for cat in categories.iter() {
                for (typ, _) in cat.iter() {
                    if let Type::Ref(_) = typ {
                        panic!("Reference type should not be in the category");
                    }
                    refs.push((Type::Ref(Box::new(typ.clone())), 1));
                    refs.push((Type::MutRef(Box::new(typ.clone())), 1));
                }
            }
            // We cannot create a reference to a non_instantiatable type parameter
            // so we simply remove all reference types if non_instantiatable type
            // parameters are not allowed
            if allow_type_param && !only_instantiatable {
                refs.retain(|(ty, _)| ty.is_type_parameter());
            }
            if !refs.is_empty() {
                categories.push(refs);
                category_weights.push(5);
            }
        }

        let cat_idx = choose_idx_weighted(u, &category_weights)?;
        let chosen_cat = &categories[cat_idx];

        let weights = chosen_cat.iter().map(|(_, w)| *w).collect::<Vec<u32>>();
        let choice = choose_idx_weighted(u, &weights)?;
        Ok(chosen_cat[choice].0.clone())
    }

    // Filter out types that are not instantiatable
    // For each type, checks if there is an accessible variable in `scope` that has the type
    fn filter_instantiatable_types(&self, scope: &Scope, types: Vec<Type>) -> Vec<Type> {
        let instantiatables = self
            .env()
            .get_identifiers(None, Some(IDKinds::Var), Some(scope))
            .into_iter()
            .filter_map(|id| self.env().type_pool.get_type(&id))
            .collect::<BTreeSet<Type>>();

        types
            .into_iter()
            .filter(|typ| {
                if let Type::TypeParameter(_) = typ {
                    instantiatables.contains(typ)
                } else {
                    true
                }
            })
            .collect()
    }

    /// Get all callable functions in the given scope.
    ///
    /// If `ret_type` is specified, only functions that can return the given type
    /// will be returned.
    fn get_callable_functions(&self, scope: &Scope) -> Vec<FunctionSignature> {
        let caller_num: usize = self.get_function_num(&scope.clone().0.unwrap_or("".to_string()));
        let mut callable = Vec::new();
        for m in self.modules.iter() {
            for f in m.borrow().functions.iter() {
                let sig = f.borrow().signature.clone();
                if self.env().id_pool.is_id_in_scope(&sig.name, scope) {
                    // Note: heuristic hack to avoid recursive calls
                    // Only allow function with smaller name to call function with larger name
                    // While recursive calls are interesting, they waste fuzzing time
                    // e.g function0 can call function1, but function1 cannot call function0
                    if !self.env().config.allow_recursive_calls {
                        let callee_num = self.get_function_num(&sig.name.to_string());
                        if caller_num >= callee_num {
                            continue;
                        }
                    }
                    callable.push(sig);
                }
            }
        }
        callable
    }

    // Hacky way to get the sequence number of a function
    fn get_function_num(&self, s: &str) -> usize {
        s.split("::")
            .filter(|s| s.starts_with("function"))
            .last()
            .unwrap()
            .chars()
            .filter(|c| c.is_ascii_digit())
            .collect::<String>()
            .parse::<usize>()
            .unwrap()
    }

    /// Finds all registered types that contains all the required abilities
    pub fn get_types_with_abilities(
        &self,
        parent_scope: &Scope,
        requires: &[Ability],
        only_instantiatable: bool,
    ) -> Vec<Type> {
        let types = self
            .env()
            .type_pool
            .get_all_types()
            .iter()
            .filter(|t| match t.is_num_or_bool() {
                true => true,
                false => {
                    let id = match t {
                        Type::Struct(st) => &st.name,
                        Type::TypeParameter(tp) => &tp.name,
                        _ => panic!("Invalid type"),
                    };
                    self.env().id_pool.is_id_in_scope(id, parent_scope)
                },
            })
            .filter(|t| {
                let possible_abilities = self.derive_abilities_of_type(t);
                requires.iter().all(|req| possible_abilities.contains(req))
            })
            .cloned()
            .collect();
        match only_instantiatable {
            true => self.filter_instantiatable_types(parent_scope, types),
            false => types,
        }
    }

    /// Get the possible abilities of a struct type.
    /// Only give the upper bound of possible abilities.
    /// TODO: this should belong to the type.rs or somewhere else
    fn derive_abilities_of_type(&self, typ: &Type) -> Vec<Ability> {
        match typ {
            Type::U8 | Type::U16 | Type::U32 | Type::U64 | Type::U128 | Type::U256 | Type::Bool => {
                Vec::from(Ability::PRIMITIVES)
            },
            // TODO: currently only use the `has`
            // TODO: should properly check the type arguments for concrete struct types.
            Type::Struct(st_typ) => {
                let st = self
                    .get_struct_definition_with_identifier(&st_typ.name)
                    .unwrap();
                st.abilities.clone()
            },
            Type::TypeParameter(tp) => tp.abilities.clone(),
            _ => Vec::from(Ability::NONE),
        }
    }

    /// Helper to
    fn derive_abilities_of_var(&self, var: &Identifier) -> Vec<Ability> {
        let typ = self.env().type_pool.get_type(var).unwrap();
        let abilities = self.derive_abilities_of_type(&typ);
        trace!("Derived abilities of variable: {:?}: {:?}", var, abilities);
        abilities
    }

    /// Helper to get the next identifier.
    fn get_next_identifier(
        &self,
        ident_type: IDKinds,
        parent_scope: &Scope,
    ) -> (Identifier, Scope) {
        self.env_mut()
            .id_pool
            .next_identifier(ident_type, parent_scope)
    }
}
