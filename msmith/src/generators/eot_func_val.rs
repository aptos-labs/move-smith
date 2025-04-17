use super::BlockGenerator;
use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{Expression, FunctionValue, MoveAST, Signature, SingleVariable, TypeParameters},
    states::{
        new_id_from_curr_scope, new_id_from_curr_scope_and_push_scope, pop_scope, GenericType,
        IdKind, PartialInfo, Type, TypePool, PARTIAL_SIGNATURE,
    },
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct EOTFuncValGenerator;

impl LabelledGenerator for EOTFuncValGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTFuncValGenerator")
    }
}

impl Register<GeneratorEntry> for EOTFuncValGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTFuncValGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        matches!(
            constraint.get::<Type>("type").unwrap(),
            Type::Generic(GenericType::Function(_))
        )
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let mut func_type = match constraint.get::<Type>("type").unwrap() {
            Type::Generic(GenericType::Function(func_type)) => func_type.clone(),
            _ => panic!("EOTFuncValGenerator::subtrees: constraint does not have a function type"),
        };

        let (name, _scope, _) = new_id_from_curr_scope_and_push_scope(env, IdKind::Function);
        func_type.name = name.clone();

        let mut parameters = vec![];
        for param_type in func_type.params {
            let (param_name, _) = new_id_from_curr_scope(env, IdKind::Var);
            // TODO: adding type should be kept in TypePool implementation
            // TODO: remove this after func val all done
            let type_pool = env.get_mut::<TypePool>().unwrap();
            type_pool
                .variable_types
                .insert(param_name.clone(), param_type.clone());
            parameters.push(SingleVariable::new_declare(&param_name, &param_type));
        }

        let signature = Signature {
            name: name.clone(),
            type_params: TypeParameters {
                types: func_type.type_params.clone(),
            },
            parameters,
            return_type: *func_type.return_type.clone(),
            abilities: func_type.abilities.clone(),
            is_func_value: true,
        };

        // Simulate how PartialInfo keeps track of func signatures
        // TODO: this should be removed and automated
        let partial = env.get_mut::<PartialInfo>().unwrap();
        partial
            .store
            .insert(PARTIAL_SIGNATURE.to_string(), vec![MoveAST::Signature(
                signature.clone(),
            )]);

        let subtrees = vec![Subtree::new_generator_subtree(
            BlockGenerator::label(),
            AnyConstraint::new().with("is_function_body", true),
        )];

        Ok((subtrees, AnyConstraint::new().with("signature", signature)))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        pop_scope(env);

        let signature = constraint.get::<Signature>("signature").unwrap().clone();
        let body = asts.into_iter().next().unwrap().into_block().unwrap();
        Ok(Expression::FunctionValue(FunctionValue {
            signature,
            body: Box::new(body),
        })
        .into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_expression()
            .and_then(|e| e.as_functionvalue())
            .is_some()
    }
}
