
//# publish
module 0xCAFE::TestAddition {
    public fun add_u8s_then_return_specific(a: u8, b: u8): u8 {
        let _sum = a + b;
        let expected_return = 42u8;
        // Ignore sum result and return 42
        expected_return
    }

    public fun run_add_test(): u8 {
        add_u8s_then_return_specific(10u8, 20u8)
    }
}



//# run 0xCAFE::TestAddition::run_add_test



//# publish
module 0xCAFE::TestLambda {
    public fun use_lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        lambda(x, y)
    }

    public fun run_lambda(): u8 {
        use_lambda_example(6u8, 7u8)
    }
}



//# run 0xCAFE::TestLambda::run_lambda



//# publish
module 0xCAFE::TestInlineCall {
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::TestInlineCaller {
    public fun call_inline(a: u8, b: u8): u8 {
        0xCAFE::TestInlineCall::inline_add(a, b)
    }
}

pub fun call_inline_from_another_module(): u8 {
    0xCAFE::TestInlineCaller::call_inline(10u8, 15u8)
}


//# run 0xCAFE::TestInlineCaller::call_inline



//# run 0xCAFE::TestInlineCall::inline_add



//# publish
module 0xCAFE::TestBoolLiterals {
    public fun return_true(): bool {
        true
    }

    public fun return_false(): bool {
        false
    }

    public fun run_bool_test(): bool {
        let b1 = return_true();
        let b2 = return_false();
        if (b1) {
            if (!b2) {
                true
            } else {
                false
            }
        } else {
            false
        }
    }
}



//# run 0xCAFE::TestBoolLiterals::run_bool_test
