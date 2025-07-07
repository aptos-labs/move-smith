
//# publish
module 0xCAFE::FeatureTest {
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




//# run
script {
    use 0xCAFE::FeatureTest;
    use 0xCAFE::FeatureUser;

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

        // 4. Test references usage
        let a = 7u8;
        let b = 8u8;
        let result4 = FeatureTest::add_from_refs(&a, &b);
        // expected 7 + 8 = 15u8

        // Bind separately to avoid unused variable error without tuple
        let _ = result1;
        let _ = result2;
        let _ = result3;
        let _ = result4;
    }
}
