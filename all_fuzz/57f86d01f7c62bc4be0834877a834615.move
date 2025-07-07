// Remove the '#' from publish directives to allow compilation

// publish
//# publish
module 0xCAFE::LambdaTest {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value (sum + 1)
        sum + 1
    }

    public fun call_lambda(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| {
            a * 2u8
        };
        f(x)
    }

    public fun call_nested_lambda(x: u8): u8 {
        let f1: |u8|u8 has copy+drop = |a: u8| {
            let f2: |u8|u8 has copy+drop = |b: u8| {
                a + b
            };
            f2(a)
        };
        f1(x)
    }
}

// publish
//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun call_add_two_u8(a: u8, b: u8): u8 {
        LambdaTest::add_two_u8(a, b)
    }

    public fun call_call_lambda(x: u8): u8 {
        LambdaTest::call_lambda(x)
    }

    public fun call_call_nested_lambda(x: u8): u8 {
        LambdaTest::call_nested_lambda(x)
    }
}

// run 0xCAFE::LambdaTest::add_two_u8 --args 5u8 7u8

// run 0xCAFE::LambdaTest::call_lambda --args 10u8

// run 0xCAFE::LambdaTest::call_nested_lambda --args 8u8

// run 0xCAFE::InlineCaller::call_add_two_u8 --args 2u8 3u8

// run 0xCAFE::InlineCaller::call_call_lambda --args 11u8

// run 0xCAFE::InlineCaller::call_call_nested_lambda --args 4u8
