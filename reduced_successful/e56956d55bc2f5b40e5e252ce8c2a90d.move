
//# publish
module 0xCAFE::TestAdd {
    public fun add_two_numbers(a: u8, b: u8): u8 {
        let c = a + b;
        if (c > 10) {
            42u8
        } else {
            24u8
        }
    }
}




//# run 0xCAFE::TestAdd::add_two_numbers --args 3u8 5u8




//# publish
module 0xCAFE::TestLambda {
    public fun test_lambda_expression(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        lambda(x, y)
    }

    public fun test_lambda_no_args(): u8 {
        let const_val = 10;
        // Remove the empty tuple `()` param, use `| |` with no argument, and omit the argument type
        // Also type annotation without empty tuple parameter syntax which is invalid in Move
        let lambda: ||u8 has copy+drop = || {
            const_val + 5
        };
        lambda()
    }
}




//# run 0xCAFE::TestLambda::test_lambda_expression --args 3u8 7u8




//# run 0xCAFE::TestLambda::test_lambda_no_args




//# publish
module 0xCAFE::TestInlineCall {
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}




//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::TestInlineCall;

    public fun call_inline(a: u8, b: u8): u8 {
        TestInlineCall::inline_add(a, b)
    }
}




//# run 0xCAFE::NestedInlineCaller::call_inline --args 9u8 11u8




//# publish
module 0xCAFE::TestInlineFunctionPointer {
    public fun foo(f: |u8,u8|u8, a: u8, b: u8): u8 {
        let x = f(a, b);
        x + 1
    }

    public fun example_f(): u8 {
        foo(|a: u8, b: u8| a + b, 4u8, 5u8)
    }
}




//# run 0xCAFE::TestInlineFunctionPointer::example_f




//# publish
module 0xCAFE::TestReturnInsideLoop {
    public fun nested_loop_with_return(n: u8): u8 {
        let i = 0u8;
        while (i < n) {
            let j = 0u8;
            while (j < n) {
                if (i + j == n) {
                    return i;
                };
                j = j + 1;
            };
            i = i + 1;
        };
        n
    }
}




//# run 0xCAFE::TestReturnInsideLoop::nested_loop_with_return --args 5u8




//# publish
module 0xCAFE::TestAssignExpressions {
    public fun assign_values(): u8 {
        let x = 5u8;
        let y = 10u8;
        y = y + x;
        if (y > 10) {
            y = y - 1;
        };
        y
    }
}




//# run 0xCAFE::TestAssignExpressions::assign_values
