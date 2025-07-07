
//# publish
module 0xCAFE::MyModule {
    /// Returns a tuple of two u16 values derived from input a.
    public fun f2(a: u16): (u16, u16) {
        // Example implementation, just return (a, a + 1)
        (a, a + 1)
    }
}


//# publish
module 0xCAFE::Arithmetic {
    /// Adds two u8 values and returns the sum plus a fixed offset (5).
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    /// Executes a lambda function that multiplies its input by 3u8.
    public fun lambda_mult_3(x: u8): u8 {
        let triple: |u8|u8 has copy+drop = |v: u8| {
            v * 3
        };
        triple(x)
    }

    /// Calls the inline function from 0xCAFE::MyModule to get tuple, returns the sum.
    public fun call_inline_and_sum(a: u16): u16 {
        let (v1, v2) = 0xCAFE::MyModule::f2(a);
        v1 + v2
    }

    /// Returns true if the given u8 is equal to 42.
    public fun is_identifier_expected(id: u8): bool {
        id == 42
    }
}



//# run 0xCAFE::Arithmetic::add_with_offset --args 10u8 20u8



//# run 0xCAFE::Arithmetic::lambda_mult_3 --args 7u8



//# run 0xCAFE::Arithmetic::call_inline_and_sum --args 15u16



//# run 0xCAFE::Arithmetic::is_identifier_expected --args 42u8



//# publish
module 0xCAFE::LanguageFeatureV2 {
    // Language version feature test: requires at least version 2.
    // Test use of conditional expressions and loops which are stable in v2.

    /// Verifies sum 0..n using loop, returns sum.
    public fun sum_up_to(n: u8): u8 {
        let sum = 0u8;
        let i = 0u8;
        while (i <= n) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }
}



//# run 0xCAFE::LanguageFeatureV2::sum_up_to --args 10u8
