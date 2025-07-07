
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;
    use std::signer;
    use std::error;

    /// Simple addition of two u8 values plus a constant, returns result
    public fun add_with_const(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    /// Function containing lambda that doubles input and adds a constant
    public fun lambda_double_add(input: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a * 2 + 3
        };
        lambda(input)
    }

    /// Inline function which returns a tuple; will be called from other module
    public inline fun inline_tuple(a: u16): (u16, u16) {
        (a * 3, a * 4)
    }

    /// Function to test usage of references; returns sum of referenced values
    public fun add_from_refs(x_ref: &u8, y_ref: &u8): u8 {
        *x_ref + *y_ref
    }
}


//# publish
module 0xCAFE::FeatureUser {
    use 0xCAFE::FeatureTest;

    /// Call the inline function inside FeatureTest and return the sum of the tuple elements
    public fun call_inline_and_sum(a: u16): u32 {
        let (x, y) = FeatureTest::inline_tuple(a);
        (x as u32) + (y as u32)
    }
}


// Uncommenting this will verify error for duplicate module name in same package
/*
//# publish
module 0xCAFE::FeatureUser {
    public fun dummy(): u8 {
        0
    }
}
*/


//# run
script {
    use 0xCAFE::FeatureTest;
    use 0xCAFE::FeatureUser;
    use std::signer;      // normal use
    // addr(0xCAFE)] use std::vector;  // attribute attached to use declaration

    fun main() {
        // 1. Test addition of two u8 values + 10
        let result1 = FeatureTest::add_with_const(5u8, 6u8);
        // Result expected 5 + 6 + 10 = 21u8

        // 2. Test lambda anonymously doubling and adding 3
        let result2 = FeatureTest::lambda_double_add(4u8);
        // Expected: 4 * 2 + 3 = 11u8

        // 3. Test nested inline call and sum of tuple
        let result3 = FeatureUser::call_inline_and_sum(3u16);
        // inline_tuple returns (3*3, 3*4) = (9, 12), sum = 21u32

        // 5. Test references usage
        let a = 7u8;
        let b = 8u8;
        let result4 = FeatureTest::add_from_refs(&a, &b);
        // expected 7 + 8 = 15u8

        // Just bind to variables to avoid unused variable error
        let _ = (result1, result2, result3, result4);
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// b624817f176acbc46aef772f9a0cdaed: Receive an error when defining two modules with the same name in a Move package.
// b0d6fe1b9b6c3e49aae7476ba28d5617: Use references to values.
// a618575568cc48edf7aa4150c6567ef8: Attach attributes to individual 'use' declarations inside your script.
