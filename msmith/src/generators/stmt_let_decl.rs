use crate::{
    generators::StatementGenerator,
    move_ast::{MoveAST, SingleVariable, Statement},
    states::{
        get_config, get_type_pool, new_id_from_curr_scope, IdKind, Type, TypeSelectorBuilder,
    },
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct LetDeclGenerator;

impl LabelledGenerator for LetDeclGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("LetDeclGenerator")
    }
}

impl Register<GeneratorEntry> for LetDeclGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<StatementGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for LetDeclGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_not_exist_or_has_type::<Vec<Type>>("types")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let types = match constraint.get::<Vec<Type>>("types") {
            Some(types) => types.clone(),
            None => {
                let num_new_vars = u.int_in_range(1..=4)?;
                let selector = TypeSelectorBuilder::all_no(get_config(env))
                    .bool(1)
                    .number(1)
                    .structs(1)
                    .enums(1)
                    .build();
                let mut types = vec![];
                let type_pool = get_type_pool(env);
                for _ in 0..num_new_vars {
                    types.push(type_pool.random_type(u, vec![selector.clone()])?);
                }
                types
            },
        };

        let vars = types
            .into_iter()
            .map(|t| {
                let (var, _) = new_id_from_curr_scope(env, IdKind::Var);
                SingleVariable::new_declare(&var, &t)
            })
            .collect();

        let subtree = Subtree::new_single_candidate(Statement::LetDeclare(vars).into());
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
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        matches!(ast, MoveAST::Statement(Statement::LetDeclare(_)))
    }
}
