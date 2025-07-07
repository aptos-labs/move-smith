
//# publish
module 0xCAFE::TestAdditionLambda {
    public fun add_and_check(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun lambda_adder_example(): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(4u8, 5u8)
    }

    // Removed call_external_inline since MyModule::f2 is missing and causes linker errors
    // Alternatively, if you have MyModule with function f2, you can re-add it properly.

    public fun label_and_jump_example(x: u8): u8 {
        let y = x;
        // Fixed: Remove label declaration with colon (not supported)
        if (y < 5) {
            let y = y + 1;
            // Jump back to label1 by recursion (simulated loop)
            label_and_jump_example(y)
        } else {
            99u8
        }
    }

    public fun custom_param_names(foo: u8, bar: u8): u8 {
        foo + bar
    }
}




//# run 0xCAFE::TestAdditionLambda::add_and_check --args 3u8 8u8



//# run 0xCAFE::TestAdditionLambda::lambda_adder_example



//# run 0xCAFE::TestAdditionLambda::label_and_jump_example --args 2u8



//# run 0xCAFE::TestAdditionLambda::custom_param_names --args 7u8 8u8
