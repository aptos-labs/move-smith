
//# publish
module 0xCAFE::AddTest {
    /// Simple function to add two u8 and then return a constant u8 value
    public fun add_then_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        sum; // intentionally not returning sum, just computing it
        42u8
    }

    /// Function using lambda to add two u8 and multiply result by 2
    public fun lambda_compute(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        let mul2: |u8| u8 has copy+drop = |x: u8| { x * 2u8 };

        let sum = adder(a, b);
        let doubled = mul2(sum);
        doubled
    }

    /// Runner function to call add_then_constant and lambda_compute internally
    public fun runner(): u8 {
        let r1 = add_then_constant(10u8, 32u8);
        let r2 = lambda_compute(3u8, 4u8);
        r1 + r2 // returns 42 + 14 = 56
    }
}



//# run 0xCAFE::AddTest::add_then_constant --args 20u8 22u8



//# run 0xCAFE::AddTest::lambda_compute --args 2u8 3u8



//# run 0xCAFE::AddTest::runner



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddTest;

    // This function calls an inline function indirectly through AddTest's functions
    public fun call_add_and_lambda(): u8 {
        let r1 = AddTest::add_then_constant(11u8, 1u8);
        let r2 = AddTest::lambda_compute(4u8, 1u8);
        r1 + r2 + 1u8 // 42 + 10 + 1 = 53
    }
}
