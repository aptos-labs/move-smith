use crate::{
    move_ast::MoveAST,
    states::{ids::Id, GenerationConfig},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    selection::choose_item_weighted, GenLabel, Label, Labelled, Register, State, StateEntry,
    StateLabel,
};
use log::{trace, warn};
use std::collections::BTreeMap;

pub trait Typed {
    fn ty(&self) -> Type;
}

#[derive(Debug, Default)]
pub struct TypePool {
    /// The defined Structs, Enums, and Type Parameters
    defined_types: BTreeMap<Id, Type>,

    /// The mapping from variable to type
    variable_types: BTreeMap<Id, Type>,
}

#[derive(Debug, Clone)]
pub struct TypeSelector {
    config: GenerationConfig,
    unit_weight: u32,
    bool_weight: u32,
    number_weight: u32,
    address_weight: u32,
    struct_weight: u32,
    vector_weight: u32,
    tuple_weight: u32,
    reference_weight: u32,
    mut_reference_weight: u32,
}

impl TypeSelector {
    pub fn is_all_no(&self) -> bool {
        self.unit_weight == 0
            && self.bool_weight == 0
            && self.number_weight == 0
            && self.address_weight == 0
            && self.struct_weight == 0
            && self.vector_weight == 0
            && self.tuple_weight == 0
            && self.reference_weight == 0
            && self.mut_reference_weight == 0
    }

    pub fn is_all_yes(&self) -> bool {
        self.unit_weight == 1
            && self.bool_weight == 1
            && self.number_weight == 1
            && self.address_weight == 1
            && self.struct_weight == 1
            && self.vector_weight == 1
            && self.tuple_weight == 1
            && self.reference_weight == 1
            && self.mut_reference_weight == 1
    }
}

pub struct TypeSelectorBuilder {
    selector: TypeSelector,
}

impl TypeSelectorBuilder {
    pub fn all_yes(config: &GenerationConfig) -> Self {
        Self {
            selector: TypeSelector {
                config: config.clone(),
                unit_weight: 1,
                bool_weight: 1,
                number_weight: 1,
                address_weight: 1,
                struct_weight: 1,
                vector_weight: 1,
                tuple_weight: 1,
                reference_weight: 1,
                mut_reference_weight: 1,
            },
        }
    }

    pub fn all_no(config: &GenerationConfig) -> Self {
        Self {
            selector: TypeSelector {
                config: config.clone(),
                unit_weight: 0,
                bool_weight: 0,
                number_weight: 0,
                address_weight: 0,
                struct_weight: 0,
                vector_weight: 0,
                tuple_weight: 0,
                reference_weight: 0,
                mut_reference_weight: 0,
            },
        }
    }

    pub fn primitive_only(config: &GenerationConfig) -> Self {
        Self {
            selector: TypeSelector {
                config: config.clone(),
                unit_weight: 0,
                bool_weight: 1,
                number_weight: 1,
                address_weight: 0,
                struct_weight: 0,
                vector_weight: 0,
                tuple_weight: 0,
                reference_weight: 0,
                mut_reference_weight: 0,
            },
        }
    }

    pub fn unit(mut self, weight: u32) -> Self {
        self.selector.unit_weight = weight;
        self
    }

    pub fn bool(mut self, weight: u32) -> Self {
        self.selector.bool_weight = weight;
        self
    }

    pub fn number(mut self, weight: u32) -> Self {
        self.selector.number_weight = weight;
        self
    }

    pub fn address(mut self, weight: u32) -> Self {
        self.selector.address_weight = weight;
        self
    }

    pub fn struct_(mut self, weight: u32) -> Self {
        self.selector.struct_weight = weight;
        self
    }

    pub fn vector(mut self, weight: u32) -> Self {
        self.selector.vector_weight = weight;
        self
    }

    pub fn tuple(mut self, weight: u32) -> Self {
        self.selector.tuple_weight = weight;
        self
    }

    pub fn reference(mut self, weight: u32) -> Self {
        self.selector.reference_weight = weight;
        self
    }

    pub fn mut_reference(mut self, weight: u32) -> Self {
        self.selector.mut_reference_weight = weight;
        self
    }

    pub fn build(self) -> TypeSelector {
        self.selector
    }
}

impl TypePool {
    pub fn random_defined_type(&self, u: &mut Unstructured) -> Result<Type> {
        let keys = self.defined_types.keys().cloned().collect::<Vec<_>>();
        let id = u.choose(&keys)?;
        Ok(self.defined_types.get(id).unwrap().clone())
    }

    pub fn random_number_type(&self, u: &mut Unstructured) -> Result<NumberType> {
        let typ = choose_item_weighted(u, &[
            (NumberType::U8, 10),
            (NumberType::U16, 10),
            (NumberType::U32, 10),
            (NumberType::U64, 10),
            (NumberType::U128, 1),
            (NumberType::U256, 1),
        ])?;
        Ok(typ)
    }

    pub fn random_type(
        &self,
        u: &mut Unstructured,
        mut selectors: Vec<TypeSelector>,
    ) -> Result<Type> {
        let selector = match selectors.len() {
            1 => selectors[0].clone(),
            _ => selectors.pop().unwrap(),
        };

        let mut candidates = vec![];

        if selector.unit_weight > 0 {
            candidates.push((Type::Unit, selector.unit_weight));
        }

        if selector.bool_weight > 0 {
            candidates.push((Type::Primitive(Primitive::Bool), selector.bool_weight));
        }

        if selector.number_weight > 0 {
            let typ = Type::Primitive(Primitive::Number(self.random_number_type(u)?));
            candidates.push((typ, selector.number_weight));
        }

        if selector.address_weight > 0 {
            candidates.push((Type::Primitive(Primitive::Address), selector.address_weight));
        }

        if selector.struct_weight > 0 {
            warn!("random Struct type not implemented");
            unimplemented!();
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
                .map(|_| self.random_type(u, selectors.clone()))
                .collect::<Result<Vec<Type>>>()?;
            let typ = Type::Generic(GenericType::Tuple(TupleType { types: elems }));
            candidates.push((typ, selector.tuple_weight));
        }

        if selector.reference_weight > 0 {
            warn!("random Reference type not implemented");
            unimplemented!();
        }

        if selector.mut_reference_weight > 0 {
            warn!("random Mutable Reference type not implemented");
            unimplemented!();
        }

        trace!("Candidates: {:?}", candidates);
        trace!("Selector: {:?}", selector);
        let chosen = choose_item_weighted(u, &candidates)?;
        trace!("Chosen type: {:?}", chosen);
        Ok(chosen)
    }
}

impl Labelled for TypePool {
    fn label() -> Label {
        StateLabel::new("TypePool").into()
    }
}

impl Register<StateEntry> for TypePool {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label().try_into().unwrap(),
            generators: vec![
                // TODO
            ],
        }
    }
}

impl State<MoveAST> for TypePool {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {}

    fn update_post(&mut self, _u: &mut Unstructured, new_ast: &MoveAST, generator: &GenLabel) {
        if generator == &GenLabel::new_module_member_level("StructDef") {
            if let MoveAST::Struct(s) = new_ast {
                let ty = s.ty();
                self.defined_types.insert(s.name.clone(), ty);
            }
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Type {
    Unit,
    Generic(GenericType),
    Primitive(Primitive),
    TypeParameter(TypeParameter),
    Concrete(ConcreteType),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ConcreteType {
    pub mapping: BTreeMap<TypeParameter, Type>,
    pub typ: Box<Type>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum GenericType {
    Struct(StructType),
    Vector(VectorType),
    Tuple(TupleType),
    Reference(ReferenceType),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Primitive {
    Address,
    Bool,
    Number(NumberType),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum NumberType {
    U8,
    U16,
    U32,
    U64,
    U128,
    U256,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TypeParameter {
    pub name: Id,
    pub abilities: Vec<Ability>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct StructType {
    pub name: Id,
    pub type_params: Vec<TypeParameter>, // Must be Type::TypeParameter
    pub fields: Vec<(Id, Type)>,
    pub abilities: Vec<Ability>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TupleType {
    pub types: Vec<Type>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct VectorType {
    pub ty: Box<Type>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ReferenceType {
    Immutable(Box<Type>),
    Mutable(Box<Type>),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Ability {
    Copy,
    Drop,
    Store,
    Key,
}
