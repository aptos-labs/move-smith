
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        // Example implementation: return (x, x + 1)
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8_and_return_specific_value(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y + 1
        };
        lambda(3u8, 4u8)
    }

    public fun call_external_inline(x: u16): u32 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        // sum cast to u32 and return
        (a as u32) + (b as u32)
    }

    public fun assign_multiple_vars_with_range(): (u8, u8, u8, u8, u8) {
        let (a, b, c, d, e) = (0u8, 1u8, 2u8, 3u8, 4u8);
        // Assign e using range list (simulate multiple assignment)
        let (f, g, h, i, j) = (5u8, 6u8, 7u8, 8u8, 9u8);
        (a, b, c, d, j) // return mix of first and last assigned
    }
}



//# run 0xCAFE::LambdaTest::add_u8_and_return_specific_value --args 5u8 7u8



//# run 0xCAFE::LambdaTest::add_u8_and_return_specific_value --args 1u8 2u8



//# run 0xCAFE::LambdaTest::run_lambda_example



//# run 0xCAFE::LambdaTest::call_external_inline --args 10u16



//# run 0xCAFE::LambdaTest::assign_multiple_vars_with_range
