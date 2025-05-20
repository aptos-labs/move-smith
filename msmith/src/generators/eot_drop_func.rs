use super::EOTFuncValGenerator;
use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{
        Assignment, Block, Expression, MoveAST, Pattern, PatternKind, Sequence, SingleVariable,
        Statement, Variable,
    },
    states::{
        new_id_from_curr_scope, new_id_from_curr_scope_and_push_scope, pop_scope, GenericType, Id,
        IdKind, Type,
    },
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

/// Inline created function values cannot have drop ability specified.
/// This generator creates a block where function value is first assigned to a variable with type annotation.
#[derive(Default)]
pub struct EOTDroppableInlineFuncGenerator;

impl LabelledGenerator for EOTDroppableInlineFuncGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTDroppableInlineFuncGenerator")
    }
}

impl Register<GeneratorEntry> for EOTDroppableInlineFuncGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTDroppableInlineFuncGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        matches!(
            constraint.get::<Type>("type").unwrap(),
            Type::Generic(GenericType::Function(_))
        ) && constraint.get_or("will_drop", false)
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let (block_name, _, _) = new_id_from_curr_scope_and_push_scope(env, IdKind::Block);
        let subtrees = vec![Subtree::new_generator_subtree(
            EOTFuncValGenerator::label(),
            constraint.clone().with("will_drop", false),
        )];
        let comp_constraint = constraint.clone().with("block_name", block_name);
        Ok((subtrees, comp_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let (var_name, _) = new_id_from_curr_scope(env, IdKind::Var);
        pop_scope(env);
        let typ = constraint.get::<Type>("type").unwrap().clone();
        let block_name = constraint.get::<Id>("block_name").unwrap().clone();
        let func_expr = asts.into_iter().next().unwrap().into_expression().unwrap();

        let var = Variable::SingleVariable(SingleVariable {
            name: var_name.clone(),
            typ: typ.clone(),
            declare: true,
            show_type: false,
            is_normal_function: false,
        });

        let assign_stmt = Statement::LetAssign(Assignment::AssignPattern(
            Pattern {
                typ: typ.clone(),
                body: PatternKind::Variable(var.clone()),
            },
            Box::new(func_expr),
        ));
        let ret_expr = Expression::Variable(var.clone());

        let block = Block {
            name: block_name,
            sequences: vec![Sequence {
                statements: vec![assign_stmt],
            }],
            return_expr: Some(Box::new(ret_expr)),
        };
        Ok(Expression::Block(block).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_expression().and_then(|e| e.as_block()).is_some()
    }
}
