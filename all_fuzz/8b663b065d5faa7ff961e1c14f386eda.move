
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_check(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 5 to have a specific value based on addition
        sum + 5
    }

    public fun add_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }
}


//# run 0xCAFE::TestAdd::add_and_check --args 10u8 20u8


//# run 0xCAFE::TestAdd::add_lambda --args 7u8 8u8


//# publish
module 0xCAFE::TestInlineCaller {
    use 0xCAFE::TestAdd;

    // Calls inline function from another module (simulate inline by embedding a public inline function)
    public inline fun multiply_add(x: u8, y: u8): u8 {
        // Call the add_and_check function from TestAdd
        let sum_with_offset = TestAdd::add_and_check(x, y);
        // Now multiply the result by 2 and return
        sum_with_offset * 2
    }

    public fun runner(): u8 {
        multiply_add(3u8, 4u8)
    }
}


//# run 0xCAFE::TestInlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
