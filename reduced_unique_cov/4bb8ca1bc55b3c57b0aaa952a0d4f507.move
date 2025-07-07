
//# publish
module 0xCAFE::LambdaAndLoop {
    use std::vector;

    /// Adds two u8 values and returns x+ y + 10
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    /// Returns a closure/lambda that adds 1 to the input
    public fun make_incrementer(): |u8|u8 has copy+drop {
        |x: u8| { x + 1 }
    }

    /// Calls an inline function from another module to add 2,3 then offsets by 1
    public fun call_inline_and_offset(): u16 {
        let (a, _) = 0xCAFE::MyModule::f2(2u16);
        a + 1
    }

    /// Function that uses a loop and includes loop invariants in its spec to verify sum of 1..n
    public fun sum_with_loop_invariant(n: u64): u64 {
        let sum = 0u64;
        let i = 1u64;

        spec fun loop_invariant(i: u64, sum: u64) {
            // sum = i * (i - 1) / 2 for current i, sum holds sum of 1..i-1
            sum == (i * (i - 1)) / 2
        }

        while (i <= n) {
            // Loop invariant ensuring sum is correct for i before increment
            spec {
                invariant loop_invariant(i, sum);
            };
            sum = sum + i;
            i = i + 1;
        };
        // After loop sum = n*(n+1)/2
        sum
    }
}


//# run 0xCAFE::LambdaAndLoop::add_and_offset --args 3u8 4u8


//# run 0xCAFE::LambdaAndLoop::make_incrementer


//# run 0xCAFE::LambdaAndLoop::call_inline_and_offset


//# run 0xCAFE::LambdaAndLoop::sum_with_loop_invariant --args 10u64


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4b11123d344e171b852c0c964e14cdb2: Use loop invariants in spec blocks inside Move code to specify properties that should hold true across loop iterations
