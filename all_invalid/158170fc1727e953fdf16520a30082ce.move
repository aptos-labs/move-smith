
//# publish
module 0xCAFE::FriendModule {
    use std::debug;

    // Declare a friend module via a special comment or annotation (simulated)
    // For this test, we'll simulate "friend" access by defining certain functions.

    public fun access_private_data(data: &0xCAFE::MyModule::S): (u32, u32) {
        (data.x, data.y)
    }
}


//# publish
module 0xCAFE::MainModule {
    use 0xCAFE::MyModule;
    use 0xCAFE::FriendModule;

    // Simulate a deprecated module access
    // Suppose `std::vector` is deprecated; generate a diagnostic message
    use std::vector; // deprecated: vector

    // Diagnostic: "Using deprecated module `std::vector`"
    // (Note: In actual implementation, diagnostics are emitted by the compiler. Here we mimic the action through comments.)

    public fun declare_package() {
        let package_name = b"TestPackage";
        let _pkg_id = package_name; // placeholder for package declaration
        // Return nothing
    }

    public fun test_deprecated_module() {
        // Should emit a diagnostic message about using deprecated std::vector
        // For the test, just invoke vector functions
        let v: vector<u8> = vector::empty();
        let _ = vector::push_back(&mut v, 42u8);
        // use vector: internal usage to test diagnostics
    }

    public fun test_friend_access(s: &0xCAFE::MyModule::S): (u32, u32) {
        // Access private data via friend module
        let (x, y) = FriendModule::access_private_data(s);
        (x, y)
    }

    public fun test_module_and_package_declaration(): (u8, u8) {
        // Declare module and package; simulate declaration
        // Normally, Move modules are declared at top-level, but here we simulate declaration logic
        let module_name = b"SampleModule";
        let package_name = b"SamplePackage";

        // Dummy return values
        (1u8, 0u8)
    }

    // Function to be executed to run all tests
    public fun run_tests() {
        // Declare package
        declare_package();

        // Test deprecated module usage
        test_deprecated_module();

        // Create a sample data structure to test friend access
        let s = S {x: 100, y: 200};
        let (_x, _y) = test_friend_access(&s);
        
        // Test module/package declaration
        let (_a, _b) = test_module_and_package_declaration();
    }
}


//# run 0xCAFE::MainModule::run_tests

// Featurres:
// cf3cd246321e8216b12a34e0e18a1335: Declare another module as a 'friend' module to grant it special access privileges
// cc34729450c4cd057130f86dfbdd72b3: Be warned when using deprecated modules via diagnostic messages
// 57fa136e7175a1a531a1a8ea1121eae4: Define modules and package definitions in Move source code.
