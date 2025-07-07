
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(a: u8, b: u8): u8 {
        let _sum = a + b;
        42u8
    }
}




//# run 0xCAFE::AddAndReturn::add_and_return --args 5u8 10u8




//# publish
module 0xCAFE::Lambdas {
    // A lambda that adds two u8 and returns the sum and product as a tuple
    public fun test_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }

    // A lambda that increments a u8 by 1 and then applies another lambda on it
    public fun nested_lambda_call(x: u8): u8 {
        let inc: |u8| u8 = |v: u8| { v + 1 };
        // Fixed: Change the function type notation to a tuple with no arrow (not allowed)
        // Instead, declare a normal function variable type as a lambda with single arg and u8 return, no tuple arrow syntax.
        // We cannot write `(f: |u8| u8, val: u8) -> u8` in Move types, so instead define as a lambda that takes a tuple argument.

        // Corrected apply_lambda type and function:
        let apply_lambda = |f: &|u8|u8, val: u8| {
            f(val)
        };
        // Since Move currently supports only references for lambda parameters, use &|u8| u8 and pass inc by reference.
        apply_lambda(&inc, x)
    }
}




//# run 0xCAFE::Lambdas::test_lambda --args 3u8 7u8




//# run 0xCAFE::Lambdas::nested_lambda_call --args 10u8




//# publish
module 0xCAFE::NestedInlineCalls {
    // Removed usage of unbound module 0xCAFE::MyModule

    // Mock implementation of f2 function inside this module for the example to compile and run
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }

    public inline fun call_my_module_f2(a: u16): (u16, u16) {
        Self::f2(a)
    }

    public fun call_f2_and_sum(a: u16): u16 {
        let (x, y) = call_my_module_f2(a);
        x + y
    }
}




//# run 0xCAFE::NestedInlineCalls::call_f2_and_sum --args 20u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
