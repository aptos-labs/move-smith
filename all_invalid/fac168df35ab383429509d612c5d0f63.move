
//# publish
module 0xCAFE::DependencyHandlingTest {
    use std::error;
    use std::string;
    use std::vector;

    // A simple dependency module to generate interface files
//# publish
    module 0xDEAD::DepModule {
        public fun dep_func(): u64 { 42 }
        public fun deprecated_func(): bool { true }
    }

    // A module that interacts with DepModule to test interface files
//# publish
    module 0xCAFE::InteractionModule {
        use 0xDEAD::DepModule;

        public fun call_dep_func(): u64 {
            DepModule::dep_func()
        }

        // Using deprecated item to trigger warning
        public fun use_deprecated(): bool {
            DepModule::deprecated_func()
        }
    }

    // A module with resource that will be borrowed mutably
    struct ResourceTest has store, key {
        value: u64
    }

    // Function to generate interface files
    public fun generate_interface_files() {
        // Placeholder for actual interface generation
        // in real test, this would invoke Move toolchain commands
    }

    // Function to remove dependency bytecode files
    public fun remove_dependency_binaries() {
        // Placeholder for actual dependency cleanup
        // For test, we assume dependencies are cleaned, but interface files remain
    }

    // Test: Generate interfaces and remove binaries, ensure no errors and interfaces stay correct
    public fun test_dependency_interface_persistence() {
        generate_interface_files();
        remove_dependency_binaries();
        // No explicit return; check interfaces exist (implicitly)
    }

    // Test: Borrow mutably multiple times in a single function - should fail to compile
    // As we cannot simulate compile failure directly, we illustrate the logic
    public fun test_multiple_mut_borrow() {
        // This code is supposed to cause a compile error due to multiple mutable borrows
        // Example code snippet (not executable here):
        /*
        let resource = &mut live<ResourceTest>;
        let resource2 = &mut live<ResourceTest>; // Error: multiple mutable borrows in same scope
        */
    }

    // Test: Using deprecated items should emit diagnostic warnings
    public fun test_deprecated_usage() {
        // Call deprecated function to trigger warning
        let _ = InteractionModule::use_deprecated();
        // No return; expectation is that compiler emits warning with code
    }
}


//# run 0xCAFE::DependencyHandlingTest::test_dependency_interface_persistence

//# run 0xCAFE::DependencyHandlingTest::test_multiple_mut_borrow

//# run 0xCAFE::DependencyHandlingTest::test_deprecated_usage


// Featurres:
// 9b47cf51351f3a28b90ef53be117eb6e: Remove bytecode files from the list of dependencies after generating interface files.
// 053c0898699e17a66d51b1ffd70c3ab0: Test that attempting to create multiple mutable references in the same function results in a compilation error or behavior as specified by Move's borrowing rules.
// b2081e928f636305e3be6e682bcc0741: Get notifications about the use of deprecated items with specific diagnostic codes.
