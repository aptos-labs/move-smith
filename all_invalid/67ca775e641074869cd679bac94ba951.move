//# publish
module 0xDEADBEEF::test_module {
    use std::debug;

    // Test spec blocks, type unions, error reporting, and various assertions
    #[script]
    fun spec_across_blocks() {
        // Top-level spec block with nested spec and function
        // Define a spec with a block that specifies the expected result
        spec {
            name: "Comprehensive Test Spec",
            description: "Tests various Move compiler features",
            checks: [
                {
                    description: "Check top-level spec with nested spec",
                    test: {
                        // Nested spec defining expected value
                        spec {
                            name: "Nested Spec",
                            description: "Inner spec with union types",
                            checks: [
                                {
                                    description: "Type union check with | and || syntax",
                                    // We test type union with both | and ||
                                    check_type_union: true,
                                    // intentionally cause an error in check to test error reporting
                                }
                            ]
                        }
                        // Function to run
                        print("Nested spec check executed");
                    }
                }
            ]
        }
        // Parameterized spec with union types
        spec {
            name: "Union Type Test",
            description: "Tests | and || syntax in type definitions",
            check_type_union: true,
        }
    }

    // Function that reports errors during spec validation
    public fun report_error_demo() {
        // Force an error by specifying an invalid spec block
        // For demonstration, we simulate an error message
        // (In real test, this would be part of testing validation)
        debug::print(&"Error: Invalid spec block detected - missing description");
    }

    // Function `test` returning 1 if input is true, else 9
    public fun test(condition: bool): u8 {
        if (condition) {
            1
        } else {
            9
        }
    }

    // Deprecated function
    #[deprecated]
    public fun deprecated_func() {
        debug::print(&"This function is deprecated");
    }

    // Local variables referencing same value; verify referencing and copying
    public fun variable_reference_behavior() {
        let val: u64 = 42;
        let ref_val = &val; // reference to val
        let copy_val = val; // copy of val

        // Assert references and copies behave as expected (these lines prevent unused vars warning)
        debug::print(&copy_val);
        debug::print(&(*ref_val)); // deference reference
    }

    // Function testing multiple references to same local variable
    public fun multiple_references_test() {
        let local_var: u64 = 55;
        let ref_a = &local_var;
        let ref_b = &local_var;
        // Both references should point to the same value
        debug::print(&(*ref_a));
        debug::print(&(*ref_b));
    }

    // Runner function inside the module to call other functions without args
    public fun run_all() {
        report_error_demo();
        variable_reference_behavior();
        multiple_references_test();
        let _res1 = test(true);   // should return 1
        let _res2 = test(false);  // should return 9
        deprecated_func();
        spec_across_blocks();
    }
}

//# run 0xDEADBEEF::test_module::run_all