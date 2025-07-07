
}

// deprecated(address = 0xDEAD)]
//# publish
module 0xDEAD::DeprecatedNamespace {
    // Deprecated namespace module for deprecation testing
}


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
        let _ = 0xDEAD::DeprecatedNamespace::some_function();
    }

    // Define a dummy function in deprecated namespace for testing
    public fun dummy() {}

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
        public fun caller(func: fun(u64): u64, val: u64): u64 {
            func(val)
        }

        let result2 = caller(f, 20);

        // Pass function pointer and invoke
        let result3 = f(30);

        // Inline function returning function
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
        // Suppose interface requires pure functions
        // Verify that the functions used are pure (Move enforces this)
        // For example, call a pure function and ensure no side-effects
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
    // expected_failure(arithmetic_error)]
    public fun invalid_operation() {
        let a: u64 = 0;
        // Intentionally cause underflow (which moves entire code to U64, so simulate division by zero)
        let _ = a / 0;
    }
}


//# run 0xC0FF::ComplexTest::access_nested_fields --args 0u64 0u8


//# run 0xC0FF::ComplexTest::test_deprecated_module


//# run 0xC0FF::ComplexTest::first_class_functions


//# run 0xC0FF::ComplexTest::check_spec


//# run 0xC0FF::ComplexTest::main


//# run 0xC0FF::ComplexTest::invalid_operation


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 1b2ddea6cb5c2d7b6c8217aaefcf1d5f: Test that the inline function `foo` correctly applies a passed-in function to a value and that the `main` function asserts the result equals 3.
// 20294188ec76665b821ef7c9560d065a: Indicate an arithmetic error expected in your test with `#[expected_failure(arithmetic_error)]` attribute.
