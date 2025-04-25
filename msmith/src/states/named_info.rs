use crate::{
    generators::{
        AssignmentGenerator, EnumGenerator, LetAssignGenerator, LetDeclGenerator,
        SignatureGenerator, StructGenerator,
    },
    move_ast::{
        Assignment, DotVariable, MatchArm, MoveAST, Pattern, PatternKind, SingleVariable,
        Statement, Variable,
    },
    states::{
        get_defined_vars_from_pattern,
        types::{Primitive, TupleType, Type, Typed},
        Ability, FunctionType, GenericType, Id, IdKind, Named, Scope, TypeSelector,
    },
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    selection::choose_item_weighted, GenLabel, LabelledGenerator, LabelledState, Register, State,
    StateEntry, StateLabel,
};
use id_arena::Arena;
use log::{error, trace, warn};
use std::{cell::RefCell, collections::BTreeMap};

type NamedInfoIdx = id_arena::Id<NamedInfo>;

/// A NamedInfo could represent:
/// - Module level:
///     - Struct/Enum
///     - Constant (TODO)
///     - Function
/// - Variable
#[derive(Debug, Clone)]
pub struct NamedInfo {
    pub name: Id,
    pub typ: Type,

    dot_var_indices: Vec<NamedInfoIdx>,
    initialized: bool,
    moved: bool,

    /// Only for dot_vars
    dot_var: Option<DotVariable>,
}

impl Typed for NamedInfo {
    fn ty(&self) -> Type {
        self.typ.clone()
    }
}

impl Named for NamedInfo {
    fn name(&self) -> Id {
        self.name.clone()
    }
}

impl NamedInfo {
    pub fn new(name: Id, typ: Type) -> Self {
        Self {
            name,
            typ,
            dot_var_indices: vec![],
            initialized: false,
            moved: false,
            dot_var: None,
        }
    }

    pub fn new_with_dot_vars(name: Id, typ: Type, dot_var_indices: Vec<NamedInfoIdx>) -> Self {
        Self {
            name,
            typ,
            dot_var_indices,
            initialized: false,
            moved: false,
            dot_var: None,
        }
    }

    pub fn new_dot_var(name: Id, typ: Type, dot_var: DotVariable) -> Self {
        Self {
            name,
            typ,
            dot_var_indices: vec![],
            initialized: false,
            moved: false,
            dot_var: Some(dot_var),
        }
    }
}

#[derive(Debug, Default)]
pub struct NamedInfoPool {
    map: BTreeMap<Id, NamedInfoIdx>,
    arena: Arena<NamedInfo>,

    pub has_struct: bool,
    pub has_enum: bool,
    type_selection_depth: RefCell<usize>,
}

impl NamedInfoPool {
    pub fn add_new_uninitialized_variable(&mut self, name: Id, typ: Type) {
        self.add_new_variable(name, typ, false);
    }

    pub fn add_new_initialized_variable(&mut self, name: Id, typ: Type) {
        self.add_new_variable(name, typ, true);
    }

    pub fn add_new_variable(&mut self, name: Id, typ: Type, initialized: bool) {
        let dot_vars = self._create_all_dot_vars_from(&name, &typ);

        let mut dot_var_indices = vec![];
        for dot_var in &dot_vars {
            let dot_name = dot_var.name();
            let dot_var_info =
                NamedInfo::new_dot_var(dot_name.clone(), dot_var.ty(), dot_var.clone());
            let idx = self.arena.alloc(dot_var_info);
            dot_var_indices.push(idx.clone());
            self.map.insert(dot_name.clone(), idx);
        }

        let info = NamedInfo::new_with_dot_vars(name.clone(), typ, dot_var_indices);
        let idx = self.arena.alloc(info);
        if initialized {
            self._set_var_as_initialized(&idx);
        }
        self.map.insert(name, idx);
    }

    pub fn add_new_type(&mut self, name: Id, typ: Type) {
        let info = NamedInfo::new(name.clone(), typ);
        let idx = self.arena.alloc(info);
        self.map.insert(name, idx);
    }

    pub fn get_info(&self, name: &Id) -> Option<&NamedInfo> {
        self.map.get(name).and_then(|idx| self.arena.get(*idx))
    }

    pub fn get_info_mut(&mut self, name: &Id) -> Option<&mut NamedInfo> {
        self.map.get(name).and_then(|idx| self.arena.get_mut(*idx))
    }

    pub fn set_var_as_initialized(&mut self, name: &Id) {
        if let Some(idx) = self.map.get(name).cloned() {
            self._set_var_as_initialized(&idx);
        } else {
            error!(
                "Variable {} not found in NamedInfoPool when trying to set it as initialized",
                name
            );
        }
    }

    fn _set_var_as_initialized(&mut self, idx: &NamedInfoIdx) {
        let mut todo_indices = vec![];
        if let Some(info) = self.arena.get_mut(*idx) {
            info.initialized = true;
            info.moved = false;
            for dot_var_idx in &info.dot_var_indices {
                todo_indices.push(dot_var_idx.clone());
            }
        }
        for dot_var_idx in todo_indices {
            self._set_var_as_initialized(&dot_var_idx);
        }
    }

    /// Return all defined struct types that is accessible with in `scope`
    pub fn get_all_struct_types(&self, scope: &Scope) -> Vec<Type> {
        self.arena
            .iter()
            .filter_map(|(_, info)| {
                if !info.name.is_struct() {
                    return None;
                }

                if !scope.is_in_scope(&info.parent_scope()) {
                    return None;
                }

                Some(info.typ.clone())
            })
            .collect()
    }

    /// Return all defined struct types that is accessible with in `scope`
    pub fn get_all_enum_types(&self, scope: &Scope) -> Vec<Type> {
        self.arena
            .iter()
            .filter_map(|(_, info)| {
                if !info.name.is_enum() {
                    return None;
                }

                if !scope.is_in_scope(&info.parent_scope()) {
                    return None;
                }

                Some(info.typ.clone())
            })
            .collect()
    }

    /// Return infos for variables that are:
    ///     - in scope
    ///     - initialized
    ///     - not moved
    fn _get_usable_vars_iter(&self, scope: Scope) -> impl Iterator<Item = &NamedInfo> {
        self.arena.iter().filter_map(move |(_, info)| {
            if !info.name.is_var() {
                return None;
            }

            if !info.initialized {
                return None;
            }

            if info.moved {
                return None;
            }

            if !scope.is_in_scope(&info.parent_scope()) {
                return None;
            }
            Some(info)
        })
    }

    pub fn get_initialized_vars_of_type(&self, scope: &Scope, wanted: &Type) -> Vec<Variable> {
        self._get_usable_vars_iter(scope.clone())
            .filter_map(|info| {
                if info.ty() != *wanted {
                    return None;
                }

                Some(match info.dot_var {
                    Some(ref dot_var) => dot_var.clone().into(),
                    None => SingleVariable::new(&info.name(), &info.ty()).into(),
                })
            })
            .collect::<Vec<Variable>>()
    }

    pub fn get_callable_info(&self, scope: &Scope) -> Vec<NamedInfo> {
        let mut callables = self
            .arena
            .iter()
            .filter_map(|(_, info)| {
                if !scope.is_in_scope(&info.parent_scope()) {
                    return None;
                }
                if info.name.is_func() {
                    Some(info.clone())
                } else {
                    None
                }
            })
            .collect::<Vec<NamedInfo>>();

        callables.extend(
            self._get_usable_vars_iter(scope.clone())
                .into_iter()
                .filter_map(|info| {
                    if info.typ.is_function() {
                        Some(info.clone())
                    } else {
                        None
                    }
                }),
        );
        callables
    }

    fn _create_all_dot_vars_from(&self, name: &Id, typ: &Type) -> Vec<DotVariable> {
        let root = DotVariable::new(vec![(name.clone(), typ.clone())]);
        Self::_create_all_dot_vars_from_rec(root)
    }

    fn _create_all_dot_vars_from_rec(root: DotVariable) -> Vec<DotVariable> {
        let curr_type = root.ty();
        let fields = match &curr_type {
            Type::Generic(GenericType::Struct(s)) if !s.positional => &s.fields,
            Type::Generic(GenericType::Enum(e)) => &e.get_possible_named_fields(),
            _ => return vec![],
        };

        let mut dot_vars = vec![];
        for (field_name, field_type) in fields {
            let new_dot_var =
                DotVariable::new_with_prefix(&root, (field_name.clone(), field_type.clone()));
            dot_vars.push(new_dot_var.clone());
            dot_vars.extend(Self::_create_all_dot_vars_from_rec(new_dot_var));
        }
        dot_vars
    }

    pub fn random_type(
        &self,
        scope: &Scope,
        u: &mut Unstructured,
        mut selectors: Vec<TypeSelector>,
    ) -> Result<Type> {
        *self.type_selection_depth.borrow_mut() += 1;

        let selector = match selectors.len() {
            1 => selectors[0].clone(),
            _ => selectors.remove(0),
        };

        // Outer vector element: (type candidates in a category, weight of the category)
        // Inner vector element: (type candidate, weight of the candidate)
        let mut candidates: Vec<(Vec<(Type, u32)>, u32)> = vec![];

        if selector.unit_weight > 0 {
            candidates.push((vec![(Type::Unit, 1)], selector.unit_weight));
        }

        if selector.bool_weight > 0 {
            candidates.push((
                vec![(Type::Primitive(Primitive::Bool), 1)],
                selector.bool_weight,
            ));
        }

        if selector.number_weight > 0 {
            let types = TypeSelector::number_type_selection_weights();
            candidates.push((types, selector.number_weight));
        }

        if selector.address_weight > 0 {
            candidates.push((
                vec![(Type::Primitive(Primitive::Address), 1)],
                selector.address_weight,
            ));
        }

        if selector.struct_weight > 0 {
            let struct_types = self
                .get_all_struct_types(scope)
                .into_iter()
                .map(|s| (s, 1))
                .collect::<Vec<(Type, u32)>>();
            if struct_types.is_empty() {
                warn!("No struct types defined");
            } else {
                candidates.push((struct_types, selector.struct_weight));
            }
        }

        if selector.enum_weight > 0 {
            let enum_types = self
                .get_all_enum_types(scope)
                .into_iter()
                .map(|e| (e, 1))
                .collect::<Vec<(Type, u32)>>();
            if enum_types.is_empty() {
                warn!("No enum types defined");
            } else {
                candidates.push((enum_types, selector.enum_weight));
            }
        }

        if selector.vector_weight > 0 {
            warn!("random Vector type not implemented");
            unimplemented!();
        }

        if selector.tuple_weight > 0 {
            let num_elem = selector.config.num_elem_in_tuple.select(u)?;

            // Cannot have a tuple of tuples
            selectors.iter_mut().for_each(|s| {
                s.tuple_weight = 0;
                s.unit_weight = 0;
                s.defined_func_type = 0;
                s.new_func_type = 0;
                // Avoid having nothing to choose
                if s.is_all_no() {
                    s.number_weight = 1;
                }
            });

            let elems = (0..num_elem)
                .map(|_| self.random_type(scope, u, selectors.clone()))
                .collect::<Result<Vec<Type>>>()?;

            let typ = Type::Generic(GenericType::Tuple(TupleType { types: elems }));
            candidates.push((vec![(typ, 1)], selector.tuple_weight));
        }

        if selector.reference_weight > 0 {
            warn!("random Reference type not implemented");
            unimplemented!();
        }

        if selector.mut_reference_weight > 0 {
            warn!("random Mutable Reference type not implemented");
            unimplemented!();
        }

        if selector.func_return > 0 {
            let mut ret_types = self
                .get_callable_info(scope)
                .into_iter()
                .filter_map(|info| {
                    if let Type::Generic(GenericType::Function(f)) = info.ty() {
                        if f.has_return() {
                            Some((f.return_type.as_ref().clone(), 1))
                        } else {
                            None
                        }
                    } else {
                        None
                    }
                })
                .collect::<Vec<(Type, u32)>>();

            if selector.tuple_weight == 0 {
                // Filter out tuple types
                ret_types.retain(|(typ, _)| !typ.is_generic_tuple());
            }

            if ret_types.is_empty() {
                warn!("No function defined so far");
            } else {
                candidates.push((ret_types, selector.func_return));
            }
        }

        if selector.defined_func_type > 0 {
            let func_types = self
                .get_callable_info(scope)
                .into_iter()
                .filter_map(|info| {
                    let typ = info.ty();
                    if typ.is_function() {
                        Some((typ, 1))
                    } else {
                        None
                    }
                })
                .collect::<Vec<(Type, u32)>>();

            if func_types.is_empty() {
                warn!("No function defined so far");
            } else {
                candidates.push((func_types, selector.defined_func_type));
            }
        }

        // Use the rest of selectors to generate a function type
        // [parameter1, parameter2, ..]::[return type]
        if selector.new_func_type > 0 || selector.new_droppable_func_type > 0 {
            // TODO: put this in config
            let func_type = if *self.type_selection_depth.borrow() >= 3 {
                Type::Generic(GenericType::Function(FunctionType {
                    name: Id::new_without_scopes("FunctionTypePlaceholder", IdKind::Function),
                    type_params: vec![],
                    params: vec![],
                    return_type: Box::new(Type::Unit),
                    abilities: None,
                    is_func_value: false,
                }))
            } else {
                let num_params = selector.config.num_params_in_func.select(u)?;
                let has_ret = bool::arbitrary(u)?;

                let (param_selectors, ret_selector) = TypeSelector::function_selectors(
                    num_params,
                    selector.new_droppable_func_type > 0,
                );

                let ret_type = if has_ret {
                    self.random_type(scope, u, vec![ret_selector])?
                } else {
                    Type::Unit
                };

                let param_types = param_selectors
                    .into_iter()
                    .map(|s| self.random_type(scope, u, vec![s]).unwrap())
                    .collect::<Vec<Type>>();

                Type::Generic(GenericType::Function(FunctionType {
                    name: Id::new_without_scopes("FunctionTypePlaceholder", IdKind::Function),
                    type_params: vec![],
                    params: param_types,
                    return_type: Box::new(ret_type),
                    abilities: None,
                    is_func_value: false,
                }))
            };
            candidates.push((
                vec![(func_type, 1)],
                selector.new_func_type + selector.new_droppable_func_type,
            ));
        }

        trace!("Candidates: {:?}", candidates);
        trace!("Selector: {:?}", selector);
        let chosen_category = choose_item_weighted(u, &candidates)?;
        let mut chosen = choose_item_weighted(u, &chosen_category)?;
        trace!("Chosen type: {:?}", chosen);

        if let Type::Generic(GenericType::Function(f)) = &mut chosen {
            f.is_func_value = true;
            f.abilities = Some(Ability::copy_drop());
        }

        *self.type_selection_depth.borrow_mut() -= 1;
        Ok(chosen)
    }

    pub fn save_type_info_from_ast(&mut self, new_ast: &MoveAST, generator: &GenLabel) {
        use MoveAST as M;
        match &new_ast {
            M::Struct(s) => {
                self.has_struct = true;
                self.add_new_type(s.name.clone(), s.ty());
            },
            M::Enum(e) => {
                self.has_enum = true;
                self.add_new_type(e.name.clone(), e.ty());
            },
            M::Signature(s) => {
                self.add_new_type(s.name.clone(), s.ty());

                for p in &s.parameters {
                    self.add_new_initialized_variable(p.name.clone(), p.ty());
                }
            },
            M::Statement(Statement::LetAssign(Assignment::AssignPattern(pat, _))) => {
                if generator != &LetAssignGenerator::label() {
                    return;
                }
                let vars = get_defined_vars_from_pattern(pat);
                for (id, ty) in vars {
                    self.add_new_initialized_variable(id, ty);
                }
            },
            M::Statement(Statement::LetDeclare(vars)) => {
                for v in vars {
                    self.add_new_uninitialized_variable(v.name.clone(), v.ty());
                }
            },
            M::MatchArm(MatchArm { pattern, .. }) => {
                let vars = get_defined_vars_from_pattern(pattern);
                for (id, ty) in vars {
                    self.add_new_initialized_variable(id, ty);
                }
            },
            _ => {},
        }
    }

    pub fn save_init_info_from_ast(&mut self, new_ast: &MoveAST, _generator: &GenLabel) {
        match new_ast {
            MoveAST::Signature(sig) => {
                for param in &sig.parameters {
                    self.set_var_as_initialized(&param.name);
                }
            },
            MoveAST::Assignment(Assignment::AssignPattern(pat, _)) => {
                let init_vars = get_initialized_vars_from_pattern(pat);
                for var in init_vars {
                    if self.map.contains_key(&var) {
                        self.set_var_as_initialized(&var);
                    }
                }
            },
            MoveAST::EnumMatch(em) => {
                for arm in &em.arms {
                    let vars = get_initialized_vars_from_pattern(&arm.pattern);
                    for var in vars {
                        self.set_var_as_initialized(&var);
                    }
                }
            },
            _ => {},
        }
    }
}

fn get_initialized_vars_from_pattern(pattern: &Pattern) -> Vec<Id> {
    match &pattern.body {
        PatternKind::Variable(Variable::SingleVariable(sv)) => vec![sv.name.clone()],
        PatternKind::Variable(Variable::DotVariable(_)) => vec![],
        PatternKind::Positional(pats) => pats
            .iter()
            .flat_map(|f| {
                if let Some(p) = f {
                    get_initialized_vars_from_pattern(p)
                } else {
                    vec![]
                }
            })
            .collect(),
        PatternKind::Named(s, _) => s
            .iter()
            .flat_map(|(_, p)| get_initialized_vars_from_pattern(p))
            .collect(),
        PatternKind::Wildcard => vec![],
    }
}

impl LabelledState for NamedInfoPool {
    fn label() -> StateLabel {
        StateLabel::new("NamedInfoPool")
    }
}

impl Register<StateEntry> for NamedInfoPool {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![
                StructGenerator::label(),
                EnumGenerator::label(),
                SignatureGenerator::label(),
                LetAssignGenerator::label(),
                LetDeclGenerator::label(),
                AssignmentGenerator::label(),
            ],
        }
    }
}

impl State<MoveAST> for NamedInfoPool {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {}

    fn update_post(&mut self, _u: &mut Unstructured, new_ast: &MoveAST, generator: &GenLabel) {
        self.save_type_info_from_ast(new_ast, generator);
        self.save_init_info_from_ast(new_ast, generator);
    }
}
