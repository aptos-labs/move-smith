
//# publish
module 0xCAFE::ComplexControlFlow {
    use std::signer;

    public fun nested_loops_and_conditionals(x: u8) {
        let acc = 0u8;

        for (i in 0..x) {
            for (j in 0..x) {
                if ((i + j) % 2 == 0) {
                    acc = acc + 1;
                } else {
                    acc = acc + 2;
                };
            };
        };

        // Trigger an assertion failure with a custom error code if acc is less than 10
        assert!(acc >= 10, 12345);
    }

    // Function demonstrating use of pipe and double pipe for alternative/unions of types
    public fun pipe_type_examples(value: u8 | u16, flag: bool) {
        let _result: u8 || u16;

        if (flag) {
            let v: u8 | u16 = value;
            let _x: u8 || u16 = v;
        } else {
            let _y = value;
        };
    }

    // Function to show usage of a custom error type with token content for precise error reporting
    // We simulate parsing error reporting by taking a byte and asserting with its value included
    public fun show_token_error(token_byte: u8) {
        // Abort with code formed by token_byte * 100 + 1 to show token in error code
        assert!(false, (token_byte as u64 * 100) + 1u64);
    }
}


//# run 0xCAFE::ComplexControlFlow::nested_loops_and_conditionals --args 4u8


//# run 0xCAFE::ComplexControlFlow::pipe_type_examples --args 5u8 true


//# run 0xCAFE::ComplexControlFlow::pipe_type_examples --args 300u16 false


//# run 0xCAFE::ComplexControlFlow::show_token_error --args 42u8


// Featurres:
// 304cb2558967d2171c8ed4ace22b432a: Test that the Move script correctly handles nested loops, conditional statements, and triggers an assertion failure with a custom error code.
// 1d9154d147857f0fb70908dd2b3e30e5: Use pipe '|' and double pipe '||' syntax to specify alternative types or type unions.
// f3b1481edbd9e01504ad8b8972aa64b1: Show the exact token content when a parsing error occurs, enabling precise error reporting
