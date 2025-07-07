
//# publish
module 0xCAFE::FeatureTest {
    // Function to add two u8 values and return a fixed u8 value 42
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignored = sum;
        42u8
    }

    // Function containing lambda expressions and calling them
    public fun lambda_test(): (u8, u8) {
        let lambda_add_mul: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let mul = x * y;
            (sum, mul)
        };
        lambda_add_mul(6u8, 7u8)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::FeatureTest;

    // Remove 'inline' to allow cross-module calls to the function
    public fun nested_call(x: u8, y: u8): u8 {
        let val1 = FeatureTest::add_then_return_fixed(x, y);
        let val2 = FeatureTest::add_then_return_fixed(y, x);
        val1 + val2
    }
}



//# run 0xCAFE::FeatureTest::add_then_return_fixed --args 10u8 20u8


//# run 0xCAFE::FeatureTest::lambda_test


//# run 0xCAFE::CallerModule::nested_call --args 1u8 2u8
