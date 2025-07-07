
//# publish
module 0xCAFE::Adder {
    // Module to test addition and lambda expressions

    public fun add_two_values(a: u8, b: u8): u8 {
        // return sum plus 1 to test computation
        let sum = a + b;
        sum + 1
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }
    
    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# run 0xCAFE::Adder::add_two_values --args 3u8 4u8


//# run 0xCAFE::Adder::use_lambda --args 5u8 6u8


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let incremented = Adder::inline_increment(x);
        let sum = Adder::add_two_values(incremented, y);
        sum
    }
}


//# run 0xCAFE::Caller::call_inline_and_add --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
