
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_flag(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            1u8
        } else {
            0u8
        }
    }
}



//# run 0xCAFE::TestAdd::add_and_return_flag --args 4u8 7u8



//# publish
module 0xCAFE::TestLambda {
    // Remove the argument tuple () in function type because tuple types are not supported.
    // Use zero-argument closure syntax directly without `|()|`.
    public fun run_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun run_no_arg_lambda(): u8 {
        let lambda: ||u8 has copy+drop = || {
            42u8
        };
        lambda()
    }
}



//# run 0xCAFE::TestLambda::run_lambda --args 5u8 6u8



//# run 0xCAFE::TestLambda::run_no_arg_lambda



//# publish
module 0xCAFE::InlineCaller {
    // Import TestLambda module (compile order must publish TestLambda first)
    use 0xCAFE::TestLambda;

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let inline_result = inline_adder(a, b);
        let lambda_result = TestLambda::run_lambda(a, b);
        inline_result + lambda_result
    }
}



//# run 0xCAFE::InlineCaller::call_inline_and_lambda --args 10u8 20u8



//# publish
module 0xCAFE::AbortTest {
    public fun abort_if_over_100(x: u64) {
        if (x > 100) {
            abort(777u64);
        };
        // complete without abort
    }
}



//# run 0xCAFE::AbortTest::abort_if_over_100 --args 50u64



//# run 0xCAFE::AbortTest::abort_if_over_100 --args 150u64



//# publish
module 0xCAFE::ComplexTypes {
    // We cannot use (u8, u8) tuple as a struct field type.
    // Instead, define a struct Pair to mimic the tuple.

    struct Pair has copy, drop {
        first: u8,
        second: u8,
    }

    struct Nested<T> has copy, drop {
        field1: T,
        field2: Pair,
        func: |T, u8| (u8, u8) has copy+drop,
    }

    public fun create_and_use_nested(x: u8): (u8, u8) {
        let f: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        let n = Nested<u8> {
            field1: x,
            field2: Pair { first: x, second: x + 1 },
            func: copy f,
        };
        let (sum, product) = (n.func)(n.field1, n.field2.second);
        (sum, product)
    }
}



//# run 0xCAFE::ComplexTypes::create_and_use_nested --args 7u8
