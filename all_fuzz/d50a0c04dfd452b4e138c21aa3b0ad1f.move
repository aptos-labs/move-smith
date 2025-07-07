
//# publish
module 0xCAFE::Adder {
    // Module to test simple function and lambdas for addition

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 5 as a test for correct computation and return
        sum + 5
    }

    public fun apply_lambda_addition(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun apply_lambda_with_capture(x: u8): u8 {
        let captured = 10u8;
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a + captured
        };
        lambda(x)
    }

    public fun runner(): u8 {
        let a = 2u8;
        let b = 3u8;
        apply_lambda_addition(a, b)
    }
}



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    // Call the inline function in Adder module
    public fun inline_add_twice(a: u8): u8 {
        // call runner which returns addition of 2 + 3 = 5
        let first = Adder::runner();
        // call inline_add_twice returns first + a
        first + a
    }

    public fun call_add_and_lambda(a: u8, b: u8): u8 {
        let sum = Adder::add_two_u8(a, b);
        let lambda_sum = Adder::apply_lambda_addition(a, b);
        // return sum + lambda_sum
        sum + lambda_sum
    }
}



//# run 0xCAFE::Adder::add_two_u8 --args 4u8 6u8



//# run 0xCAFE::Adder::apply_lambda_addition --args 7u8 8u8



//# run 0xCAFE::Adder::apply_lambda_with_capture --args 5u8



//# run 0xCAFE::Adder::runner



//# run 0xCAFE::Caller::inline_add_twice --args 10u8



//# run 0xCAFE::Caller::call_add_and_lambda --args 3u8 4u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
