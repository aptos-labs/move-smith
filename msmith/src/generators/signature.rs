use crate::{
    move_ast::{MoveAST, Signature, SingleVariable, TypeParameters},
    states::{
        get_config, new_id_from_curr_scope, random_type_from_curr_scope, Id, IdKind, Scope, Type,
        TypeSelectorBuilder,
    },
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::trace;

#[derive(Default)]
pub struct SignatureGenerator;

impl LabelledGenerator for SignatureGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("SignatureGenerator")
    }
}

impl Register<GeneratorEntry> for SignatureGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for SignatureGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_exist_and_type::<Id>("name")
            && constraint.check_exist_and_type::<Scope>("scope")
            && constraint.check_not_exist_or_has_type::<bool>("has_return")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let name = constraint.get::<Id>("name").unwrap();

        let config = get_config(env);
        let num_params = config.num_params_in_func.select(u)?;
        trace!("Generating {num_params} parameters for function {name}");
        let type_selector = TypeSelectorBuilder::all_no(config)
            .number(1)
            .bool(1)
            .structs(1)
            .enums(1)
            .defined_func_type(1)
            .new_func_type(1)
            .build();
        let mut parameters = vec![];

        for _ in 0..num_params {
            // Create a new var name under the function scope
            let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
            let typ = random_type_from_curr_scope(u, env, vec![type_selector.clone()])?;
            parameters.push(SingleVariable::new_declare(&name, &typ));
        }

        let has_return = constraint.get_or::<bool>("has_return", bool::arbitrary(u)?);

        let config = get_config(env);
        let return_type = if has_return {
            // TODO: allow more types when ready
            let type_selector = TypeSelectorBuilder::all_no(config)
                .number(1)
                .bool(1)
                .structs(1)
                .enums(1)
                .tuple(1)
                .defined_func_type(1)
                .new_func_type(1)
                .build();
            random_type_from_curr_scope(u, env, vec![type_selector])?
        } else {
            Type::Unit
        };

        let subtree = Subtree::new_single_candidate(
            Signature {
                name: name.clone(),
                type_params: TypeParameters::default(),
                parameters,
                return_type,
                abilities: None,
                is_func_value: false,
            }
            .into(),
        );
        Ok((vec![subtree], AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        Ok(asts.into_iter().next().unwrap())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        if ast.as_signature().is_none() {
            return false;
        }

        // The signature must use the given name from the constraint
        let sig = ast.as_signature().unwrap();
        if gen_constraint.get::<Id>("name").unwrap() != &sig.name {
            return false;
        }

        // The signature must respect the return type constraint
        let does_have_return = sig.has_return();
        if let Some(has_return) = gen_constraint.get::<bool>("has_return") {
            if *has_return != does_have_return {
                return false;
            }
        }
        true
    }
}
