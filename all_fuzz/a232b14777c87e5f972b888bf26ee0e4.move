
//# publish
module 0xCAFE::Calculator {
    // A simple calculator module testing addition and lambda expressions

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 10 to differentiate from simple sum
        sum + 10
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        let add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add(x, y)
    }

    public fun nested_inline_calls(a: u8, b: u8): u8 {
        let sum = 0xCAFE::InlineFuncs::inline_add(a, b);
        sum + 5
    }

    struct Data has copy, drop, store {
        a: u8,
        b: u8,
    }
}


//# run 0xCAFE::Calculator::add_and_return --args 7u8 8u8


//# run 0xCAFE::Calculator::call_lambda --args 12u8 15u8


//# run 0xCAFE::Calculator::nested_inline_calls --args 3u8 4u8


//# publish
module 0xCAFE::InlineFuncs {
    // Module defining inline functions to be called from other modules

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::Accumulator {
    // Module to test accumulation by summing decreasing values from input

    public fun test1(x: u8, y: u8): u8 {
        let mut_acc = 0u8;
        let mut_x = x;

        let acc = mut_acc;
        let val = mut_x;

        while (val > 0) {
            acc = acc + val;
            val = val - 1;
        };

        acc + y
    }
}


//# run 0xCAFE::Accumulator::test1 --args 5u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 3c4fca549240d202323509cd13d0e6a8: Declare structures within modules for data organization.
// 46dad5b78645bcbf204e23b9432b614a: Test that the `test1` function correctly sums decreasing values from the input and computes the final result as the sum of initial inputs plus the accumulated total.
