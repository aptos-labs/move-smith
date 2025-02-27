use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{Expression, MoveAST, SingleVariable, StructInstantiation},
    states::{ConcreteType, GenericType, StructType, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::warn;

#[derive(Default)]
pub struct EOTStructGenerator;

impl LabelledGenerator for EOTStructGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTStructGenerator")
    }
}

impl Register<GeneratorEntry> for EOTStructGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTStructGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        warn!("EOTStructGenerator::check_constraint not implemented, need to check if type parameters and abilities can be created");
        let typ = constraint.get::<Type>("type").unwrap();
        match typ {
            Type::Generic(GenericType::Struct(_)) => true,
            _ => false,
        }
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        if let Some(Type::Generic(GenericType::Struct(struct_type))) =
            constraint.get::<Type>("type")
        {
            let mut subtrees = vec![];
            for (_, field_type) in &struct_type.fields {
                let gen_cons = AnyConstraint::new().with("type", field_type.clone());
                let subtree =
                    Subtree::new_generator_subtree(ExprOfTypeGenerator::label(), gen_cons);
                subtrees.push(subtree);
            }
            Ok((
                subtrees,
                constraint.clone().with("struct_type", struct_type.clone()),
            ))
        } else {
            panic!("EOTStructGenerator::subtrees: constraint does not have a struct type");
        }
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let typ = constraint.get::<Type>("type").unwrap();
        let struct_type = constraint.get::<StructType>("struct_type").unwrap();
        let vars = struct_type
            .fields
            .iter()
            .map(|(id, typ)| SingleVariable::new(id, typ))
            .collect::<Vec<SingleVariable>>();
        let exprs = asts
            .into_iter()
            .map(|ast| ast.into_expression().unwrap())
            .collect::<Vec<Expression>>();

        let fields = vars.into_iter().zip(exprs).collect();
        // TODO: abilities should be inferred by the instantiated type
        Ok(Expression::StructInstantiation(StructInstantiation {
            struct_type: ConcreteType::new_with_empty_mapping(typ),
            abilities: struct_type.abilities.clone(),
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
        match ast.as_expression() {
            Some(Expression::StructInstantiation(_)) => true,
            _ => false,
        }
    }
}
