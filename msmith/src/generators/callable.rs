use super::ExprOfTypeGenerator;
use crate::{
    move_ast::{Callable, MoveAST},
    states::{
        get_config, get_curr_scope, get_named_infos, random_type_from_curr_scope, FunctionType,
        GenericType, Type, TypeSelectorBuilder,
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
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let curr_scope = get_curr_scope(env);
        let callables = get_named_infos(env).get_callable_info(&curr_scope);

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
            let new_func_typ = random_type_from_curr_scope(u, env, vec![selector])?;
            let mut all_typs = callables
                .into_iter()
                .filter_map(|info| {
                    if info.name.is_var() {
                        Some(info.typ.clone())
                    } else {
                        None
                    }
                })
                .collect::<Vec<_>>();
            all_typs.push(new_func_typ);
            let chosen = u.choose(&all_typs)?.clone();
            subtrees.push(Subtree::new_generator_subtree(
                ExprOfTypeGenerator::label(),
                AnyConstraint::new().with("type", chosen.clone()),
            ));

            if let Type::Generic(GenericType::Function(f_typ)) = chosen {
                comp_constraints.insert("type", f_typ);
            }
        } else {
            let funcs = callables
                .iter()
                .filter_map(|info| {
                    if info.name.is_func() {
                        Some(info.typ.clone())
                    } else {
                        None
                    }
                })
                .collect::<Vec<_>>();
            let chosen = u.choose(&funcs)?.clone();
            if let Type::Generic(GenericType::Function(f_typ)) = chosen {
                comp_constraints.insert("type", f_typ.clone());
                subtrees.push(Subtree::new_single_candidate(
                    Callable::Function(f_typ).into(),
                ));
            } else {
                panic!("Invalid type for callable");
            }
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
        let node = asts.into_iter().next().unwrap();
        let callable = match node {
            MoveAST::Callable(c) => c,
            MoveAST::Expression(expr) => Callable::Expression {
                expr: Box::new(expr),
                func_type: typ.clone(),
            },
            _ => panic!("Invalid AST node for callable"),
        };
        Ok(callable.into())
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
