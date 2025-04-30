use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{CallArguments, MoveAST},
    states::{partial::PARTIAL_CALLABLE, PartialInfo},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct CallArgumentsGenerator;

impl LabelledGenerator for CallArgumentsGenerator {
    fn label() -> GenLabel {
        GenLabel::new("CallArgumentsGenerator")
    }
}

impl Register<GeneratorEntry> for CallArgumentsGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for CallArgumentsGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        let partial = env.get::<PartialInfo>().unwrap();
        partial
            .store
            .get(PARTIAL_CALLABLE)
            .map(|callables| !callables.is_empty())
            .unwrap_or(false)
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let partial = env.get_mut::<PartialInfo>().unwrap();
        let callables = partial.store.get_mut(PARTIAL_CALLABLE).unwrap();
        let callable = callables.pop().unwrap().into_callable().unwrap();

        let mut subtrees = vec![];
        for arg_typ in callable.get_arg_types() {
            subtrees.push(Subtree::new_generator_subtree(
                ExprOfTypeGenerator::label(),
                AnyConstraint::new().with("type", arg_typ),
            ));
        }
        Ok((subtrees, AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let mut args = vec![];
        for ast in asts {
            args.push(ast.into_expression().unwrap());
        }
        Ok(MoveAST::CallArguments(CallArguments(args)))
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_callarguments().is_some()
    }
}
