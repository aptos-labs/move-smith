
//# publish
module 0xDEAD::SpecTest {
    // Perfectly valid module for testing spec references, access, and aliasing
    struct InternalStruct has copy, drop, store {
        value: u64,
    }

    // Function with 'internal' visibility to test access restrictions
    fun internal_function(): u64 {
        42
    }

    // Dummy function to mimic reference referring to `InternalStruct` (not accessible outside)
    fun get_internal_struct(): InternalStruct {
        InternalStruct { value: 99 }
    }
}


//# publish
module 0xBADD::VersionedReturns {
    // Function that returns another function (when language version is >= 2.2)
    // Use feature flag pseudocode comment; again, the syntax is conceptual for test purposes
    public fun get_double_function(): (fun(u64): u64) {
        fun double(x: u64): u64 {
            x * 2
        }
        double
    }
}


//# publish
module 0xFAKE::VisibilityTest {

    // For testing annotation resolution
    // 0x1::SomeModule]
    fun annotated_ref() {}

    // Internal function not accessible outside this module
    fun internal_helper(): u64 {
        123
    }
}



//# run 0xCAFEBABE::MainTest::run_spec_alias
// Description:
// This test checks that within a 'spec' block (conceptually), referencing modules like `0xDEAD::SpecTest` and `0xBADD::VersionedReturns` correctly aliases their members,
// and that the members are accessible as expected within the block.


//# run 0xCAFEBABE::MainTest::test_spec_alias

// Test 2: Function returning another function when language version >= 2.2

//# run 0xCAFEBABE::MainTest::test_function_returning_function

// Test 3: Access restrictions for 'internal' functions (should fail outside module)
// This is intentionally commented out because the access should be compiler error
// but included here for completeness to test behavior.
// 
//# run 0xCAFEBABE::MainTest::test_internal_access

// Test 4: Module annotation resolution

//# run 0xCAFEBABE::MainTest::test_module_annotation_resolve

// Test 5: Access specifiers with or without trailing comma

//# run 0xCAFEBABE::MainTest::test_access_specifiers_with_trailing_comma

// Below are the corresponding test functions invoked above in a 'MainTest' module, which would be either existing or defined here for running the tests.

//# publish
module 0xCAFEBABE::MainTest {
    // Wrapper functions to call the tests; assuming the test environment calls these
    public fun run_spec_alias() {
        // Simulate the 'spec' block aliasing test:
        // Import modules
        let spec_test_x = 0xDEAD::SpecTest;
        let spec_test_y = 0xBADD::VersionedReturns;

        // Access members via aliasing
        let internal_value = spec_test_x::InternalStruct { value: 0 }.value; // Should be valid
        let result_fn = spec_test_y::get_double_function();
        let doubled_value = result_fn(5);
        // Proceed to assert checks or just run
        assert!(internal_value == 0, 0);
        assert!(doubled_value == 10, 0);
    }

    public fun test_spec_alias() {
        // Call the above wrapper to run the aliasing test
        Self::run_spec_alias();
    }

    public fun test_function_returning_function() {
        // When language version >= 2.2, this should compile & work
        let fn_double = 0xBADD::VersionedReturns::get_double_function();
        let val = fn_double(21);
        // Expect val == 42
        assert!(val == 42, 0);
    }

    public fun test_internal_access() {
        // Attempt to call internal function (should fail to compile if outside module)
        // let x = 0xCAFEBABE::SpecTest::internal_function(); // Should be compile error
        // But for test illustration, we comment it out
        // To test access restrictions, one could attempt to compile and see failure
    }

    public fun test_module_annotation_resolve() {
        // Call annotated reference
        // The attribute should resolve successfully
        0xFAKE::VisibilityTest::annotated_ref();
        // Trying to call internal_helper() should fail at compile time, so we skip invocation
        // but if needed, it can be tested similarly
    }

    public fun test_access_specifiers_with_trailing_comma() {
        // Simulate some access specs with trailing comma
        // e.g., public fun foo() {}
        // This is valid syntax, so just a placeholder
        // No runtime execution needed, the syntax correctness is checked at compile time
    }
}


// Featurres:
// 843cbf156cbc53e45050badafe3d2551: Define 'spec' blocks with target schemas or modules, enabling implicit aliasing of their constituent members.
// ae915a9726a36c11d4f1d384f1a96087: Allow functions to return function-typed values at the top level if the language version is at least 2.2.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 63531286c09582ddaf3a77bcd2b8dbbe: Annotate Move code using attributes that refer to specific modules by name and address (e.g., '0x1::SomeModule').
// 7f11eead1c9592429aab953f8054c037: Allow optional trailing commas in access specifier lists.
