
//# publish
module 0xDEAD::DeprecationTest {
    use std::signer;
    use std::error;
    use std::assert;

    // Mark the namespace as deprecated
    // deprecated(address)]
    public static address: address = @0xBADD;

    // A dummy function in deprecated namespace
    public fun deprecated_func(): u64 {
        42
    }

    // Define a script entry point that calls the deprecated function
    public fun script_entry_point(s: signer) {
        let _val = deprecated_func();
    }

    // Function with pre- and post-conditions to check specifications
    public fun spec_checked_function(x: u64): u64 {
        // Pre-condition: x should be less than 100
        assert!(x < 100, error::invalid_argument(1));
        let result = x + 10;
        // Post-condition: result should be greater than x
        assert!(result > x, error::invalid_argument(2));
        result
    }

    // Function to invoke pre/post condition checks
    public fun test_specification(x: u64): u64 {
        spec_checked_function(x)
    }
}


//# run 0xDEAD::DeprecationTest::script_entry_point --signers 0xFEED


//# run 0xDEAD::DeprecationTest::test_specification --args 50u64


//# run 0xDEAD::DeprecationTest::test_specification --args 150u64 // Should fail pre-condition


//# run 0xDEAD::DeprecationTest::deprecated_func // Direct call, should be deprecated error


//# publish
module 0xBABE::FunctionPointerTests {
    // Declare a generic function
    public fun generic_fn<T: copy + drop>(x: T): T {
        x
    }

    // Assign function to variable and call
    public fun assign_fn_to_var<T: copy + drop>(x: T): T {
        let fn_ptr: fn(T): T = generic_fn;
        fn_ptr(x)
    }

    // Pass function as argument and invoke
    public fun call_fn_as_arg<T: copy + drop>(f: fn(T): T, arg: T): T {
        f(arg)
    }

    // Use function pointer as closure
    public fun closure_like<T: copy + drop>(f: fn(T): T, x: T): T {
        f(x)
    }

    // Call with specific types
    public fun test_all() {
        let res1 = assign_fn_to_var(3u64);
        let res2 = call_fn_as_arg(generic_fn, 10u64);
        let res3 = closure_like(generic_fn, 7u64);
        let res4 = assign_fn_to_var(b"hello");
        // The values are just returned; no need to assert here for simplicity
    }
}


//# run 0xBABE::FunctionPointerTests::test_all



//# publish
module 0xC0FFEE::AnalyzeFunctions {
    // Function with no parameters and pure
    public fun pure_func(): u64 {
        7
    }

    // Function with parameters and purity
    public fun checked_func(x: u64): u64 {
        assert!(x > 0, error::invalid_argument(3));
        x + 1
    }

    // Generic function with constraints
    public fun generic_identity<T: copy + drop>(x: T): T {
        x
    }

    // Function with pre/post conditions with invalid state (should trigger an error if violated)
    public fun pre_post_conditions(x: u64): u64 {
        assert!(x != 0, error::invalid_argument(4));
        let y = x * 2;
        assert!(y > x, error::invalid_argument(5));
        y
    }

    // Function that calls others
    public fun composite() {
        let val1 = pure_func();
        let val2 = checked_func(val1);
        let val3 = generic_identity<u64>(val2);
        let _ = pre_post_conditions(val3);
    }
}


//# run 0xC0FFEE::AnalyzeFunctions::composite



//# publish
module 0xABCD::InteractionTest {
    use std::signer;
    use 0xDEAD::DeprecationTest;

    // Entry point that interacts with deprecated namespace
    public fun interact_with_deprecated(s: signer) {
        let _ = DeprecationTest::deprecated_func();
    }

    // Function to test function pointers to deprecated functions
    public fun test_fn_pointer(s: signer) {
        // Assign deprecated function pointer
        let fn_ptr: fn() -> u64 = DeprecationTest::deprecated_func;
        let _res = fn_ptr();
    }
}



//# run 0xABCD::InteractionTest::interact_with_deprecated --signers 0xFACE


//# run 0xABCD::InteractionTest::test_fn_pointer --signers 0xBABB


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
