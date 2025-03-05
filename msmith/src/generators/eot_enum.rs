use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{EnumInstantiation, Expression, MoveAST, SingleVariable},
    states::{ConcreteType, EnumVariantType, GenericType, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::warn;

#[derive(Default)]
pub struct EOTEnumGenerator;

impl LabelledGenerator for EOTEnumGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTEnumGenerator")
    }
}

impl Register<GeneratorEntry> for EOTEnumGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTEnumGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        warn!("EOTEnumGenerator::check_constraint not implemented, need to check if type parameters and abilities can be created");
        let typ = constraint.get::<Type>("type").unwrap();
        matches!(typ, Type::Generic(GenericType::Enum(_)))
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let Some(Type::Generic(GenericType::Enum(enum_type))) = constraint.get::<Type>("type")
        else {
            panic!("EOTEnumGenerator::subtrees: constraint does not have a struct type");
        };

        let (_, variant_type) = u.choose(&enum_type.variants)?;

        let mut subtrees = vec![];
        for (_, field_type) in &variant_type.fields {
            let gen_cons = AnyConstraint::new().with("type", field_type.clone());
            let subtree = Subtree::new_generator_subtree(ExprOfTypeGenerator::label(), gen_cons);
            subtrees.push(subtree);
        }
        let comp_constraint = constraint
            .clone()
            .with("variant_type", variant_type.clone());

        Ok((subtrees, comp_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let variant_type = constraint.get::<EnumVariantType>("variant_type").unwrap();
        let vars = variant_type
            .fields
            .iter()
            .map(|(id, typ)| SingleVariable::new(id, typ))
            .collect::<Vec<SingleVariable>>();

        let exprs = asts
            .into_iter()
            .map(|ast| ast.into_expression().unwrap())
            .collect::<Vec<Expression>>();
        let fields = vars.into_iter().zip(exprs).collect();

        let typ = constraint.get::<Type>("type").unwrap();

        // TODO: abilities should be inferred by the instantiated type
        Ok(Expression::EnumInstantiation(EnumInstantiation {
            enum_type: ConcreteType::new_with_empty_mapping(typ),
            variant_type: variant_type.clone(),
            fields,
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
        matches!(ast.as_expression(), Some(Expression::EnumInstantiation(_)))
    }
}
