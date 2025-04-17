//! Helper functions for accessing and operating on common states

use crate::{
    move_ast::{DotVariable, MoveAST, Pattern, PatternKind, SingleVariable, Variable},
    states::{
        types::{
            EnumType, EnumVariantType, GenericType, Primitive, TupleType, Type, TypePool,
            TypeSelector, Typed,
        },
        Ability, CurrScope, CurrentInfo, Depth, GenerationConfig, Id, IdKind, IdPool, InitMap,
        Scope,
    },
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{selection::choose_item_weighted, StatePool};
use log::{trace, warn};

#[inline]
pub fn get_config(env: &StatePool<MoveAST>) -> &GenerationConfig {
    env.get::<GenerationConfig>().unwrap()
}

#[inline]
pub fn get_config_mut(env: &mut StatePool<MoveAST>) -> &mut GenerationConfig {
    env.get_mut::<GenerationConfig>().unwrap()
}

#[inline]
pub fn get_type_pool(env: &StatePool<MoveAST>) -> &TypePool {
    env.get::<TypePool>().unwrap()
}

#[inline]
pub fn get_id_pool(env: &StatePool<MoveAST>) -> &IdPool {
    env.get::<IdPool>().unwrap()
}

#[inline]
pub fn get_curr_scope(env: &StatePool<MoveAST>) -> Scope {
    env.get::<CurrScope>().unwrap().get()
}

#[inline]
pub fn get_current_info(env: &StatePool<MoveAST>) -> &CurrentInfo {
    env.get::<CurrentInfo>().unwrap()
}

#[inline]
pub fn push_scope(env: &mut StatePool<MoveAST>, scope: Scope) {
    env.get_mut::<CurrScope>().unwrap().push(scope);
}

#[inline]
pub fn pop_scope(env: &mut StatePool<MoveAST>) {
    env.get_mut::<CurrScope>().unwrap().pop();
}

#[inline]
pub fn reached_max_expr_depth(env: &StatePool<MoveAST>) -> bool {
    env.get::<Depth>().unwrap().expr_depth.reached_depth_limit()
}

#[inline]
pub fn almost_reached_max_expr_depth(env: &StatePool<MoveAST>, increment: usize) -> bool {
    env.get::<Depth>()
        .unwrap()
        .expr_depth
        .will_reached_depth_limit(increment)
}

/// Create a new id from the current scope and use the new scope as current scope
/// Returns (new id, new scope, old scope)
pub fn new_id_from_curr_scope_and_push_scope(
    env: &mut StatePool<MoveAST>,
    id_kind: IdKind,
) -> (Id, Scope, Scope) {
    let curr_scope = env.get::<CurrScope>().unwrap().get();
    let (name, new_scope) = new_id_and_push_scope(env, id_kind, &curr_scope);
    (name, new_scope, curr_scope)
}

pub fn new_id_and_push_scope(
    env: &mut StatePool<MoveAST>,
    id_kind: IdKind,
    parent_scope: &Scope,
) -> (Id, Scope) {
    let (name, scope) = new_id(env, id_kind, parent_scope);
    env.get_mut::<CurrScope>().unwrap().push(scope.clone());
    (name, scope)
}

#[inline]
pub fn new_id(env: &mut StatePool<MoveAST>, id_kind: IdKind, parent_scope: &Scope) -> (Id, Scope) {
    env.get_mut::<IdPool>()
        .unwrap()
        .next_id(id_kind, parent_scope)
}

pub fn new_id_from_curr_scope(env: &mut StatePool<MoveAST>, id_kind: IdKind) -> (Id, Scope) {
    let curr_scope = env.get::<CurrScope>().unwrap().get();
    new_id(env, id_kind, &curr_scope)
}

pub fn get_all_dot_vars_from_rec(curr: DotVariable) -> Vec<DotVariable> {
    let curr_type = curr.ty();
    let fields = match &curr_type {
        Type::Generic(GenericType::Struct(s)) if !s.positional => &s.fields,
        Type::Generic(GenericType::Enum(e)) => &e.get_possible_named_fields(),
        _ => return vec![],
    };
    let mut dot_vars = vec![];
    for (field_name, field_type) in fields {
        let new_dot_var =
            DotVariable::new_with_prefix(&curr, (field_name.clone(), field_type.clone()));
        dot_vars.push(new_dot_var.clone());
        dot_vars.extend(get_all_dot_vars_from_rec(new_dot_var));
    }
    dot_vars
}

pub fn get_all_dot_vars_from(id: &Id, env: &StatePool<MoveAST>) -> Vec<DotVariable> {
    let id_typ = get_type_pool(env).get_var_type(id).unwrap();
    let id_dot = DotVariable::new(vec![(id.clone(), id_typ.clone())]);
    get_all_dot_vars_from_rec(id_dot)
}

pub fn get_initialized_vars_in_curr_scope_of_type(
    env: &StatePool<MoveAST>,
    wanted: Option<&Type>,
) -> Vec<Variable> {
    let curr_scope = env.get::<CurrScope>().unwrap().get();
    let id_pool = env.get::<IdPool>().unwrap();
    let all_ids = id_pool.get_ids_of_ident_kind(IdKind::Var);
    let ids = id_pool.filter_id_in_scope(&all_ids, &curr_scope);
    let ids = ids
        .into_iter()
        .filter(|id| env.get::<InitMap>().unwrap().is_var_initialized(id))
        .collect::<Vec<Id>>();

    let type_pool = env.get::<TypePool>().unwrap();

    let mut all_vars = vec![];
    for id in ids {
        let id_typ = type_pool.get_var_type(&id).unwrap();
        if Some(&id_typ) == wanted {
            all_vars.push(SingleVariable::new(&id, &id_typ).into());
        }

        match &id_typ {
            Type::Generic(GenericType::Enum(_)) | Type::Generic(GenericType::Struct(_)) => {
                let dot_vars = get_all_dot_vars_from(&id, env);
                for dot_var in dot_vars {
                    if Some(&dot_var.ty()) == wanted {
                        all_vars.push(dot_var.into());
                    }
                }
            },
            _ => {},
        }
    }
    all_vars
}

pub fn get_patterns_for_type(
    u: &mut Unstructured,
    env: &mut StatePool<MoveAST>,
    typ: &Type,
    scope: &Scope,
) -> Vec<Pattern> {
    let mut patterns = vec![];
    match typ {
        Type::Concrete(ct) => {
            patterns = get_patterns_for_type(u, env, &ct.get_concretized_type(), scope)
        },
        Type::Primitive(_) => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
        },
        Type::Generic(GenericType::Tuple(t)) => {
            let field_patterns = t
                .types
                .iter()
                .map(|t| {
                    let pats = get_patterns_for_type(u, env, t, scope);
                    u.choose(&pats).unwrap().clone()
                })
                .collect();
            patterns.push(Pattern::new_full_positional(typ, field_patterns));
        },
        Type::Generic(GenericType::Struct(s)) if s.positional => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
            let field_patterns = s
                .fields
                .iter()
                .map(|(_, t)| {
                    let pats = get_patterns_for_type(u, env, t, scope);
                    let partials = pats
                        .iter()
                        .filter_map(|pat| get_partial_patterns(u, pat))
                        .collect::<Vec<Pattern>>();
                    let all = pats.into_iter().chain(partials).collect::<Vec<Pattern>>();
                    u.choose(&all).unwrap().clone()
                })
                .collect::<Vec<Pattern>>();
            patterns.push(Pattern::new_full_positional(typ, field_patterns));
        },
        Type::Generic(GenericType::Struct(s)) if !s.positional => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
            let field_patterns = s
                .fields
                .iter()
                .map(|(name, t)| {
                    let pats = get_patterns_for_type(u, env, t, scope);
                    let partials = pats
                        .iter()
                        .filter_map(|pat| get_partial_patterns(u, pat))
                        .collect::<Vec<Pattern>>();
                    let all = pats.into_iter().chain(partials).collect::<Vec<Pattern>>();
                    (name.clone(), u.choose(&all).unwrap().clone())
                })
                .collect::<Vec<(Id, Pattern)>>();
            patterns.push(Pattern::new_named(typ, field_patterns, s.fields.len()));
        },
        Type::Generic(GenericType::Enum(_)) => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
        },
        Type::Generic(GenericType::Function(_)) => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
        },
        Type::Generic(_) => {},
        _ => {},
    }
    patterns
}

/// Return ONE random partial patterns for the given position or named pattern.
/// TODO: maybe return all possible and choose later
pub fn get_partial_patterns(u: &mut Unstructured, pat: &Pattern) -> Option<Pattern> {
    trace!("Generating partial pattern for {:?}", pat);
    match &pat.body {
        PatternKind::Positional(pats) => {
            if pats.is_empty() {
                return None;
            }
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
        PatternKind::Named(pairs, num_total_fields) => {
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
            Some(Pattern::new_named(&pat.typ, new_paris, *num_total_fields))
        },
        _ => None,
    }
}

pub fn get_complete_patterns_for_enum(
    u: &mut Unstructured,
    env: &mut StatePool<MoveAST>,
    enum_type: EnumType,
    scope: &Scope,
) -> Vec<(Pattern, EnumVariantType, Scope)> {
    let mut output = vec![];
    for (_, variant) in &enum_type.variants {
        // Create a dummy block scope for each variant arm
        let (_, arm_scope) = new_id_and_push_scope(env, IdKind::Block, scope);

        let mut patterns = vec![];
        for (_, field_type) in &variant.fields {
            let pats = get_patterns_for_type(u, env, field_type, &arm_scope);
            let partials = pats
                .iter()
                .filter_map(|pat| get_partial_patterns(u, pat))
                .collect::<Vec<Pattern>>();
            let all_patterns = pats.into_iter().chain(partials).collect::<Vec<Pattern>>();
            patterns.push(u.choose(&all_patterns).unwrap().clone());
        }
        pop_scope(env);

        let variant_type = Type::Generic(GenericType::EnumVariant(variant.clone()));
        let arm_pattern = match &variant.positional {
            true => Pattern::new_full_positional(&variant_type, patterns),
            false => {
                let names_pats: Vec<(Id, Pattern)> = variant
                    .fields
                    .iter()
                    .zip(patterns.iter())
                    .map(|((name, _), pat)| (name.clone(), pat.clone()))
                    .collect();
                Pattern::new_named(&variant_type, names_pats, variant.fields.len())
            },
        };
        let partial_arm_pattern = get_partial_patterns(u, &arm_pattern);
        let chosen = match (partial_arm_pattern, bool::arbitrary(u).unwrap()) {
            (None, _) => arm_pattern,
            (Some(partial), true) => partial,
            (Some(_), false) => arm_pattern,
        };
        output.push((chosen, variant.clone(), arm_scope));
    }
    output
}

pub fn random_type_from_curr_scope(
    u: &mut Unstructured,
    env: &StatePool<MoveAST>,
    mut selectors: Vec<TypeSelector>,
) -> Result<Type> {
    let selector = match selectors.len() {
        1 => selectors[0].clone(),
        _ => selectors.pop().unwrap(),
    };

    // Outer vector element: (type candidates in a category, weight of the category)
    // Inner vector element: (type candidate, weight of the candidate)
    let mut candidates: Vec<(Vec<(Type, u32)>, u32)> = vec![];
    let type_pool = get_type_pool(env);

    if selector.unit_weight > 0 {
        candidates.push((vec![(Type::Unit, 1)], selector.unit_weight));
    }

    if selector.bool_weight > 0 {
        candidates.push((
            vec![(Type::Primitive(Primitive::Bool), 1)],
            selector.bool_weight,
        ));
    }

    if selector.number_weight > 0 {
        let types = type_pool.number_type_selection_weights();
        candidates.push((types, selector.number_weight));
    }

    if selector.address_weight > 0 {
        candidates.push((
            vec![(Type::Primitive(Primitive::Address), 1)],
            selector.address_weight,
        ));
    }

    if selector.struct_weight > 0 {
        let struct_types = type_pool
            .get_all_defined_structs()
            .into_iter()
            .map(|s| (s, 1))
            .collect::<Vec<(Type, u32)>>();
        if struct_types.is_empty() {
            warn!("No struct types defined");
        } else {
            candidates.push((struct_types, selector.struct_weight));
        }
    }

    if selector.enum_weight > 0 {
        let enum_types = type_pool
            .get_all_defined_enums()
            .into_iter()
            .map(|s| (s, 1))
            .collect::<Vec<(Type, u32)>>();
        if enum_types.is_empty() {
            warn!("No struct types defined");
        } else {
            candidates.push((enum_types, selector.enum_weight));
        }
    }

    if selector.vector_weight > 0 {
        warn!("random Vector type not implemented");
        unimplemented!();
    }

    if selector.tuple_weight > 0 {
        let num_elem = selector.config.num_elem_in_tuple.select(u)?;

        // Cannot have a tuple of tuples
        selectors.iter_mut().for_each(|s| {
            s.tuple_weight = 0;
            s.unit_weight = 0;
            // Avoid having nothing to choose
            if s.is_all_no() {
                s.number_weight = 1;
            }
        });

        let elems = (0..num_elem)
            .map(|_| random_type_from_curr_scope(u, env, selectors.clone()))
            .collect::<Result<Vec<Type>>>()?;

        let typ = Type::Generic(GenericType::Tuple(TupleType { types: elems }));
        candidates.push((vec![(typ, 1)], selector.tuple_weight));
    }

    if selector.reference_weight > 0 {
        warn!("random Reference type not implemented");
        unimplemented!();
    }

    if selector.mut_reference_weight > 0 {
        warn!("random Mutable Reference type not implemented");
        unimplemented!();
    }

    if selector.func_return > 0 {
        let mut ret_types = type_pool
            .get_all_defined_func_types()
            .into_iter()
            .filter_map(|typ| {
                if let Type::Generic(GenericType::Function(f)) = typ {
                    if f.has_return() {
                        Some((f.return_type.as_ref().clone(), 1))
                    } else {
                        None
                    }
                } else {
                    None
                }
            })
            .collect::<Vec<(Type, u32)>>();
        if selector.tuple_weight == 0 {
            // Filter out tuple types
            ret_types.retain(|(typ, _)| !typ.is_generic_tuple());
        }
        if ret_types.is_empty() {
            warn!("No function defined so far");
        } else {
            candidates.push((ret_types, selector.func_return));
        }
    }

    // TODO: generate new function types
    if selector.func_value > 0 {
        let all_funcs = type_pool.get_all_defined_func_types();
        let mut chosen = u.choose(&all_funcs)?.clone();
        match &mut chosen {
            Type::Generic(GenericType::Function(f)) => {
                f.is_func_value = true;
                f.abilities = Some(Ability::copy_drop());
            },
            _ => panic!("Not a function type"),
        }
        candidates.push((vec![(chosen, 1)], selector.func_value));
    }

    trace!("Candidates: {:?}", candidates);
    trace!("Selector: {:?}", selector);
    let chosen_category = choose_item_weighted(u, &candidates)?;
    let chosen = choose_item_weighted(u, &chosen_category)?;
    trace!("Chosen type: {:?}", chosen);
    Ok(chosen)
}
