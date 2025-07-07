
//# publish
module 0xCAFE::AdditionModule {
    // Test adding two u8 values plus a constant using a lambda.

    public fun add_two_u8_plus_constant(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = add_lambda(a, b);
        if (sum > 10) {
            sum + 5
        } else {
            sum
        }
    }

    public fun with_lambda_expression(x: u8): u8 {
        let double_lambda: |u8| u8 has copy+drop = |n: u8| {
            n * 2
        };
        double_lambda(x) + 1
    }

    // Inline function returning a tuple of (u16, u16)
    public inline fun inline_fn(u: u16): (u16, u16) {
        (u + 100, u + 200)
    }
}



//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::AdditionModule;

    // Call inline function from AdditionModule and sum the tuple results
    public fun call_nested_inline_fun(x: u16): u16 {
        let (a, b) = AdditionModule::inline_fn(x);
        let total = a + b;
        total
    }
}



//# publish
module 0xCAFE::ComplexPatternModule {
    // Struct with nested structs
    struct Inner has copy, drop, store {
        a: u8,
        b: u8
    }

    struct Outer has copy, drop, store {
        i: Inner,
        c: u8
    }

    public fun pattern_match(o: Outer): u8 {
        let Outer { i: Inner { a, b }, c } = o;
        if (a > b) {
            a + c
        } else {
            b + c
        }
    }

    // Wrapper test functions to construct examples without CLI args
    public fun pattern_match_example1(): u8 {
        let o = Outer {
            i: Inner { a: 3u8, b: 2u8 },
            c: 4u8
        };
        pattern_match(o)
    }

    public fun pattern_match_example2(): u8 {
        let o = Outer {
            i: Inner { a: 1u8, b: 6u8 },
            c: 7u8
        };
        pattern_match(o)
    }
}



//# publish
module 0xCAFE::ControlFlowExpressions {
    public fun control_flow_expr(x: u8): u8 {
        let sum = 0u8;

        if (x % 2u8 == 0u8) {
            sum = x + 10;
        } else {
            sum = x + 5;
        };

        let counter = 0u8;
        while (counter < 3u8) {
            sum = sum + counter;
            counter = counter + 1;
        };

        loop {
            if (sum > 20) {
                break;
            };
            sum = sum + 1;
        };

        sum
    }
}



//# run 0xCAFE::AdditionModule::add_two_u8_plus_constant --args 5u8 7u8



//# run 0xCAFE::AdditionModule::with_lambda_expression --args 6u8



//# run 0xCAFE::NestedInlineCaller::call_nested_inline_fun --args 100u16



//# run 0xCAFE::ComplexPatternModule::pattern_match_example1



//# run 0xCAFE::ComplexPatternModule::pattern_match_example2



//# run 0xCAFE::ControlFlowExpressions::control_flow_expr --args 2u8



//# run 0xCAFE::ControlFlowExpressions::control_flow_expr --args 3u8
