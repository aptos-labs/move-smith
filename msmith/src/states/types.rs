use crate::{
    generators::{
        EnumGenerator, LetAssignGenerator, LetDeclGenerator, SignatureGenerator, StructGenerator,
    },
    move_ast::{Assignment, MoveAST, Pattern, PatternKind, Statement, Variable},
    states::{
        ids::{Id, Named},
        GenerationConfig, IdKind,
    },
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    selection::choose_item_weighted, GenLabel, LabelledGenerator, LabelledState, Register, State,
    StateEntry, StateLabel,
};
use log::{trace, warn};
use std::collections::{BTreeMap, BTreeSet};

pub trait Typed {
    fn ty(&self) -> Type;
}

#[derive(Debug, Clone)]
pub struct TypeSelector {
    config: GenerationConfig,
    unit_weight: u32,
    bool_weight: u32,
    number_weight: u32,
    address_weight: u32,
    struct_weight: u32,
    enum_weight: u32,
    vector_weight: u32,
    tuple_weight: u32,
    reference_weight: u32,
    mut_reference_weight: u32,
    func_return: u32,
}

impl TypeSelector {
    pub fn is_all_no(&self) -> bool {
        self.unit_weight == 0
            && self.bool_weight == 0
            && self.number_weight == 0
            && self.address_weight == 0
            && self.struct_weight == 0
            && self.enum_weight == 0
            && self.vector_weight == 0
            && self.tuple_weight == 0
            && self.reference_weight == 0
            && self.mut_reference_weight == 0
            && self.func_return == 0
    }

    pub fn is_all_yes(&self) -> bool {
        self.unit_weight > 0
            && self.bool_weight > 0
            && self.number_weight > 0
            && self.address_weight > 0
            && self.struct_weight > 0
            && self.enum_weight > 0
            && self.vector_weight > 0
            && self.tuple_weight > 0
            && self.reference_weight > 0
            && self.mut_reference_weight > 0
            && self.func_return > 0
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
                enum_weight: 1,
                vector_weight: 1,
                tuple_weight: 1,
                reference_weight: 1,
                mut_reference_weight: 1,
                func_return: 1,
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
                enum_weight: 0,
                vector_weight: 0,
                tuple_weight: 0,
                reference_weight: 0,
                mut_reference_weight: 0,
                func_return: 0,
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
                enum_weight: 0,
                vector_weight: 0,
                tuple_weight: 0,
                reference_weight: 0,
                mut_reference_weight: 0,
                func_return: 0,
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

    pub fn structs(mut self, weight: u32) -> Self {
        self.selector.struct_weight = weight;
        self
    }

    pub fn enums(mut self, weight: u32) -> Self {
        self.selector.enum_weight = weight;
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

    pub fn func_return(mut self, weight: u32) -> Self {
        self.selector.func_return = weight;
        self
    }

    pub fn build(self) -> TypeSelector {
        self.selector
    }
}

#[derive(Debug, Default)]
pub struct TypePool {
    /// The defined Structs, Enums, and Type Parameters
    defined_types: BTreeMap<Id, Type>,

    // Defined functions
    defined_funcs: BTreeMap<Id, Type>,

    /// The mapping from variable to type
    variable_types: BTreeMap<Id, Type>,
}

impl TypePool {
    pub fn get_defined_type(&self, id: &Id) -> Option<Type> {
        self.defined_types.get(id).cloned()
    }

    pub fn get_var_type(&self, id: &Id) -> Option<Type> {
        self.variable_types.get(id).cloned()
    }

    pub fn all_callable_function_within(&self, curr_func: &Id) -> Vec<FunctionType> {
        // Find index of curr_func
        let curr_idx = self
            .defined_funcs
            .iter()
            .position(|(id, _)| id == curr_func)
            .ok_or_else(|| anyhow::anyhow!("curr_func not found in defined_funcs: {:?}", curr_func))
            .unwrap();

        // Return the first curr_idx functions
        let callable = self
            .defined_funcs
            .iter()
            .take(curr_idx)
            .filter_map(|(_, typ)| {
                if let Type::Generic(GenericType::Function(f)) = typ {
                    Some(f.clone())
                } else {
                    None
                }
            })
            .collect::<Vec<FunctionType>>();
        callable
    }

    pub fn random_defined_type(&self, u: &mut Unstructured) -> Result<Type> {
        let keys = self.defined_types.keys().cloned().collect::<Vec<_>>();
        let id = u.choose(&keys)?;
        Ok(self.defined_types.get(id).unwrap().clone())
    }

    pub fn number_type_selection_weights(&self) -> Vec<(Type, u32)> {
        vec![
            (Type::Primitive(Primitive::Number(NumberType::U8)), 30),
            (Type::Primitive(Primitive::Number(NumberType::U16)), 30),
            (Type::Primitive(Primitive::Number(NumberType::U32)), 30),
            (Type::Primitive(Primitive::Number(NumberType::U64)), 10),
            (Type::Primitive(Primitive::Number(NumberType::U128)), 1),
            (Type::Primitive(Primitive::Number(NumberType::U256)), 1),
        ]
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

        // Outer vector element: (type candidates in a category, weight of the category)
        // Inner vector element: (type candidate, weight of the candidate)
        let mut candidates: Vec<(Vec<(Type, u32)>, u32)> = vec![];

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
            let types = self.number_type_selection_weights();
            candidates.push((types, selector.number_weight));
        }

        if selector.address_weight > 0 {
            candidates.push((
                vec![(Type::Primitive(Primitive::Address), 1)],
                selector.address_weight,
            ));
        }

        if selector.struct_weight > 0 {
            let struct_types = self
                .defined_types
                .iter()
                .filter(|(_, typ)| typ.is_generic_struct())
                .map(|(_, typ)| (typ.clone(), 1))
                .collect::<Vec<(Type, u32)>>();
            if struct_types.is_empty() {
                warn!("No struct types defined");
            } else {
                candidates.push((struct_types, selector.struct_weight));
            }
        }

        if selector.enum_weight > 0 {
            let enum_types = self
                .defined_types
                .iter()
                .filter(|(_, typ)| typ.is_generic_enum())
                .map(|(_, typ)| (typ.clone(), 1))
                .collect::<Vec<(Type, u32)>>();
            if enum_types.is_empty() {
                warn!("No enum types defined");
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
                .map(|_| self.random_type(u, selectors.clone()))
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
            let mut ret_types = self
                .defined_funcs
                .values()
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

        trace!("Candidates: {:?}", candidates);
        trace!("Selector: {:?}", selector);
        let chosen_category = choose_item_weighted(u, &candidates)?;
        let chosen = choose_item_weighted(u, &chosen_category)?;
        trace!("Chosen type: {:?}", chosen);
        Ok(chosen)
    }
}

impl LabelledState for TypePool {
    fn label() -> StateLabel {
        StateLabel::new("TypePool")
    }
}

impl Register<StateEntry> for TypePool {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![
                StructGenerator::label(),
                EnumGenerator::label(),
                SignatureGenerator::label(),
                LetAssignGenerator::label(),
                LetDeclGenerator::label(),
            ],
        }
    }
}

fn get_defined_vars_from_pattern(pattern: &Pattern) -> Vec<(Id, Type)> {
    match &pattern.body {
        PatternKind::Variable(Variable::SingleVariable(sv)) => vec![(sv.name.clone(), sv.ty())],
        PatternKind::Variable(Variable::DotVariable(_)) => vec![], // Dot variable cannot be defined
        PatternKind::Positional(fields) => fields
            .iter()
            .map(|f| {
                if let Some(p) = f {
                    get_defined_vars_from_pattern(p)
                } else {
                    vec![]
                }
            })
            .flatten()
            .collect(),
        PatternKind::Named(pairs) => {
            let top_level = pairs
                .iter()
                .map(|(id, pat)| (id.clone(), pat.ty()))
                .collect::<Vec<(Id, Type)>>();
            let nested = pairs
                .iter()
                .map(|(_, pat)| get_defined_vars_from_pattern(pat))
                .flatten()
                .collect::<Vec<(Id, Type)>>();
            top_level.into_iter().chain(nested.into_iter()).collect()
        },
        PatternKind::Wildcard => vec![],
    }
}

impl State<MoveAST> for TypePool {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {}

    fn update_post(&mut self, _u: &mut Unstructured, new_ast: &MoveAST, _generator: &GenLabel) {
        use MoveAST as M;
        match &new_ast {
            M::Struct(s) => {
                self.defined_types.insert(s.name.clone(), s.ty());
            },
            M::Enum(e) => {
                self.defined_types.insert(e.name.clone(), e.ty());
            },
            M::Signature(s) => {
                self.defined_funcs.insert(s.name.clone(), s.ty());
                for p in &s.parameters {
                    self.variable_types.insert(p.name.clone(), p.ty());
                }
            },
            M::Statement(Statement::LetAssign(Assignment::AssignPattern(pat, _))) => {
                let vars = get_defined_vars_from_pattern(pat);
                for (id, ty) in vars {
                    self.variable_types.insert(id, ty);
                }
            },
            M::Statement(Statement::LetDeclare(vars)) => {
                for v in vars {
                    self.variable_types.insert(v.name.clone(), v.ty());
                }
            },
            _ => {},
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum Type {
    Unit,
    Generic(GenericType),
    Primitive(Primitive),
    TypeParameter(TypeParameter),
    Concrete(ConcreteType),
}

impl Type {
    pub fn is_unit(&self) -> bool {
        self == &Type::Unit
    }

    pub fn is_generic(&self) -> bool {
        matches!(self, Type::Generic(_))
    }

    pub fn is_primitive(&self) -> bool {
        matches!(self, Type::Primitive(_))
    }

    pub fn is_type_parameter(&self) -> bool {
        matches!(self, Type::TypeParameter(_))
    }

    pub fn is_concrete(&self) -> bool {
        matches!(self, Type::Concrete(_))
    }

    pub fn is_generic_struct(&self) -> bool {
        matches!(self, Type::Generic(GenericType::Struct(_)))
    }

    pub fn is_concrete_struct(&self) -> bool {
        matches!(self, Type::Concrete(ConcreteType { typ, .. }) if typ.is_generic_struct())
    }

    pub fn is_struct(&self) -> bool {
        self.is_generic_struct() || self.is_concrete_struct()
    }

    pub fn as_struct(&self) -> Option<&StructType> {
        match self {
            Type::Generic(GenericType::Struct(s)) => Some(s),
            Type::Concrete(ConcreteType { typ, .. }) => typ.as_struct(),
            _ => None,
        }
    }

    pub fn is_generic_enum(&self) -> bool {
        matches!(self, Type::Generic(GenericType::Enum(_)))
    }

    pub fn is_concrete_enum(&self) -> bool {
        matches!(self, Type::Concrete(ConcreteType { typ, .. }) if typ.is_generic_enum())
    }

    pub fn is_enum(&self) -> bool {
        self.is_generic_enum() || self.is_concrete_enum()
    }

    pub fn is_generic_tuple(&self) -> bool {
        matches!(self, Type::Generic(GenericType::Tuple(_)))
    }

    pub fn is_concrete_tuple(&self) -> bool {
        matches!(self, Type::Concrete(ConcreteType { typ, .. }) if typ.is_generic_tuple())
    }

    pub fn is_tuple(&self) -> bool {
        self.is_generic_tuple() || self.is_concrete_tuple()
    }
}

impl Named for Type {
    fn name(&self) -> Id {
        match self {
            Type::Generic(GenericType::Struct(s)) => s.name(),
            Type::Generic(GenericType::Enum(e)) => e.name(),
            Type::Concrete(c) => c.name(),
            _ => Id::new_str("TypeNamePlaceholder", IdKind::Var),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct ConcreteType {
    pub mapping: BTreeMap<TypeParameter, Type>,
    pub typ: Box<Type>,
}

impl Named for ConcreteType {
    fn name(&self) -> Id {
        self.typ.name()
    }
}

impl ConcreteType {
    /// TODO: actually concretize types once type param is implemented
    pub fn get_concretized_type(&self) -> Type {
        self.typ.as_ref().clone()
    }

    pub fn new_with_empty_mapping(typ: &Type) -> Self {
        Self {
            mapping: BTreeMap::new(),
            typ: Box::new(typ.clone()),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum GenericType {
    Struct(StructType),
    Enum(EnumType),
    Vector(VectorType),
    Tuple(TupleType),
    Function(FunctionType),
    Reference(ReferenceType),
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum Primitive {
    Address,
    Bool,
    Number(NumberType),
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum NumberType {
    U8,
    U16,
    U32,
    U64,
    U128,
    U256,
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct TypeParameter {
    pub name: Id,
    pub abilities: Vec<Ability>,
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct StructType {
    pub name: Id,
    pub type_params: Vec<TypeParameter>,
    pub fields: Vec<(Id, Type)>,
    pub abilities: Vec<Ability>,
    pub positional: bool,
}

impl Named for StructType {
    fn name(&self) -> Id {
        self.name.clone()
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct EnumType {
    pub name: Id,
    pub type_params: Vec<TypeParameter>,
    pub variants: Vec<(Id, EnumVariantType)>,
    pub abilities: Vec<Ability>,
    /// For a type definition or declaration, this should be None to indicate that any variant is possible.
    /// e.g. if the enum type if used in function argument
    /// For an instantiate where the variant is known, the index of the variant should be set.
    pub variant_pos: Option<usize>,
}

impl EnumType {
    pub fn get_possible_variants(&self) -> Vec<(Id, EnumVariantType)> {
        match self.variant_pos {
            Some(idx) => vec![self.variants[idx].clone()],
            None => self.variants.clone(),
        }
    }

    /// Return a SET of all possible fields
    pub fn get_possible_named_fields(&self) -> Vec<(Id, Type)> {
        self.get_possible_variants()
            .iter()
            .flat_map(|(_, variant)| variant.get_all_named_fields())
            .collect::<BTreeSet<(Id, Type)>>()
            .into_iter()
            .collect()
    }

    /// Return a SET of valid fields that exists in all possible variants
    pub fn get_valid_named_fields(&self) -> Vec<(Id, Type)> {
        if self.variant_pos.is_some() {
            return self.get_possible_named_fields();
        }
        let mut counter = BTreeMap::new();
        for (_, variant) in &self.variants {
            for field in &variant.fields {
                let count = counter.entry(field.clone()).or_insert(0);
                *count += 1;
            }
        }

        let total_variants = self.variants.len();
        counter
            .into_iter()
            .filter_map(|(field, count)| {
                if count == total_variants {
                    Some(field)
                } else {
                    None
                }
            })
            .collect()
    }
}

impl Named for EnumType {
    fn name(&self) -> Id {
        if self.variant_pos.is_some() {
            let variant = self.variants[self.variant_pos.unwrap()].0.clone();
            let name = format!("{}::{}", self.name, variant);
            Id::new(name, IdKind::Var)
        } else {
            self.name.clone()
        }
    }
}
#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct EnumVariantType {
    pub name: Id,
    pub fields: Vec<(Id, Type)>,
    pub positional: bool,
}

impl EnumVariantType {
    pub fn get_all_named_fields(&self) -> Vec<(Id, Type)> {
        match self.positional {
            true => vec![],
            false => self.fields.clone(),
        }
    }
}

impl Named for EnumVariantType {
    fn name(&self) -> Id {
        self.name.clone()
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct FunctionType {
    pub name: Id,
    pub type_params: Vec<TypeParameter>,
    pub params: Vec<Type>,
    pub return_type: Box<Type>,
}

impl Named for FunctionType {
    fn name(&self) -> Id {
        self.name.clone()
    }
}

impl FunctionType {
    pub fn has_return(&self) -> bool {
        !self.return_type.is_unit()
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct TupleType {
    pub types: Vec<Type>,
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct VectorType {
    pub ty: Box<Type>,
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum ReferenceType {
    Immutable(Box<Type>),
    Mutable(Box<Type>),
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum Ability {
    Copy,
    Drop,
    Store,
    Key,
}
