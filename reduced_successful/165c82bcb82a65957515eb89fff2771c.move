
//# publish
module 0xCAFE::Addition {
    // Test addition of two u8 values and return a specific value
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return the sum plus 10 as a test return value
        sum + 10
    }

    // Test inline lambda expressions
    public fun lambda_test(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(5u8, 7u8)
    }

    // Inline function to be called by another module
    public inline fun inline_sum(a: u8, b: u8): u8 {
        a + b
    }

    // Test implicit fall-through using labels - in Move this can be simulated by breaking from nested blocks
    public fun implicit_fallthrough(x: u8): u8 {
        let result = {
            if (x == 0) {
                0
            } else {
                let y = x + 5;
                y
            }
        };
        result
    }

    // Dummy function just to produce disassembled bytecode for debugging (executable as normal function)
    public fun produce_disassembly() {
        let x = 10u8;
        let y = 20u8;
        let z = x + y;
        {
            if (z > 20) {
                // no-op break in Move isn't supported, just empty block
            };
        };
    }

    // Inline lambda applying argument and returning result
    public fun apply_inline_lambda(x: u8): u8 {
        let inline_lambda: |u8| u8 has copy+drop = |a: u8| { a * 2 };
        inline_lambda(x)
    }
}



//# run 0xCAFE::Addition::add_and_return --args 4u8 6u8



//# run 0xCAFE::Addition::lambda_test



//# run 0xCAFE::Addition::implicit_fallthrough --args 3u8



//# run 0xCAFE::Addition::implicit_fallthrough --args 0u8



//# run 0xCAFE::Addition::produce_disassembly



//# run 0xCAFE::Addition::apply_inline_lambda --args 7u8



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Addition;

    public fun call_inline_sum(a: u8, b: u8): u8 {
        Addition::inline_sum(a, b)
    }

    public fun call_lambda_test(): u8 {
        Addition::lambda_test()
    }

    public fun call_apply_inline_lambda(x: u8): u8 {
        Addition::apply_inline_lambda(x)
    }
}



//# run 0xCAFE::Caller::call_inline_sum --args 15u8 25u8



//# run 0xCAFE::Caller::call_lambda_test



//# run 0xCAFE::Caller::call_apply_inline_lambda --args 8u8
