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
use log::{error, trace};

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
            patterns.push(Pattern::new_full_positional(typ, field_patterns));
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
            patterns.push(Pattern::new_full_positional(typ, field_patterns));
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

/// Return ONE random partial patterns for the given position or named pattern.
/// TODO: maybe return all possible and choose later
fn get_partial_patterns(u: &mut Unstructured, pat: &Pattern) -> Option<Pattern> {
    trace!("Generating partial pattern for {:?}", pat);
    match &pat.body {
        PatternKind::Positional(pats) => {
            let mut new_fields = pats.clone();
            let start_index = u.int_in_range(0..=new_fields.len() - 1).unwrap();
            let num_elems_left = new_fields.len() - start_index;
            let len = u.int_in_range(1..=num_elems_left).unwrap();
            for i in 0..len {
                let idx = start_index + i;
                if idx < new_fields.len() {
                    new_fields[idx] = None;
                }
            }
            Some(Pattern::new_partial_positional(&pat.typ, new_fields))
        },
        PatternKind::Named(pairs) => {
            let mut new_paris = pairs.clone();
            let total = pairs.len();
            if total == 0 {
                return None;
            }
            let num_remove = if total == 1 {
                1
            } else {
                u.int_in_range(1..=total - 1).unwrap()
            };
            for _ in 0..num_remove {
                let idx = u.choose_index(new_paris.len()).unwrap();
                new_paris.remove(idx);
            }
            Some(Pattern::new_named(&pat.typ, new_paris))
        },
        _ => None,
    }
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
        let patterns = get_patterns_for_type(u, env, typ);
        let partials = patterns
            .iter()
            .filter_map(|pat| get_partial_patterns(u, pat))
            .collect::<Vec<Pattern>>();
        let all_patterns = patterns
            .into_iter()
            .chain(partials.into_iter())
            .map(|p| p.into())
            .collect::<Vec<MoveAST>>();
        if all_patterns.is_empty() {
            error!("No patterns found for type {:?}", typ);
        }
        let subtree = Subtree::new_candidates_subtree(all_patterns);
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
