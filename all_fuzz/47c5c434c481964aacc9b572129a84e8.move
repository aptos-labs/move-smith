
//# publish
module 0xCAFE::ComputeAdd {
    // Function that adds two u8 values and returns u8
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    // Function containing a lambda that adds two u8 values and returns their sum
    public fun add_using_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    // Runner function to call add_using_lambda without parameters (fixed values)
    public fun run_lambda_example(): u8 {
        add_using_lambda(7u8, 8u8)
    }
}


//# run 0xCAFE::ComputeAdd::add_two_values --args 12u8 34u8


//# run 0xCAFE::ComputeAdd::add_using_lambda --args 50u8 20u8


//# run 0xCAFE::ComputeAdd::run_lambda_example



//# publish
module 0xCAFE::NestedCall {

    use 0xCAFE::ComputeAdd;

    // Calls ComputeAdd::add_two_values and then adds 1 to the result
    public fun call_add_and_increment(a: u8, b: u8): u8 {
        let res = ComputeAdd::add_two_values(a, b);
        let incremented = res + 1;
        incremented
    }

    // Calls ComputeAdd::run_lambda_example and doubles the result
    public fun call_lambda_and_double(): u8 {
        let val = ComputeAdd::run_lambda_example();
        val * 2
    }

    // Runner function to call call_add_and_increment with fixed args
    public fun run_add_and_increment(): u8 {
        call_add_and_increment(10u8, 20u8)
    }

    // Runner function to call call_lambda_and_double without args
    public fun run_lambda_double(): u8 {
        call_lambda_and_double()
    }
}


//# run 0xCAFE::NestedCall::call_add_and_increment --args 5u8 6u8


//# run 0xCAFE::NestedCall::call_lambda_and_double


//# run 0xCAFE::NestedCall::run_add_and_increment


//# run 0xCAFE::NestedCall::run_lambda_double


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
