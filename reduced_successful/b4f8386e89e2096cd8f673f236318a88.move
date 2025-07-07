
//# publish
module 0xCAFE::AttributeTest {
    use std::vector;

    // test_attr]
    // another_attr(123)]
    public fun annotated_func(x: u8): vector<u8> {
        let v = vector::empty<u8>();
        vector::push_back(&mut (*( &v )), x);
        v
    }

    // only_attr]
    public struct StructWithAttr has copy, drop, store {
        a: u8,
    }

    // multi_attr]
    // multi_attr_2]
    public fun annotated_func2() {
        // empty function body
    }

    // attr_on_enum]
    public enum E has copy, drop {
        // variant_attr]
        VEmpty,

        // variant_attr_with_arg(456)]
        VWithValue(u8),

        VNoAttr,
    }

    // attr_on_module_func]
    public fun empty_vector_return(): vector<u8> {
        vector::empty<u8>()
    }

    // attr_with_empty_param()]
    public fun func_with_empty_param(): u8 {
        42u8
    }
}


//# run 0xCAFE::AttributeTest::annotated_func --args 7u8


//# run 0xCAFE::AttributeTest::annotated_func2


//# run 0xCAFE::AttributeTest::empty_vector_return


//# run 0xCAFE::AttributeTest::func_with_empty_param


// Featurres:
// a9d2adcb1f17b70532c07980a4451c57: Annotate Move items (modules, functions, etc.) with single or multiple attributes.
// 5f5b25bcf39841044531a49f33dde23d: Reference functions or features from certain modules (e.g., 'vector') and have the compiler automatically maintain the dependency for you
// f0b018110a66295be45449caa5ffcaac: Permit empty item lists between supported delimiters by omitting elements entirely.
