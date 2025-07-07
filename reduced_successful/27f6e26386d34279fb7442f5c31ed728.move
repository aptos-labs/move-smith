
//# publish
module 0xCAFE::MathBasics {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a constant value to test function correctness (say 42)
        42u8
    }

    // Lambda function example: add and multiply captured values
    public fun lambda_example(x: u8, y: u8): (u8, u8) {
        let add_and_multiply: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let prod = a * b;
            (sum, prod)
        };
        add_and_multiply(x, y)
    }
}


//# run 0xCAFE::MathBasics::add_two_values --args 3u8 4u8


//# run 0xCAFE::MathBasics::lambda_example --args 5u8 6u8



//# publish
module 0xCAFE::AdvancedMath {
    use 0xCAFE::MathBasics;

    // inline function that returns u64: sum of two u64 numbers
    public inline fun inline_sum(a: u64, b: u64): u64 {
        a + b
    }

    // function that calls MathBasics::add_two_values and inline_sum
    public fun nested_calls(a: u8, b: u8, c: u64, d: u64): (u8, u64) {
        let s = MathBasics::add_two_values(a, b);
        let t = inline_sum(c, d);
        (s, t)
    }
}


//# run 0xCAFE::AdvancedMath::nested_calls --args 2u8 3u8 10u64 20u64



//# publish
module 0xCAFE::SquareDiff {
    // Calculate square of n (n^2)
    fun square(n: u64): u64 {
        n * n
    }

    // Compute sum of squares from 1 to n
    fun sum_of_squares(n: u64): u64 {
        let sum = 0u64;
        let i = 1u64;
        while (i <= n) {
            sum = sum + square(i);
            i = i + 1;
        };
        sum
    }

    // Compute square of sum from 1 to n
    fun square_of_sum(n: u64): u64 {
        // sum 1 to n = n*(n+1)/2
        let s = n * (n + 1) / 2;
        square(s)
    }

    // Calculate difference = square_of_sum - sum_of_squares
    public fun difference(n: u64): u64 {
        let sq_sum = square_of_sum(n);
        let sum_sq = sum_of_squares(n);
        sq_sum - sum_sq
    }
}


//# run 0xCAFE::SquareDiff::difference --args 10u64


//# run 0xCAFE::SquareDiff::difference --args 100u64



//# publish
module 0xCAFE::VectorMutation {
    use std::vector;

    // mutate vector elements: multiply each element by 2
    public fun double_each_element(v: &mut vector<u64>) {
        vector::for_each_mut(v, |elem: &mut u64| {
            *elem = *elem * 2;
        });
    }

    // runner function to test mutation inside module
    public fun test_double() {
        let v = vector::empty<u64>();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);
        vector::push_back(&mut v, 3);
        double_each_element(&mut v);
        // After mutation, v should be [2,4,6]
    }
}


//# run 0xCAFE::VectorMutation::test_double


// Save compiled modules and scripts to disk commands (example filenames):
// Save 0xCAFE::MathBasics to MathBasics.move
// Save 0xCAFE::AdvancedMath to AdvancedMath.move
// Save 0xCAFE::SquareDiff to SquareDiff.move
// Save 0xCAFE::VectorMutation to VectorMutation.move


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 63070a06dc70475ab971d589958b2c30: Save compiled Move modules and scripts to disk with proper naming conventions.
// aaed2d449943518d0cfabe6136d81025: Test that the function correctly calculates the difference between the square of the sum and the sum of squares for a given n, specifically verifying it for n=10 and n=100.
// 850953569e145dcdf23be1fed163c5ff: Test that the `vector::for_each_mut` function correctly mutates each element of the vector in sequence.
