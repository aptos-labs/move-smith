
//# publish
module 0xCAFE::AttributeAndGenericTest {
    // simple_attribute
    struct SimpleAttrStruct has copy, drop, store {
        value: u8
    }

    // attr_with_value = 42
    struct AttrWithValueStruct has copy, drop, store {
        value: u16
    }

    // attr_with_param(0xdeadbeefu64)
    struct AttrWithParamStruct has copy, drop, store {
        value: u64
    }

    struct GenericStruct<T> has copy, drop, store {
        inner: T
    }

    // generic_fun_attr
    public fun generic_fun<T: copy + drop>(x: T): GenericStruct<T> {
        GenericStruct<T> { inner: x }
    }

    // multi_attr_1
    // multi_attr_2 = 7
    // multi_attr_param("test")
    public fun multiple_attributes_fun(x: u8): u8 {
        x + 1
    }

    // use_signer
    public fun use_signer_in_fun(_s: &signer) {
        // do nothing, just function signature with signer reference
    }
}


//# run 0xCAFE::AttributeAndGenericTest::generic_fun<u8> --args 10u8


//# run 0xCAFE::AttributeAndGenericTest::generic_fun<u16> --args 100u16


//# run 0xCAFE::AttributeAndGenericTest::multiple_attributes_fun --args 5u8


//# run 0xCAFE::AttributeAndGenericTest::use_signer_in_fun --signers 0xBEEF
