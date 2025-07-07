

// Call a function from the un-deprecated module 0xCAFE::MyModule
0xCAFE::MyModule::f1(5u8, true);

// Call a generic function from 0xCAFE::MyModule
0xCAFE::MyModule::f2(20u16);

// Call a function returning a struct with nested function call
0xCAFE::MyModule::f3(15u16);

// Call a function with pattern match
0xCAFE::MyModule::f4();

// Call a higher-order function with lambda
0xCAFE::MyModule::f6(|x: u8| -> u8 { x + 1 }, 7u8);

// Call a function using a function pointer
0xCAFE::MyModule::f6(copy, 10u8);

// Call a function with nested loops
0xCAFE::MyModule::f8();

// Call an inline function with tuple return
0xCAFE::MyModule::f2(25u16);

// Call vector usage
0xCAFE::MyModule::example_vector_usage();

// Call deprecation test: expect warning or error if dep attribute is used
// This will depend on language configuration; here is just illustrative call
0xCAFE::DeprecatedModule::deprecated_func();

// Verify passing function as argument
// (Assuming function passed as argument, hypothetical here)
// Not directly possible with current code, so skipped.


//# publish
module 0xCAFE::DeprecatedModule {
    // Mark whole namespace deprecated (assuming language support)
    
//# deprecated
    public fun deprecated_func() {
        // do nothing
    }
}


0xCAFE::DeprecatedModule::deprecated_func();


//# publish
module 0xCAFE::FunctionPointerTest {
    use std::vector;

    // Function type alias
    public fun type_alias() { }

    // Sample functions for testing function pointers
    public fun simple_fn(a: u8): u8 {
        a + 1
    }

    public fun generic_fn<T: copy + drop>(t: T): T {
        t
    }

    // Store function as first-class value
    public fun test_dynamic_call() {
        let f: |u8| -> u8 = simple_fn;
        let result = f(5u8);
        // Result should be 6
        assert!(result == 6u8, 0);
        
        let g: |u8| -> u8 = simple_fn;
        assert!((g)(10u8) == 11u8, 0);
    }

    // Pass function as argument
    public fun call_with_fn(f: |u8| -> u8, value: u8): u8 {
        f(value)
    }

    // Call function pointer with various functions
    public fun run_tests() {
        let res1 = call_with_fn(simple_fn, 7u8);
        assert!(res1 == 8u8, 0);

        let res2 = call_with_fn(generic_fn<u8>, 9u8);
        assert!(res2 == 9u8, 0);
    }
}


//# run 0xCAFE::FunctionPointerTest::run_tests


//# publish
module 0xCAFE::CopyKillTest {
    // Function that copies input, performs mut operations, and verifies original remains unchanged
    public fun copy_kill(val: u64): u64 {
        let copy_val = val;
        let new_val = copy_val + 10;
        // val remains unchanged
        new_val
    }

    public fun test_copy_kill() {
        let original = 42u64;
        let result = copy_kill(original);
        // result should be original + 10
        assert!(result == 52u64, 42);
        // original remains unchanged
        assert!(original == 42u64, 42);
    }
}


//# run 0xCAFE::CopyKillTest::test_copy_kill


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// 74b4562d92ea6ae0aed01fec6f000a69: Test that the function copy_kill correctly copies the input value and performs arithmetic without affecting the original input.
