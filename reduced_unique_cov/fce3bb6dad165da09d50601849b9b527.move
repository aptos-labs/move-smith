
//# publish
module 0xCAFE::Calculator {
    public fun add_then_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            42
        } else {
            42
        };
        42
    }

    public fun lambda_example(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let mul = x * y;
            (sum, mul)
        };
        lambda(a, b)
    }

    public fun nested_lambda_capture(x: u8): u8 {
        let outer = |a: u8| -> u8 {
            let inner = |b: u8| -> u8 {
                a + b + x
            };
            inner(a)
        };
        outer(x)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::Calculator;

    public fun call_inline_from_other_module(a: u8, b: u8): u8 {
        let (sum, _) = Calculator::lambda_example(a, b);
        let result = Calculator::add_then_return_42(sum, 0);
        result
    }

    public friend fun friend_fun_example(a: u8, b: u8): u8 {
        a + b + 1
    }
}


//# run 0xCAFE::Calculator::add_then_return_42 --args 10u8 20u8


//# run 0xCAFE::Calculator::lambda_example --args 7u8 3u8


//# run 0xCAFE::Calculator::nested_lambda_capture --args 5u8


//# run 0xCAFE::CallerModule::call_inline_from_other_module --args 8u8 4u8


//# run 0xCAFE::CallerModule::friend_fun_example --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// efe36f711ea2fe32d6f52459ba1c3a45: Test that nested lambda functions can capture and use variables from their enclosing scope.
// 770c35712771012f4c7922a7d395fd36: Specify access control modifiers with an access specifier in Move code.
// b5d81a20a5398c9d5b7dc51584b5ca34: Define modules in Move that will be verified for bytecode correctness after compilation.
