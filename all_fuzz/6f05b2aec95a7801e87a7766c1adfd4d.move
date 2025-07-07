
//# publish
module 0xCAFE::Adder {
    public inline fun add(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = add(x, y);
        // Return a fixed value after computing sum (ignore sum here)
        42u8
    }
}


//# run 0xCAFE::Adder::add_and_return_fixed --args 10u8 20u8



//# publish
module 0xCAFE::LambdaExamples {
    public fun lambda_no_capture(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        f(x)
    }

    public fun lambda_with_multiple_args(a: u8, b: u8): u8 {
        let f: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x * y };
        f(a, b)
    }
}


//# run 0xCAFE::LambdaExamples::lambda_no_capture --args 41u8


//# run 0xCAFE::LambdaExamples::lambda_with_multiple_args --args 6u8 7u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public fun call_inline_add(a: u8, b: u8): u8 {
        Adder::add(a, b)
    }

    public fun nested_call_add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = call_inline_add(a, b);
        // After getting sum, call add_and_return_fixed which returns fixed 42u8
        Adder::add_and_return_fixed(sum, 0u8)
    }
}


//# run 0xCAFE::NestedCall::call_inline_add --args 11u8 12u8


//# run 0xCAFE::NestedCall::nested_call_add_and_return_fixed --args 10u8 32u8



//# publish
module 0xCAFE::ReturnTypeSpec {
    public fun return_type_spec(x: u8, y: u8): u8 {
        let sum: u8 = x + y;
        sum
    }
}


//# run 0xCAFE::ReturnTypeSpec::return_type_spec --args 20u8 22u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 290d9ace984c73bfe9a12a6153ee5fe7: Specify the return type of a function with a single return value using a colon followed by the signature token.
