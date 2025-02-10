use crate::{
    generators::StatementGenerator,
    move_ast::{Expression, MoveAST, Statement, Variable},
    states::{new_id_from_curr_scope, IdKind, NumberType, Primitive, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::warn;

#[derive(Default)]
pub struct LetGenerator;

impl LabelledGenerator for LetGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("LetGenerator")
    }
}

impl Register<GeneratorEntry> for LetGenerator {
    fn register(&self) -> GeneratorEntry {
        let mut entry = GeneratorEntry::new::<Self>();
        entry.add_parent::<StatementGenerator>();
        entry
    }
}

impl Generator<MoveAST, AnyConstraint> for LetGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        warn!("check_constraint not implemented for LetGenerator");
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        Ok((vec![], AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        _asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
        Ok(MoveAST::Statement(Statement::Let(Expression::Variable(
            Variable {
                name,
                typ: Type::Primitive(Primitive::Number(NumberType::U64)),
                declare: true,
                show_type: true,
            },
        ))))
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        match ast {
            MoveAST::Statement(Statement::Let(expr)) => match expr {
                Expression::Variable(_) => true,
                Expression::Assignment(_) => true,
                _ => false,
            },
            _ => false,
        }
    }
}
