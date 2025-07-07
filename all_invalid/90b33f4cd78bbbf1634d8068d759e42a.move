//# publish
module 0x1::TestModuleA {
    public fun no_args() {
        // dummy function for testing
    }

    public fun example_function(value: u64): u64 {
        value + 1
    }
}

 //# publish
module 0x2::TestModuleB {
    public fun no_args() {
        // dummy function for testing
    }

    public fun example_function(value: u64): u64 {
        value + 2
    }
}

 //# publish
module 0x3::UnionModule {
    // Function to demonstrate union type with '|'
    public fun accept_int_or_str(val: u64 | string) {
        // do nothing
    }

    // Function to demonstrate double union with '||'
    public fun accept_int_or_str_or_bool(val: u64 | string | bool) {
        // do nothing
    }
}

 //# publish
module 0x4::CrossModuleCallTest {

    // This function attempts to call a function from a different address, should error
    public fun cross_address_call() {
        let _ = 0x1::TestModuleA::example_function(10); // valid call
        let _ = 0x2::TestModuleB::example_function(20); // valid call
        // The following line is intentionally invalid and should cause an error:
        // should fail because calling 0x1::TestModuleA from here (0x4) is a cross module call, but cross address is invalid
        let _ = 0x1::TestModuleA::example_function(30);
    }

    // This function demonstrates usage of union types in argument; syntax may not exist at runtime, but is used to test compiler parsing.
    public fun test_union_types() {
        // Correct usage with u64
        0x3::UnionModule::accept_int_or_str(42u64);
        // Correct usage with string
        0x3::UnionModule::accept_int_or_str("hello");
        // Correct usage with multiple types
        0x3::UnionModule::accept_int_or_str_or_bool(100u64);
        0x3::UnionModule::accept_int_or_str_or_bool("world");
        // bool argument (allowed in double union)
        0x3::UnionModule::accept_int_or_str_or_bool(true);
        // Incorrect usage: passing a type not covered (e.g., vector), for testing error reporting, comment out as code would be invalid
        // 0x3::UnionModule::accept_int_or_str(vec[1,2,3]);
    }

    // Runner function to invoke all tests
    public fun run_all_tests() {
        // Intentionally calling cross domain to verify error detection
        // The following call should produce an error during compilation
        // but we include it to ensure compiler catches cross module address issues.
        Self::cross_address_call();

        // Test union type functions
        Self::test_union_types();
    }
}

 //# run 0x4::CrossModuleCallTest::run_all_tests