// Corrected transactional test code, focusing on proper syntax, invocation, and structure

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
// Note: Deprecation attributes are annotations and may trigger warnings; here just call
0xCAFE::DeprecatedModule::deprecated_func();


// #publish
//# publish
module 0xCAFE::DeprecatedModule {
    // Mark entire namespace deprecated if supported
    
//# deprecated
    public fun deprecated_func() {
        // do nothing
    }
}

// Call deprecated function
0xCAFE::DeprecatedModule::deprecated_func();


// #publish
//# publish
module 0xCAFE::FunctionPointerTest {
    use std::vector;

    // Function type alias is not directly supported in Move, but we can simulate via function signatures
    // For testing purposes, define functions

    // Sample functions for testing function pointers
    public fun simple_fn(a: u8): u8 {
        a + 1
    }

    public fun generic_fn<T: copy + drop>(t: T): T {
        t
    }

    // Store function as first-class value (by variable assignment)
    public fun test_dynamic_call() {
        let f: |u8| -> u8 = simple_fn;
        let result = f(5u8);
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

// #run 0xCAFE::FunctionPointerTest::run_tests


// #publish
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

// #run 0xCAFE::CopyKillTest::test_copy_kill
