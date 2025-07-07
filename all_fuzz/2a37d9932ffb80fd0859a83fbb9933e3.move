
//# publish
module 0xCAFE::NestedCalls {
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }
    
    public fun call_add_and_double(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        sum * 2
    }
}



//# publish
module 0xCAFE::LambdaTest {
    public fun apply_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        lambda(a, b)
    }
    
    public fun use_lambda_as_argument(a: u8): u8 {
        let doubled = (|x: u8| {
            x * 2
        })(a);
        doubled
    }
}



//# publish
module 0xCAFE::MainTest {
    use 0xCAFE::NestedCalls;
    use 0xCAFE::LambdaTest;

    public fun test_addition(): u8 {
        let res = NestedCalls::add_u8(5u8, 10u8);
        if (res == 15) {
            42
        } else {
            1
        }
    }

    public fun test_lambda(): u8 {
        let (sum, product) = LambdaTest::apply_lambda(3u8, 4u8);
        if (sum == 7 && product == 12) {
            LambdaTest::use_lambda_as_argument(5u8)
        } else {
            0
        }
    }

    public fun test_nested_calls(): u8 {
        NestedCalls::call_add_and_double(6u8, 7u8)
    }
}



//# run 0xCAFE::MainTest::test_addition



//# run 0xCAFE::MainTest::test_lambda



//# run 0xCAFE::MainTest::test_nested_calls
