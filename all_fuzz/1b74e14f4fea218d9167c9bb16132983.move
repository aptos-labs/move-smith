
//# publish
module 0xCAFE::Compute {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            return 42;
        };
        0
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Compute;

    public fun call_inline_add(x: u8, y: u8): u8 {
        Compute::inline_add(x, y)
    }

    public fun runner() {
        let _ = Compute::add_and_return(4u8, 8u8);
        let _ = with_lambda(3u8, 7u8);
        let _ = call_inline_add(5u8, 6u8);
    }
}


//# publish
module 0xCAFE::EarlyReturn {
    public fun test_early_return(x: u8): u8 {
        if (x > 0) {
            return 1;
        };
        assert!(false, 999);
        0
    }
}


//# run
script {
    use 0xCAFE::Compute;
    use 0xCAFE::NestedCall;
    use 0xCAFE::EarlyReturn;

    fun main() {
        let res1 = Compute::add_and_return(8u8, 5u8);
        let res2 = Compute::with_lambda(7u8, 2u8);
        let res3 = NestedCall::call_inline_add(4u8, 4u8);
        let res4 = EarlyReturn::test_early_return(1u8);

        // Just demonstrate calling without assertions
        let _ = res1;
        let _ = res2;
        let _ = res3;
        let _ = res4;
    }
}


//# run 0xCAFE::Compute::add_and_return --args 11u8 5u8


//# run 0xCAFE::Compute::with_lambda --args 3u8 4u8


//# run 0xCAFE::NestedCall::call_inline_add --args 6u8 7u8


//# run 0xCAFE::NestedCall::runner


//# run 0xCAFE::EarlyReturn::test_early_return --args 10u8


//# run
script {
    use 0xCAFE::EarlyReturn;

    fun main() {
        let _ = EarlyReturn::test_early_return(0u8);
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 2a6cb6f49f542b75785477273a804a43: Test that the script correctly terminates early with a return statement inside an if branch, preventing subsequent code from executing and ensuring that assertions after the return are not triggered.
// 51123599f7fb630aaa8c0ae31762de07: Include scripts in the program declaration.
