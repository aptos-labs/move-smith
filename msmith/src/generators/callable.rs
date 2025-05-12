use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{Callable, Expression, MoveAST},
    states::{
        get_config, get_curr_scope, get_named_infos, random_type_from_curr_scope, FunctionType,
        GenericType, Type, TypeSelectorBuilder, Typed,
    },
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct CallableGenerator;

impl LabelledGenerator for CallableGenerator {
    fn label() -> GenLabel {
        GenLabel::new("CallableGenerator")
    }
}

impl Register<GeneratorEntry> for CallableGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for CallableGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        // The desired return type of this callable
        constraint.check_not_exist_or_has_type::<Type>("type")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let want_type = match constraint.get::<Type>("type") {
            Some(typ) => typ.clone(),
            None => {
                let selector = TypeSelectorBuilder::all_no(get_config(env))
                    .bool(1)
                    .number(1)
                    .structs(1)
                    .enums(1)
                    .tuple(1)
                    .build();
                random_type_from_curr_scope(u, env, vec![selector])?
            },
        };

        let curr_scope = get_curr_scope(env);

        // Get all callable info in the current scope
        // that returns the desired type
        let callables = get_named_infos(env)
            .get_callable_info(&curr_scope)
            .into_iter()
            .filter(|info| info.ty().as_function().unwrap().return_type.as_ref() == &want_type)
            .collect::<Vec<_>>();

        let mut use_expr = bool::arbitrary(u)?;

        // Create a new function value if there are no callables
        if callables.is_empty() {
            use_expr = true;
        }

        let mut subtrees = vec![];
        let mut comp_constraints = AnyConstraint::new();

        if use_expr {
            let selector = TypeSelectorBuilder::all_no(get_config(env))
                .new_droppable_func_type(1)
                .build();
            let mut new_func_typ = random_type_from_curr_scope(u, env, vec![selector])?;

            if let Type::Generic(GenericType::Function(f_typ)) = &mut new_func_typ {
                f_typ.return_type = Box::new(want_type.clone());
                comp_constraints.insert("type", f_typ.clone());
            } else {
                panic!("Expected a function type");
            }

            subtrees.push(Subtree::new_generator_subtree(
                ExprOfTypeGenerator::label(),
                AnyConstraint::new().with("type", new_func_typ),
            ));
        } else {
            let chosen = u.choose(&callables)?.clone();
            let func_typ = chosen.ty().as_function().unwrap().clone();
            comp_constraints.insert("type", func_typ);
            subtrees.push(Subtree::new_single_candidate(
                Expression::Variable(chosen.to_variable()).into(),
            ));
        }
        Ok((subtrees, comp_constraints))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let typ = constraint.get::<FunctionType>("type").unwrap();
        let expr = asts.into_iter().next().unwrap().into_expression().unwrap();
        Ok(Callable {
            expr: Box::new(expr),
            func_type: typ.clone(),
        }
        .into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_callable().is_some()
    }
}
