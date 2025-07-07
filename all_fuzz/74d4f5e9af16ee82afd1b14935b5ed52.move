
//# publish
module 0xCAFE::MathOps {
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Unused variable example: let unused_var = sum * 2;
        sum + 1
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::AdvancedOps {
    use 0xCAFE::MathOps;

    public fun call_inline_twice(x: u8, y: u8): u8 {
        let first = MathOps::inline_add(x, y);
        let second = MathOps::inline_add(y, x);
        first + second
    }
}


//# run 0xCAFE::MathOps::add_then_return --args 10u8 20u8


//# run 0xCAFE::MathOps::with_lambda --args 5u8 7u8


//# run 0xCAFE::AdvancedOps::call_inline_twice --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 3bb6d261bd641609d8a0e89fd66e0b48: Identify and warn about unused variable assignments.
// 5bb7e3dfbdf603732bf7d8b63e1abb18: Declare modules with symbolic names and resolve them via aliases.
