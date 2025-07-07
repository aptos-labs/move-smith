
//# publish
module 0xCAFE::Annotate {
    use std::vector;

    // inline]
    // inline(always)]
    public fun annotated_function(x: u8): u8 {
        x + 1
    }

    // inline]
    public fun inline_no_arg(): u8 {
        42
    }

    // test_only]
    public fun test_only_function(): u8 {
        annotated_function(10)
    }

    // A function referencing std::vector without explicit import of 'vector' (already imported here)
    public fun vector_function(): vector<u8> {
        (vector[]: vector<u8>)
    }

    // Empty list between delimiters
    public fun empty_vector_list(): vector<u8> {
        (vector[]: vector<u8>)
    }

    public fun lambda_spec_block(): u8 {
        let add_one: |u8| u8 = // spec] |a: u8| a + 1;
        add_one(10)
    }
}


//# run 0xCAFE::Annotate::annotated_function --args 5u8


//# run 0xCAFE::Annotate::inline_no_arg


//# run 0xCAFE::Annotate::test_only_function


//# run 0xCAFE::Annotate::vector_function


//# run 0xCAFE::Annotate::empty_vector_list


//# run 0xCAFE::Annotate::lambda_spec_block


// Featurres:
// a9d2adcb1f17b70532c07980a4451c57: Annotate Move items (modules, functions, etc.) with single or multiple attributes.
// 5f5b25bcf39841044531a49f33dde23d: Reference functions or features from certain modules (e.g., 'vector') and have the compiler automatically maintain the dependency for you
// f0b018110a66295be45449caa5ffcaac: Permit empty item lists between supported delimiters by omitting elements entirely.
// 2611bafe16f9adceb2ab6973cbb59ffe: Attach specification blocks (spec blocks) directly to lambda expressions when using Move version 2.2 or above.
