
//# publish
module 0xCAFE::LambdaTest {
    // Removed unused import: vector

    public fun add_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
        // Removed semicolon here to return the value correctly
    }

    public fun lambda_with_capture(): u8 {
        let captured = 5u8;
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            x + captured
        };
        lambda(10u8)
    }

    public fun lambda_with_multiple_params(): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        lambda(3u8, 7u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add(a: u8, b: u8): u8 {
        inline_add(a, b)
    }
}



//# run 0xCAFE::LambdaTest::add_u8_values --args 40u8 50u8



//# run 0xCAFE::LambdaTest::lambda_with_capture



//# run 0xCAFE::LambdaTest::lambda_with_multiple_params



//# run 0xCAFE::LambdaTest::call_inline_add --args 15u8 30u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public fun call_nested_inline(a: u8, b: u8): u8 {
        let intermediate = LambdaTest::call_inline_add(a, b);
        LambdaTest::inline_add(intermediate, 10u8)
    }
}



//# run 0xCAFE::InlineCaller::call_nested_inline --args 20u8 25u8

// Top-level spec block testing concepts
spec module 0xCAFE::LambdaTest {
    fun add_contract(a: u8, b: u8) {
        let result = add_u8_values(a, b);
        // no assertions required, just testing compile & run
    }

    fun lambda_contract() {
        let res = lambda_with_capture();
        let (sum, product) = lambda_with_multiple_params();
    }
}

spec module 0xCAFE::InlineCaller {
    fun nested_inline_contract(a: u8, b: u8) {
        let res = call_nested_inline(a, b);
    }
}
