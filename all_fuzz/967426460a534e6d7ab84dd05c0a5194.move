
//# publish
module 0xCAFE::MyModule {
    // Inline function f2 returns a tuple (u16, u16) based on input
    public inline fun f2(a: u16): (u16, u16) {
        (a / 2, a - (a / 2))
    }
}


//# publish
module 0xCAFE::TestFeatures {
    // Simple function that adds two u8 values and returns x + y + 1u8
    public fun add_two_values_then_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1u8
    }

    // Function that contains a lambda that multiplies a value by 2 and adds 3
    public fun lambda_test(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |val: u8| {
            val * 2 + 3u8
        };
        f(x)
    }

    // Wrapper function that calls the inline function f2 from MyModule and returns the sum of returned tuple
    public fun call_inline_from_other_module(a: u16): u16 {
        let (v1, v2) = 0xCAFE::MyModule::f2(a);
        v1 + v2
    }

    // Function to demonstrate variable coalescing
    public fun variable_coalescing(mut_input: u8): u8 {
        let mut_accumulator = 0u8;

        // reuse mut_accumulator var later
        let mut_accumulator = mut_accumulator + mut_input;

        let mut_accumulator = mut_accumulator * 2;

        // Return final accumulator
        mut_accumulator
    }

    // Runner function to test all above features combined
    public fun runner(): u8 {
        let val1 = add_two_values_then_increment(5u8, 2u8);
        let val2 = lambda_test(4u8);
        let val3 = call_inline_from_other_module(10u16) as u8;
        let val4 = variable_coalescing(3u8);
        val1 + val2 + val3 + val4
    }
}


//# run 0xCAFE::TestFeatures::add_two_values_then_increment --args 10u8 20u8



//# run 0xCAFE::TestFeatures::lambda_test --args 7u8



//# run 0xCAFE::TestFeatures::call_inline_from_other_module --args 15u16



//# run 0xCAFE::TestFeatures::variable_coalescing --args 8u8



//# run 0xCAFE::TestFeatures::runner
