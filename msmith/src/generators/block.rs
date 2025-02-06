use crate::{
    generators::{ExpressionGenerator, SequenceGenerator},
    move_ast::{Block, Expression, MoveAST},
    states::{
        curr_scope::CurrScope,
        ids::{Id, IdPool},
        partial::{PartialInfo, PARTIAL_SIGNATURE},
        GenerationConfig, TypePool, TypeSelectorBuilder,
    },
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, Label, Labelled, Register, StatePool,
    Subtree,
};
use log::trace;

#[derive(Default)]
pub struct BlockGenerator;

impl Labelled for BlockGenerator {
    fn label() -> Label {
        GenLabel::new_func_body_level("BlockGenerator").into()
    }
}

impl Register<GeneratorEntry> for BlockGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for BlockGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_not_exist_or_has_type::<bool>("has_return")
            && constraint.check_exist_and_type::<bool>("is_function_body")
        // TODO
        // 1. add a `return_type` that specify the return type if `has_return` is true
        // 2. `has_return` and `is_function_body` should be mutually exclusive
        // 3. when `is_function_body` is true, the PartialInfo's PARTIAL_SIGNATURE should not be empty
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let is_function_body = constraint.get::<bool>("is_function_body").unwrap();
        let has_return = match constraint.get("has_return") {
            Some(v) => *v,
            None => bool::arbitrary(u)?,
        };
        let return_type = if *is_function_body {
            let partial_info = env.get_mut::<PartialInfo>().unwrap();
            let signatures = partial_info.store.get_mut(PARTIAL_SIGNATURE).unwrap();
            let signature = signatures.pop().unwrap().into_signature().unwrap();
            signature.return_type.clone()
        } else if has_return {
            let type_pool = env.get::<TypePool>().unwrap();
            let config = env.get::<GenerationConfig>().unwrap();
            let selector = TypeSelectorBuilder::all_no(config).number(1).build();
            Some(type_pool.random_type(u, vec![selector]).unwrap())
        } else {
            None
        };

        let curr_scope = env.get::<CurrScope>().unwrap().get();
        let (name, scope) = env
            .get_mut::<IdPool>()
            .unwrap()
            .next_id(crate::IdKind::Block, &curr_scope);
        env.get_mut::<CurrScope>().unwrap().push(scope.clone());
        trace!(
            "Generating block -- {}, {:?}, last curr_scope: {:?}",
            name,
            scope,
            curr_scope
        );

        let mut compose_constraint = AnyConstraint::new();

        compose_constraint.insert("name", name.clone());

        let config = env.get::<GenerationConfig>().unwrap();
        let num_sequences = config.num_sequences_in_block.select(u)?;
        compose_constraint.insert("num_sequences", num_sequences);
        trace!("Block {} will generate {} sequences", name, num_sequences);

        let mut subtrees = vec![];

        for _ in 0..num_sequences {
            subtrees.push(Subtree::new_generator_subtree(
                SequenceGenerator::label().try_into().unwrap(),
                AnyConstraint::new(),
            ));
        }

        if let Some(return_type) = return_type {
            compose_constraint.insert("has_return", true);
            trace!("Block {} has return type: {:?}", name, return_type);

            let mut expr_constraint = AnyConstraint::new();
            expr_constraint.insert("type", return_type);
            subtrees.push(Subtree::new_generator_subtree(
                ExpressionGenerator::label().try_into().unwrap(),
                expr_constraint,
            ));
        } else {
            compose_constraint.insert("has_return", false);
            trace!("Block {} has no return expr", name);
        }

        Ok((subtrees, compose_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        mut asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let name: &Id = constraint.get("name").unwrap();
        let num_sequences: &usize = constraint.get("num_sequences").unwrap();
        let has_return: &bool = constraint.get("has_return").unwrap();

        let mut sequences = vec![];
        for _ in 0..*num_sequences {
            sequences.push(asts.remove(0).try_into().unwrap());
        }
        let return_expr = match has_return {
            true => {
                let node = asts.remove(0);
                let expr: Expression = node.try_into().unwrap();
                Some(expr)
            },
            false => None,
        };

        Ok(Block {
            name: name.clone(),
            sequences,
            return_expr,
        }
        .into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_block().is_some()
    }
}
