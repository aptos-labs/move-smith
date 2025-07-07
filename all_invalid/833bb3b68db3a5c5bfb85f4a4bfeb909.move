
//# publish
module 0xCAFE::AttributeAndGenericTest {
    use std::signer;

    // simple_attribute]
    struct SimpleAttrStruct has copy, drop, store {
        value: u8
    }

    // attr_with_value = 42]
    struct AttrWithValueStruct has copy, drop, store {
        value: u16
    }

    // attr_with_param(0xdeadbeefu64)]
    struct AttrWithParamStruct has copy, drop, store {
        value: u64
    }

    struct GenericStruct<T> has copy, drop, store {
        inner: T
    }

    // generic_fun_attr]
    public fun generic_fun<T: copy + drop>(x: T): GenericStruct<T> {
        GenericStruct<T> { inner: x }
    }

    // multi_attr_1]
    // multi_attr_2 = 7]
    // multi_attr_param("test")]
    public fun multiple_attributes_fun(x: u8): u8 {
        x + 1
    }

    // use_signer]
    public fun use_signer_in_fun(_s: signer) {
        // do nothing, just function signature with signer
    }
}


//# run 0xCAFE::AttributeAndGenericTest::generic_fun --args 10u8


//# run 0xCAFE::AttributeAndGenericTest::generic_fun --args 100u16


//# run 0xCAFE::AttributeAndGenericTest::multiple_attributes_fun --args 5u8


//# run 0xCAFE::AttributeAndGenericTest::use_signer_in_fun --signers 0xBEEF


// Featurres:
// ec98e8fb2e3a8df7e3abef3cc08a29d9: Always begin function definitions with the 'fun' keyword, ensuring signatures are properly formed.
// 921782d4b904c7c34a30e20dbad369a5: Write attributes as either simple names, assigned values, or with parameters (e.g., #[my_attr], #[my_attr = value], #[my_attr(param)]).
// 01b4f574d69d308443d5edb67f5ee6d1: Declare generic type parameters for structs and functions
