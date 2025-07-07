
//# publish
module 0xCAFE::MathOps {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;

        let lambda: |u8|u8 has copy+drop = |x: u8| {
            x + sum
        };

        lambda(sum)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::MathOps;

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let partial_sum = MathOps::inline_add(a, b);
        let final_sum = MathOps::add_and_return_sum(partial_sum, b);
        final_sum
    }
}


//# run
script {
    fun main() {
        // Test for loop with range 0..10
        let total: u8 = 0;
        for (i in 0..10) {
            total = total + i;
        };

        // We do nothing with total, just testing no runtime error occurs
    }
}


//# run 0xCAFE::MathOps::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::NestedCall::nested_inline_call --args 5u8 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d3fa72cc69505d29275ee408acad95a3: Test that a for loop with a range (0..10) executes without errors in a script.
