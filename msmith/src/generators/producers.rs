use super::ProducerGenerator;
use crate::{
    move_ast::{MoveAST, Producers},
    states::{get_curr_scope, get_named_infos},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct ProducersGenerator;

impl LabelledGenerator for ProducersGenerator {
    fn label() -> GenLabel {
        GenLabel::new("ProducersGenerator")
    }
}

impl Register<GeneratorEntry> for ProducersGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for ProducersGenerator {
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
        let mut all_enums = get_named_infos(env).get_all_enum_types(&curr_scope);
        for t in &mut all_enums {
            let et = t.as_enum_mut().unwrap();
            let variant_idx = u.choose_index(et.variants.len())?;
            et.variant_pos = Some(variant_idx);
        }
        let mut all_types = get_named_infos(env).get_all_struct_types(&curr_scope);
        all_types.extend(all_enums);

        let mut subtrees = vec![];

        for typ in all_types.into_iter() {
            subtrees.push(Subtree::new_generator_subtree(
                ProducerGenerator::label(),
                AnyConstraint::new().with("type", typ),
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
        let funcs = asts
            .into_iter()
            .map(|ast| ast.into_function().unwrap())
            .collect();
        Ok(Producers(funcs).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_producers().is_some()
    }
}
