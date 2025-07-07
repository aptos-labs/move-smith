
//# publish
module 0xCAFE::LambdaTest {
    /// Function to add two u8 values and return the sum + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// Function demonstrating lambda expressions and returning the lambda result
    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            let total = x + y;
            total * 2
        };
        lambda(a, b)
    }

    /// Runner function using mutable references
    public fun mutable_ref_example(): u8 {
        let mut_val: u8 = 5;
        let ref_mut: &mut u8 = &mut mut_val;
        *ref_mut = *ref_mut + 10;
        *ref_mut
    }

    /// Function using return expressions explicitly
    public fun explicit_return(val: u8): u8 {
        if (val < 10) {
            return val * 2;
        };
        val
    }
}


//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::LambdaTest;

    /// Calls LambdaTest::add_and_offset and LambdaTest::use_lambda inline, sums results
    public fun call_inline_functions(a: u8, b: u8): u8 {
        let sum1 = LambdaTest::add_and_offset(a, b);
        let sum2 = LambdaTest::use_lambda(a, b);
        sum1 + sum2
    }
}


//# run 0xCAFE::LambdaTest::add_and_offset --args 3u8 4u8


//# run 0xCAFE::LambdaTest::use_lambda --args 2u8 5u8


//# run 0xCAFE::LambdaTest::mutable_ref_example


//# run 0xCAFE::LambdaTest::explicit_return --args 5u8


//# run 0xCAFE::LambdaTest::explicit_return --args 15u8


//# run 0xCAFE::InlineCallTest::call_inline_functions --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 75e91ea29526c106545f5899d508c944: Create mutable references to values using the &mut operator.
// bb9fae4aff8bda84cdc6b8b4a25bc3c2: Use return statements in expressions
