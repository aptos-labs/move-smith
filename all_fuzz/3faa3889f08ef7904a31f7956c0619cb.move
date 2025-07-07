
//# publish
module 0xCAFE::LambdaTest {
    use std::option;

    // A function that adds two u8 values and returns the sum + 5
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    // A function with a lambda (anonymous function) that multiplies two u8 and returns the product
    public fun multiply_lambda(x: u8, y: u8): u8 {
        let mult: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        mult(x, y)
    }

    // A function returning a closure (lambda) that adds a captured u8 to input u8
    public fun make_adder(captured: u8): |u8|u8 has copy+drop {
        |v: u8| {
            v + captured
        }
    }

    // Test closure usage by calling a returned closure
    public fun test_closure(): u8 {
        let closure = make_adder(10u8);
        let result = closure(20u8);
        result
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaTest;

    // Call add_and_offset and multiply_lambda from LambdaTest to test nested calls
    public fun double_call(a: u8, b: u8): (u8, u8) {
        let sum_offset = LambdaTest::add_and_offset(a, b);
        let product = LambdaTest::multiply_lambda(a, b);
        (sum_offset, product)
    }

    // Call test_closure function from LambdaTest
    public fun closure_result(): u8 {
        LambdaTest::test_closure()
    }
}


//# run 0xCAFE::LambdaTest::add_and_offset --args 12u8 8u8


//# run 0xCAFE::LambdaTest::multiply_lambda --args 3u8 7u8


//# run 0xCAFE::LambdaTest::test_closure


//# run 0xCAFE::NestedCalls::double_call --args 5u8 10u8


//# run 0xCAFE::NestedCalls::closure_result


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 85c48ba5a7da7c03dbf39553d01c6ee2: Create and use closures, with closure-specific correctness checks in Move 2.2 and above
