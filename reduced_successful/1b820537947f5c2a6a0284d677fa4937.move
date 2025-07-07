
//# publish
module 0xCAFE::BasicOperations {
    public fun add_two(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            let sum = 10;
        } else {
            let sum = sum;
        };
        sum
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::BasicOperations;

    public fun nested_inline_add(a: u8, b: u8): u8 {
        BasicOperations::inline_add(a, b)
    }

    public fun test_if_update(x: u8, cond: bool): u8 {
        let val = x;
        if (cond) {
            val = val + 5;
        } else {
            val = val + 1;
        };
        val
    }
}


//# run 0xCAFE::BasicOperations::add_two --args 4u8 7u8


//# run 0xCAFE::BasicOperations::use_lambda --args 5u8 6u8


//# run 0xCAFE::CallerModule::nested_inline_add --args 3u8 7u8


//# run 0xCAFE::CallerModule::test_if_update --args 10u8 true


//# run 0xCAFE::CallerModule::test_if_update --args 10u8 false


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// cf52485436f8c35d052e739192d45c67: Test that variable assignment inside an if statement correctly updates the variable's value and that the final expression evaluates to the updated value.
