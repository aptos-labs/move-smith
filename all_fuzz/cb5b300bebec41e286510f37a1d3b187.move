
//# publish
module 0xCAFE::CalcModule {
    // Module to test addition and inline function returning tuples
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            sum
        };
    }

    public fun make_lambda_and_call(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::UseInlineModule {
    use 0xCAFE::CalcModule;

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let s = CalcModule::inline_add(x, y);
        CalcModule::add_and_return_special(s, 1u8)
    }
}


//# publish
module 0xCAFE::LoopTestModule {
    // Tests nonterminating loops with nested breaks and failing assertion
    public fun complicated_loop(x: u8) {
        let val = x;
        loop {
            val = val + 1u8;
            loop {
                if (val % 3u8 == 0u8) {
                    break;
                };
                break;
            };
            if (val > 50u8) {
                break;
            };
        };

        // This will fail if val is not > 100
        assert!(val > 100u8, 777);
    }
}


//# run 0xCAFE::CalcModule::add_and_return_special --args 4u8 3u8


//# run 0xCAFE::CalcModule::make_lambda_and_call --args 5u8 6u8


//# run 0xCAFE::UseInlineModule::call_inline_and_add --args 4u8 3u8


//# run 0xCAFE::LoopTestModule::complicated_loop --args 48u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// b6660307806f58facbbe3ec37467f8e5: Test that nonterminating loops with assignment and nested breaks, followed by an if statement and a failing assert, execute as expected without causing unintended termination.
