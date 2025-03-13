use crate::{
    move_ast::{MoveAST, Pattern, PatternKind},
    states::{new_id_from_curr_scope, GenericType, Id, IdKind, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::trace;

#[derive(Default)]
pub struct PatternGenerator;

impl LabelledGenerator for PatternGenerator {
    fn label() -> GenLabel {
        GenLabel::new("PatternGenerator")
    }
}

impl Register<GeneratorEntry> for PatternGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

// TODO: Implement a version that can reuse existing droppable variables
fn get_patterns_for_type(
    u: &mut Unstructured,
    env: &mut StatePool<MoveAST>,
    typ: &Type,
) -> Vec<Pattern> {
    let mut patterns = vec![];
    match typ {
        Type::Concrete(ct) => patterns = get_patterns_for_type(u, env, &ct.get_concretized_type()),
        Type::Primitive(_) => {
            let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
            patterns.push(Pattern::new_single_var(&name, typ));
        },
        Type::Generic(GenericType::Tuple(t)) => {
            let field_patterns = t
                .types
                .iter()
                .map(|t| {
                    let pats = get_patterns_for_type(u, env, t);
                    u.choose(&pats).unwrap().clone()
                })
                .collect();
            patterns.push(Pattern {
                typ: typ.clone(),
                body: PatternKind::Positional(field_patterns),
            });
        },
        Type::Generic(GenericType::Struct(s)) if s.positional => {
            let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
            patterns.push(Pattern::new_single_var(&name, typ));
            let field_patterns = s
                .fields
                .iter()
                .map(|(_, t)| {
                    let pats = get_patterns_for_type(u, env, t);
                    u.choose(&pats).unwrap().clone()
                })
                .collect::<Vec<Pattern>>();
            patterns.push(Pattern::new_positional(typ, field_patterns));
        },
        Type::Generic(GenericType::Struct(s)) if !s.positional => {
            let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
            patterns.push(Pattern::new_single_var(&name, typ));
            let field_patterns = s
                .fields
                .iter()
                .map(|(name, t)| {
                    let pats = get_patterns_for_type(u, env, t);
                    (name.clone(), u.choose(&pats).unwrap().clone())
                })
                .collect::<Vec<(Id, Pattern)>>();
            patterns.push(Pattern::new_named(typ, field_patterns));
        },
        Type::Generic(GenericType::Enum(_)) => {
            let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
            patterns.push(Pattern::new_single_var(&name, typ));
        },
        Type::Generic(_) => {},
        _ => {},
    }
    patterns
}

impl Generator<MoveAST, AnyConstraint> for PatternGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_exist_and_type::<Type>("type")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let Some(typ) = constraint.get::<Type>("type") else {
            panic!("Type not found in constraint")
        };
        let patterns = get_patterns_for_type(u, env, typ)
            .into_iter()
            .map(|p| p.into())
            .collect::<Vec<MoveAST>>();
        if patterns.is_empty() {
            trace!("No patterns found for type {:?}", typ);
        }
        let subtree = Subtree::new_candidates_subtree(patterns);
        return Ok((vec![subtree], AnyConstraint::new()));
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
        ast.as_pattern().is_some()
    }
}
