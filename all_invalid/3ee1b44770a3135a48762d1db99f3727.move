
//# publish
module 0xCAFE::ComplexControlFlow {
    use std::signer;

    public fun nested_loops_and_conditionals(x: u8) {
        let acc = 0u8;

        let i = 0u8;
        while (i < x) {
            let j = 0u8;
            while (j < x) {
                if ((i + j) % 2 == 0) {
                    acc = acc + 1;
                } else {
                    acc = acc + 2;
                };
                j = j + 1;
            };
            i = i + 1;
        };

        // Trigger an assertion failure with a custom error code if acc is less than 10
        assert!(acc >= 10, 12345);
    }

    // Pipe wrappers like `u8 | u16` or `u8 || u16` are not valid in Move.
    // Instead, use a common denominator type or two separate functions or enums, or overloading
    // Since Move does not support union types, we simply overload or restrict to u64
    public fun pipe_type_examples_u8(value: u8, flag: bool) {
        let _result: u8;

        if (flag) {
            let v: u8 = value;
            let _x: u8 = v;
        } else {
            let _y = value;
        };
    }

    public fun pipe_type_examples_u16(value: u16, flag: bool) {
        let _result: u16;

        if (flag) {
            let v: u16 = value;
            let _x: u16 = v;
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



//# run 0xCAFE::ComplexControlFlow::pipe_type_examples_u8 --args 5u8 true



//# run 0xCAFE::ComplexControlFlow::pipe_type_examples_u16 --args 300u16 false



//# run 0xCAFE::ComplexControlFlow::show_token_error --args 42u8
