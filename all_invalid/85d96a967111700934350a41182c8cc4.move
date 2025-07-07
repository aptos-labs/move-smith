//# publish
module 0xCAFE::AssertTest {
    use std::string;
    use std::vector;
    use std::error;

    const ERROR_CODE_DIV_ZERO: u64 = 1000;

    // A constant to test constant declarations
    const SOME_CONST: u64 = 42;

    struct TestStruct has copy, drop, store {
        val: u64,
    }

    public fun div(a: u64, b: u64): u64 {
        // This will cause abort if b == 0
        assert!(b != 0, ERROR_CODE_DIV_ZERO);
        a / b
    }

    public fun test_assert_pass() {
        assert!(true, 1);
        let _x = div(10, 2);
    }

    public fun test_assert_fail_div_by_zero() {
        // This will trigger abort 1000 due to division by zero inside assert condition error
        let b = 0;
        // We trigger assert with false condition that depends on a division by zero
        assert!((10 / b) > 0, ERROR_CODE_DIV_ZERO);
    }

    public fun test_assert_fail_false_condition() {
        assert!(false, 12345);
    }

    public fun use_constants(): u64 {
        SOME_CONST
    }

    public fun create_struct(val: u64): TestStruct {
        TestStruct { val }
    }

    // Schema declaration example
    spec schema TestSchema {
        ensures true;
    }
    // Function with explicit parameter names and types
    public fun add_with_names(a: u64, b: u64): u64 {
        a + b
    }
}

//# run 0xCAFE::AssertTest::test_assert_pass

//# run 0xCAFE::AssertTest::use_constants

//# run 0xCAFE::AssertTest::create_struct --args 123u64

//# run 0xCAFE::AssertTest::add_with_names --args 10u64 32u64

//# run 0xCAFE::AssertTest::test_assert_fail_false_condition

//# run 0xCAFE::AssertTest::test_assert_fail_div_by_zero

// Featurres:
// 0bb4bf5973a9fd77e87c701e2bacbd46: Test that the assert! macro correctly handles conditions and triggers aborts when the condition is false, even if the error message involves runtime errors like division by zero.
// cbf9c66be899e3d28ae69bf46264946a: Define a module with various members including functions, constants, structs, and schema specifications.
// 90412034e9d821593c8fc32a21266754: Declare function parameters with explicit variable names and types using the syntax 'name: Type'.
