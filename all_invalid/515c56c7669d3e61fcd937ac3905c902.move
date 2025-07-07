//# publish
module 0xC0FF::ComplexTest {
    use std::vector;
    use std::option;

    // Define a nested struct with nested fields
    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
    }

    struct InnerStruct has copy, drop, store {
        value: u64,
        nested_value: u8,
    }

    // Define a generic struct
    struct GenericStruct<T> has copy, drop, store {
        data: T,
    }

    // Function to access nested fields using dot notation
    public fun access_nested_fields(os: &OuterStruct): (u64, u8) {
        let val = os.inner.value;
        let nested = os.inner.nested_value;
        (val, nested)
    }

    // Function to test deprecation warning/error on deprecated module
    public fun test_deprecated_module() {
        let _ = 0xDEAD::DeprecatedNamespace::dummy();
    }

    // Define a dummy function in deprecated namespace for testing
    // (Already defined as 'dummy' in the deprecated namespace)

    // Function to assign functions to variables, pass as arguments, and invoke
    public fun first_class_functions() {
        // Define a simple function
        fun add_one(x: u64): u64 {
            x + 1
        }

        // Assign function to a variable
        let f: fun(u64): u64 = add_one;

        // Invoke via variable
        let result1 = f(10);

        // Pass function as argument to another function
        fun caller(func: fun(u64): u64, val: u64): u64 {
            func(val)
        }

        let result2 = caller(f, 20);

        // Invoke function pointer directly
        let result3 = f(30);

        // Inline function returning a function
        let inline_fn: fun(): fun(u64): u64 = fun(x: u64): u64 { add_one };

        let fn_var = inline_fn();
        let result4 = fn_var(40);

        // Use results to ensure correct calls
        assert!(result1 == 11, 1);
        assert!(result2 == 21, 2);
        assert!(result3 == 31, 3);
        assert!(result4 == 41, 4);
    }

    // Function to test specification adherence (simulate by calling a pure function)
    public fun check_spec() {
        let res = pure_add(5, 6);
        assert!(res == 11, 11);
    }

    // Pure function for specification check
    public fun pure_add(a: u64, b: u64): u64 {
        a + b
    }

    // Inline function 'foo' that applies a passed-in function
    public fun foo(f: fun(u8): u8, val: u8): u8 {
        f(val)
    }

    // Main function combining inline 'foo' and asserting output
    public fun main(): bool {
        // Function to pass
        fun times_two(x: u8): u8 {
            x * 2
        }
        let result = foo(times_two, 1u8);
        // Assert that applying times_two to 1 results in 2
        result == 2
    }

    // Expected failure test: invalid arithmetic operation
    //// expected_failure(arithmetic_error)]
    public fun invalid_operation() {
        let a: u64 = 0;
        // Cause division by zero (which is an arithmetic error)
        let _ = a / 0;
    }
}
