
//# publish
module 0xCAFE::CalcModule {
    // A simple function that adds two u8 and returns a fixed value 42u8
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    // A function that uses a lambda (anonymous function)
    public fun double_apply_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |n: u8| { n * 2 };
        let doubled = lambda(x);
        lambda(doubled)
    }

    // Inline function to provide addition used by external module
    public inline fun add_inline(x: u8, y: u8): u8 {
        x + y
    }

    // Function that tests labeled loops feature (from Move 2.1)
    public fun test_loop_labels(): u8 {
        let x = 0u8;
        'outer: loop {
            let y = 0u8;
            'inner: loop {
                if (y == 3u8) {
                    break 'inner;
                };
                y = y + 1;
            };
            x = x + y; // x += 3
            if (x >= 6u8) {
                break 'outer;
            };
        };
        x
    }

    // A while loop computing cumulative sum from 0 to limit, variable scoping tested
    public fun cumulative_sum_while(limit: u8): u8 {
        let sum = 0u8;
        let i = 0u8;
        while (i <= limit) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }
}


//# run 0xCAFE::CalcModule::add_and_return_fixed --args 5u8 6u8


//# run 0xCAFE::CalcModule::double_apply_lambda --args 4u8


//# run 0xCAFE::CalcModule::test_loop_labels


//# run 0xCAFE::CalcModule::cumulative_sum_while --args 5u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;

    // Calling CalcModule::add_inline from another module testing nested calls
    public fun call_add_inline(x: u8, y: u8): u8 {
        CalcModule::add_inline(x, y)
    }
}


//# run 0xCAFE::CallerModule::call_add_inline --args 10u8 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c408678efb57f243f3d309ea5ecce99c: Leverage loop labels starting from Move language version 2.1.
// d2bc13aff928540133f58d9f2d499feb: Create variable names and other identifiers in Move that follow the naming rules defined by the identifier's characteristic of starting with a letter or underscore.
// b8a34de09e13d5cdf41a338ebe740faa: Test that a while-loop with variable assignments and updates inside correctly computes cumulative values and preserves variable scoping and mutation.
