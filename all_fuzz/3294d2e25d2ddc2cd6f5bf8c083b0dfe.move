
//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8_values(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
        // The last expression is returned automatically
    }

    public fun apply_lambda(x: u8, y: u8): (u8, u8) {
        let lam: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let prod = a * b;
            (sum, prod)
        };
        lam(x, y)
    }
}



//# run 0xCAFE::LambdaTest::add_u8_values --args 20u8 30u8



//# run 0xCAFE::LambdaTest::apply_lambda --args 5u8 7u8



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaTest;

    // Inline function in this module calling normal public function from another module
    public fun nested_inline_add(a: u8, b: u8): u8 {
        let (sum, _prod) = LambdaTest::apply_lambda(a, b);
        sum
    }

    // Wrapper function to run without args
    public fun runner(): u8 {
        nested_inline_add(3u8, 4u8)
    }
}



//# run 0xCAFE::NestedCalls::nested_inline_add --args 1u8 2u8



//# run 0xCAFE::NestedCalls::runner
