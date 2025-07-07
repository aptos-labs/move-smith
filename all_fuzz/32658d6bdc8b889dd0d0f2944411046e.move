
//# publish
module 0xCAFE::Calc {
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_u8_then_return_value(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        42u8 + sum
    }

    public fun lambda_example(a: u8, b: u8): u8 {
        let adder: |u8,u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        adder(a, b)
    }

    public fun lambda_closure_example(x: u8): u8 {
        let add_x: |u8|u8 has copy+drop = |y: u8| { x + y };
        add_x(5u8)
    }
}


//# run 0xCAFE::Calc::add_u8_then_return_value --args 5u8 7u8


//# run 0xCAFE::Calc::lambda_example --args 10u8 20u8


//# run 0xCAFE::Calc::lambda_closure_example --args 10u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Calc;

    public fun nested_call(a: u8, b: u8): u8 {
        // call Calc::add_u8_then_return_value inside NestedCall function
        let val = Calc::add_u8_then_return_value(a, b);
        val + 1u8
    }

    public fun runner(): u8 {
        nested_call(3u8, 4u8)
    }
}


//# run 0xCAFE::NestedCall::nested_call --args 7u8 8u8


//# run 0xCAFE::NestedCall::runner


// Script with named address, package name and simple invocation
// Note: Move transactional test language here allows named addresses and package info in comments

// Package: TestPackage
// Addresses:
//  Calc: 0xCAFE
//  NestedCall: 0xCAFE


//# run
script {
    use 0xCAFE::Calc;
    use 0xCAFE::NestedCall;

    fun main() {
        let result1 = Calc::add_u8_then_return_value(1u8, 2u8);
        let result2 = NestedCall::nested_call(5u8, 6u8);
        let result3 = NestedCall::runner();
        // no assertions needed
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 42efa3d947de9596936229598f2f727b: Allow modules and scripts to have associated package information and named address mappings.
