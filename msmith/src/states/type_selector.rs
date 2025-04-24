use crate::states::{GenerationConfig, NumberType, Primitive, Type};

#[derive(Debug, Clone)]
pub struct TypeSelector {
    pub config: GenerationConfig,
    pub unit_weight: u32,
    pub bool_weight: u32,
    pub number_weight: u32,
    pub address_weight: u32,
    pub struct_weight: u32,
    pub enum_weight: u32,
    pub vector_weight: u32,
    pub tuple_weight: u32,
    pub reference_weight: u32,
    pub mut_reference_weight: u32,
    pub func_return: u32,
    pub defined_func_type: u32,
    pub new_func_type: u32,
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
            && self.defined_func_type == 0
            && self.new_func_type == 0
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
            && self.defined_func_type > 0
            && self.new_func_type > 0
    }

    pub fn number_type_selection_weights() -> Vec<(Type, u32)> {
        vec![
            (Type::Primitive(Primitive::Number(NumberType::U8)), 30),
            (Type::Primitive(Primitive::Number(NumberType::U16)), 30),
            (Type::Primitive(Primitive::Number(NumberType::U32)), 30),
            (Type::Primitive(Primitive::Number(NumberType::U64)), 10),
            (Type::Primitive(Primitive::Number(NumberType::U128)), 1),
            (Type::Primitive(Primitive::Number(NumberType::U256)), 1),
        ]
    }

    pub fn function_selectors(num_params: usize) -> (Vec<Self>, Self) {
        let ret_selector = TypeSelectorBuilder::all_no(&GenerationConfig::default())
            .unit(1)
            .bool(1)
            .number(1)
            .structs(1)
            .enums(1)
            .tuple(1)
            .func_return(1)
            .defined_func_type(1)
            .new_func_type(1)
            .build();
        let params = (0..num_params)
            .map(|_| {
                TypeSelectorBuilder::all_no(&GenerationConfig::default())
                    .bool(1)
                    .number(1)
                    .structs(1)
                    .enums(1)
                    .func_return(1)
                    .defined_func_type(1)
                    .new_func_type(1)
                    .build()
            })
            .collect();
        (params, ret_selector)
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
                defined_func_type: 1,
                new_func_type: 1,
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
                defined_func_type: 0,
                new_func_type: 0,
            },
        }
    }

    pub fn primitive_only(config: &GenerationConfig) -> Self {
        TypeSelectorBuilder::all_no(config).bool(1).number(1)
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

    pub fn defined_func_type(mut self, weight: u32) -> Self {
        self.selector.defined_func_type = weight;
        self
    }

    pub fn new_func_type(mut self, weight: u32) -> Self {
        self.selector.new_func_type = weight;
        self
    }

    pub fn build(self) -> TypeSelector {
        self.selector
    }
}
