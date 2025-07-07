
//# publish
module 0xCAFE::AnnotationsAndEmpty {
    use std::vector;

    // test]
    // doc = b"This is a test function with multiple attributes"]
    public fun annotated_fun1(): u8 {
        42u8
    }

    // inline]
    public fun annotated_fun2(): vector<u8> {
        // Create an empty vector with no elements (test empty list between [])
        let empty_vec = vector[];
        empty_vec
    }

    // test]
    // inline]
    // doc = b"Function with empty tuple and empty vector usage"]
    public fun annotated_fun3(): (u8, vector<u8>) {
        // empty tuple is ()
        // empty vector<u8> is vector[]
        let v = vector[];
        (0u8, v)
    }
}


//# run 0xCAFE::AnnotationsAndEmpty::annotated_fun1


//# run 0xCAFE::AnnotationsAndEmpty::annotated_fun2


//# run 0xCAFE::AnnotationsAndEmpty::annotated_fun3


// Featurres:
// a9d2adcb1f17b70532c07980a4451c57: Annotate Move items (modules, functions, etc.) with single or multiple attributes.
// 5f5b25bcf39841044531a49f33dde23d: Reference functions or features from certain modules (e.g., 'vector') and have the compiler automatically maintain the dependency for you
// f0b018110a66295be45449caa5ffcaac: Permit empty item lists between supported delimiters by omitting elements entirely.
