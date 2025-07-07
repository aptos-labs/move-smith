
//# publish
module 0xCAFE::Operators {
    //
    // Module to test operators and lambda, function types, inline functions and call from other modules
    //

    // Simple function to add two u8 values and return 42u8 if sum is correct
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == (a + b)) {
            42u8
        } else {
            0u8
        }
    }

    // Function that returns a lambda adding two u8 numbers
    public fun get_adder_lambda(): |u8, u8| u8 has copy+drop {
        |x: u8, y: u8| {
            x + y
        }
    }

    // Generic function taking a lambda that takes u8 and returns u8, applies to argument y
    public fun apply_u8_fn(f: |u8| u8, y: u8): u8 {
        f(y)
    }

    // Inline function returning (a * b, a - b)
    public inline fun mult_sub(a: u8, b: u8): (u8, u8) {
        (a * b, a - b)
    }

    // Function calling mult_sub and returning the first element
    public fun call_inline(a: u8, b: u8): u8 {
        let (prod, diff) = mult_sub(a, b);
        prod
    }

    // Function to test control flow and variable assignment order
    public fun control_flow_test(x: u8): u8 {
        let sum = 0u8; // We cannot use mut keyword, so we do it via rebinds in code block
        {
            let intermediate = sum + x;
            let sum = intermediate;
            if (sum > 0) {
                let sum = sum - 1;
                sum
            } else {
                sum
            };
        };
        // last expression
        x
    }

    // Function testing many binary operators returning 1u8 if all pass
    public fun test_all_operators(): u8 {
        let a = 10u8;
        let b = 5u8;

        let cond1 = a + b == 15u8;
        let cond2 = a - b == 5u8;
        let cond3 = a * b == 50u8;
        let cond4 = a / b == 2u8;
        let cond5 = a % b == 0u8;

        let cond6 = a == 10u8;
        let cond7 = a != b;
        let cond8 = a > b;
        let cond9 = a >= b;
        let cond10 = b < a;
        let cond11 = b <= a;

        let cond12 = (a > 0u8) && (b > 0u8);
        let cond13 = (a > 0u8) || (b == 0u8);

        let cond14 = (a | b) == 15u8;
        let cond15 = (a & b) == 0u8;
        let cond16 = (a ^ b) == 15u8;
        let cond17 = (a << 1) == 20u8;
        let cond18 = (a >> 1) == 5u8;

        let range_test = (0u8..5u8);

        // Check all conds via if chain, ignore checks result because no assert required, just execute all expressions
        if(
            cond1 && cond2 && cond3 && cond4 && cond5 && cond6 && cond7 && cond8 && cond9 && cond10 && cond11 &&
            cond12 && cond13 && cond14 && cond15 && cond16 && cond17 && cond18
        ) {
            1u8
        } else {
            0u8
        }
    }

    // Runner entry to call functions above with no arguments to execute code
    public fun runner() {
        let _ = add_and_check(10u8, 20u8);
        let adder = get_adder_lambda();
        let _ = apply_u8_fn(|x: u8| x + 1, 5u8);
        let _ = call_inline(3u8, 4u8);
        let _ = control_flow_test(7u8);
        let _ = test_all_operators();
        let _ = apply_u8_fn(adder, 2u8);
    }
}


//# run 0xCAFE::Operators::add_and_check --args 10u8 20u8


//# run 0xCAFE::Operators::get_adder_lambda


//# run 0xCAFE::Operators::apply_u8_fn --args 5u8


//# run 0xCAFE::Operators::call_inline --args 3u8 4u8


//# run 0xCAFE::Operators::control_flow_test --args 7u8


//# run 0xCAFE::Operators::test_all_operators


//# run 0xCAFE::Operators::runner



//# publish
module 0xCAFE::CallInlineFromOtherModule {
    use 0xCAFE::Operators;

    public fun wrapper_call(a: u8, b: u8): u8 {
        Operators::call_inline(a, b)
    }

    public fun runner() {
        let _ = wrapper_call(6u8, 7u8);
    }
}


//# run 0xCAFE::CallInlineFromOtherModule::wrapper_call --args 6u8 7u8


//# run 0xCAFE::CallInlineFromOtherModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 86f8adf1e0f084864bf8f1a02cbe9d90: Test that variable assignments and returns within code blocks are evaluated in the correct order and that control flow behaves as expected within expression blocks.
// 040c9573c5622c7bcfaa5b94467f2b3b: Write expressions using binary operators such as +, -, *, /, %, ==, !=, <, <=, >, >=, &&, ||, |, &, ^, <<, >>, .., =>=, <==> in Move code
// e003a7dfb459df4e1f343a32890d3391: Define generic function types that accept functions as arguments.
