use crate::{
    generators::SignatureGenerator,
    move_ast::{MoveAST, Signature, TypeParameters, Variable},
    states::{
        get_config, get_type_pool, new_id_from_curr_scope, Id, IdKind, Type, TypeSelectorBuilder,
    },
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct ConsumerSignatureGenerator;

impl LabelledGenerator for ConsumerSignatureGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("ConsumerSignatureGenerator").into()
    }
}

impl Register<GeneratorEntry> for ConsumerSignatureGenerator {
    fn register(&self) -> GeneratorEntry {
        let mut entry = GeneratorEntry::new::<Self>();
        entry.add_parent::<SignatureGenerator>();
        entry.skip_parent = true;
        entry
    }
}

impl Generator<MoveAST, AnyConstraint> for ConsumerSignatureGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let config = get_config(env);
        let num_params = config.num_params_in_func.select(u)?;
        let type_selector = TypeSelectorBuilder::all_no(&config).number(1).build();
        let mut parameters = vec![];

        for _ in 0..num_params {
            // Create a new var name under the function scope
            let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
            let typ = get_type_pool(env).random_type(u, vec![type_selector.clone()])?;
            parameters.push(Variable {
                name,
                typ,
                declare: true,
                show_type: true,
            });
        }

        let subtree = Subtree::new_single_candidate(
            Signature {
                name: constraint.get::<Id>("name").unwrap().clone(),
                type_params: TypeParameters::default(),
                parameters,
                return_type: Type::Unit,
            }
            .into(),
        );
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
        ast.as_signature().is_some()
    }
}
