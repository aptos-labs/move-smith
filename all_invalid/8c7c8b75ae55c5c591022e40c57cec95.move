
//# publish
module 0xCAFE::TestStringAndLoop {
    use std::vector;

    // Function to calculate the length of a string literal excluding escape characters
    public fun literal_length(s: vector<u8>): u64 {
        let length = 0u64;
        let len = vector::length(&s);
        let i = 0u64;
        while (i < len as u64) {
            let c = *vector::borrow(&s, i as u64);
            if (c == 92u8) { // ASCII for '\'
                if (i + 1 < len as u64) {
                    let next_c = *vector::borrow(&s, i + 1);
                    if ((next_c == 110u8) || (next_c == 116u8) || (next_c == 114u8) || (next_c == 92u8)
                        || (next_c == 34u8) || (next_c == 39u8)) {
                        // escape character, count as one character, skip next
                        length = length + 1;
                        i = i + 2;
                        continue;
                    }
                }
            };
            length = length + 1;
            i = i + 1;
        };
        length
    }

    // Test function for local variable assignment in a loop
    public fun test_loop_assign_param(x: u8): u8 {
        let val = x;
        let i = 0u8;
        while (i < 5u8) {
            let val = val + i;
            i = i + 1;
            // local val is updated every iteration to val+i
            val;
        };
        val
    }

    // This function enforces disallowing function parameters that themselves take function types as parameters
    // This function should only compile and run if language version >= 2.2, otherwise a compile error should occur.
    public fun disallow_fn_arg_of_fn_arg(
        // parameter f: a function that takes a function from u8 to u8 and returns u8
        // (| (u8) -> u8 |) -> u8 is disallowed if language version < 2.2
        // We attempt to define such a type to test compiler rejection or acceptance
        f: |(|u8|u8)|u8,
        x: u8
    ): u8 {
        f(|y: u8| { y + x })
    }

    // Runner for disallow_fn_arg_of_fn_arg: uses simple lambda to avoid needing complex arguments
    public fun runner_disallow() {
        let lambda: |(|u8|u8)|u8 = |g: |u8|u8| {
            g(5u8) + 1u8
        };
        let _ = disallow_fn_arg_of_fn_arg(lambda, 10u8);
    }
}


//# run 0xCAFE::TestStringAndLoop::literal_length --args x"48656c6c6f5c6e576f726c64"  # "Hello\nWorld", length excluding '\n' escape counted as one char 


//# run 0xCAFE::TestStringAndLoop::test_loop_assign_param --args 2u8


//# run 0xCAFE::TestStringAndLoop::runner_disallow


// Featurres:
// 0cd736f620b0c78ec962304f1ef2d84e: Use this function to determine the length of a string literal excluding escape characters.
// 2a6995db2f3ff1669cc090ddf8f5ea9c: Test that assigning a parameter to a local variable inside a loop updates the variable correctly and that the final value reflects the last assignment.
// f20a42ba428c3246ab635cc65010987f: Disallow parameters that are themselves function types where the function arguments are function-typed, unless the language version is at least 2.2.
