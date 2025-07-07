//# publish
module 0x1::UnsignedIntComparisonSupport {
    // Provide simple wrappers if needed for testing inside scripts
    public fun test_equal<T: copy + drop + equal>(&self, a: T, b: T): bool {
        a == b
    }

    public fun test_not_equal<T: copy + drop + equal>(&self, a: T, b: T): bool {
        a != b
    }

    public fun test_less<T: copy + drop + ord>(&self, a: T, b: T): bool {
        a < b
    }

    public fun test_greater<T: copy + drop + ord>(&self, a: T, b: T): bool {
        a > b
    }

    public fun test_less_equal<T: copy + drop + ord>(&self, a: T, b: T): bool {
        a <= b
    }

    public fun test_greater_equal<T: copy + drop + ord>(&self, a: T, b: T): bool {
        a >= b
    }
}

//# publish
module 0x2::MultiBitWidthComparisons {
    // Test cross-width comparisons if supported
    // (assuming comparisons between different bitwidths are allowed via implicit conversions or supported)
    // Note: For simplicity, we'll compare the same types here.
    // For cross-width, more elaborate conversion logic might be necessary.
}

//# publish
module 0x3::ArithmeticEdgeCases {
    // No new types needed; focus on boundary, overflow, and errors
}

//# run
script {
fun main() {
    // Test equal and not equal for various unsigned types
    // Use the support module
    let comparer = 0x1::UnsignedIntComparisonSupport;

    // Equality tests across various bitwidths
    assert!(comparer.test_equal(0u8, 0u8), 1000);
    assert!(comparer.test_equal(0u16, 0u16), 1001);
    assert!(comparer.test_equal(0u32, 0u32), 1002);
    assert!(comparer.test_equal(0u64, 0u64), 1003);
    assert!(comparer.test_equal(0u128, 0u128), 1004);
    assert!(comparer.test_equal(0u256, 0u256), 1005);

    // Inequality assertions
    assert!(comparer.test_not_equal(0u8, 1u8), 1100);
    assert!(comparer.test_not_equal(0u16, 1u16), 1101);
    assert!(comparer.test_not_equal(0u32, 1u32), 1102);
    assert!(comparer.test_not_equal(0u64, 1u64), 1103);
    assert!(comparer.test_not_equal(0u128, 1u128), 1104);
    assert!(comparer.test_not_equal(0u256, 1u256), 1105);

    // Test less than
    assert!(comparer.test_less(0u8, 1u8), 1200);
    assert!(comparer.test_less(0u16, 1u16), 1201);
    assert!(comparer.test_less(0u32, 1u32), 1202);
    assert!(comparer.test_less(0u64, 1u64), 1203);
    assert!(comparer.test_less(0u128, 1u128), 1204);
    assert!(comparer.test_less(0u256, 1u256), 1205);

    // Test greater than
    assert!(comparer.test_greater(1u8, 0u8), 1300);
    assert!(comparer.test_greater(1u16, 0u16), 1301);
    assert!(comparer.test_greater(1u32, 0u32), 1302);
    assert!(comparer.test_greater(1u64, 0u64), 1303);
    assert!(comparer.test_greater(1u128, 0u128), 1304);
    assert!(comparer.test_greater(1u256, 0u256), 1305);

    // Test less or equal
    assert!(comparer.test_less_equal(0u8, 0u8), 1400);
    assert!(comparer.test_less_equal(0u16, 0u16), 1401);
    assert!(comparer.test_less_equal(0u32, 0u32), 1402);
    assert!(comparer.test_less_equal(0u64, 0u64), 1403);
    assert!(comparer.test_less_equal(0u128, 0u128), 1404);
    assert!(comparer.test_less_equal(0u256, 0u256), 1405);

    // Test greater or equal
    assert!(comparer.test_greater_equal(1u8, 0u8), 1500);
    assert!(comparer.test_greater_equal(1u16, 0u16), 1501);
    assert!(comparer.test_greater_equal(1u32, 0u32), 1502);
    assert!(comparer.test_greater_equal(1u64, 0u64), 1503);
    assert!(comparer.test_greater_equal(1u128, 0u128), 1504);
    assert!(comparer.test_greater_equal(1u256, 0u256), 1505);
}
}

//# run
script {
fun main() {
    // Test arithmetic with boundary values
    // addition
    assert!(0u32 + 0u32 == 0u32, 2000);
    assert!(1u32 + 0u32 == 1u32, 2001);
    assert!(0u32 + 4294967295u32 == 4294967295u32, 2002);
    assert!(4294967295u32 + 0u32 == 4294967295u32, 2003);
    // overflow test: should cause compilation or runtime error (simulate with comment)
    // 4294967295u32 + 1u32; // expected overflow error

    // subtraction
    assert!(1u32 - 0u32 == 1u32, 2100);
    assert!(4294967295u32 - 4294967295u32 == 0u32, 2101);
    // Underflow test: should cause error or panic
    // 0u32 - 1u32; // expected underflow error

    // multiplication
    assert!(0u32 * 0u32 == 0u32, 2200);
    assert!(1u32 * 0u32 == 0u32, 2201);
    assert!(1u32 * 1u32 == 1u32, 2202);
    assert!(4294967295u32 * 1u32 == 4294967295u32, 2203);
    // overflow test
    // 2147483648u32 * 2u32; // should overflow

    // division: boundary checks
    assert!(4294967295u32 / 1u32 == 4294967295u32, 2300);
    assert!(4294967295u32 / 4294967295u32 == 1u32, 2301);
    // division by zero: should cause error
    // 1u32 / 0u32; // expected error

    // modulus
    assert!(4294967295u32 % 1u32 == 0u32, 2400);
    assert!(4294967295u32 % 2u32 == 1u32, 2401);
    // modulus by zero: should cause error
    // 1u32 % 0u32; // expected error
}
}

//# run
script {
fun main() {
    // Expect errors as indicated in the comments
    // overflow addition
    // 4294967295u32 + 1u32;
}
}

//# run
script {
fun main() {
    // Expect errors
    // underflow subtraction
    // 0u32 - 1u32;
}
}

//# run
script {
fun main() {
    // Expect overflow in multiplication
    // 2147483648u32 * 2u32;
}
}

//# run
script {
fun main() {
    // Expect division by zero error
    // 1u32 / 0u32;
}
}

//# run
script {
fun main() {
    // Expect modulus by zero error
    // 1u32 % 0u32;
}
}