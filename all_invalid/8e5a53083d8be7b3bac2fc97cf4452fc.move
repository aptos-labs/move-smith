//# publish
module 0x1::EscapeSequenceTest {
    /// Function to test parsing of escape sequences in byte string literals.
    public fun test_escape_sequences() {
        let bytes = b"Hello\nWorld\t\x7F\x00";
        // Expect the bytes to contain the escape sequences interpreted properly.
        // No assertions, just definition to exercise parsing.
        // (This is to ensure the compiler and VM handle escape sequences correctly.)
        ByteSequence(bytes);
    }

    /// Helper resource to hold byte sequences.
    struct ByteSequence has copy, drop {
        data: vector<u8>,
    }

    /// Function to demonstrate explicit dependency declaration.
    /// Assume it depends on another module (simulate dependency).
    public fun dependency_holder() {
        // Dummy call to an external module (simulate dependency).
        // For example, calling module 0x2::DependentModule::do_something
        // Since no real dependency, just a placeholder.
        // use dependency to force dependency analysis
        // Note: No actual requirement, just to trigger dependency parsing.
        // use 0x2::DependentModule;
        // DependentModule::do_something();
    }
}

//# publish
module 0x1::ModuleWithInvoke {
    /// Declare a simple function to be used in multiple invocation styles
    public fun target_function() {
        // No-op
    }
}

module 0x1::TestModule { 
    use 0x1::EscapeSequenceTest;
    use 0x1::ModuleWithInvoke;

    ///>("0x1::EscapeSequenceTest");
    ///>("0x1::ModuleWithInvoke");

    /// Define a runner function to test invocation styles.
    public fun run_target_function() {
        // Assign function to a variable
        let func_ref = ModuleWithInvoke::target_function;

        // Call directly
        ModuleWithInvoke::target_function();

        // Call via variable
        let func = func_ref;
        func();

        // Call via lambda
        let lambda = |:| ModuleWithInvoke::target_function();
        lambda();
    }

    /// Function to test keys function in SimpleMap with duplicate keys
    public fun test_keys_with_duplicates() {
        // Create a map with duplicate keys (simulate using vector of key-value pairs)
        let keys = vector::empty<u64>();
        let values = vector::empty<u64>();

        // Insert duplicate keys
        vector::push_back(&mut keys, 42);
        vector::push_back(&mut values, 1);
        vector::push_back(&mut keys, 42);
        vector::push_back(&mut values, 2);
        vector::push_back(&mut keys, 42);
        vector::push_back(&mut values, 3);

        // Construct the SimpleMap
        let map = simple_map::new<u64, u64>();
        let length = vector::length(&keys);
        let mut i = 0;
        while (i < length) {
            simple_map::insert(&mut map, vector::borrow(&keys, i), vector::borrow(&values, i));
            i = i + 1;
        }

        // Retrieve all keys
        let retrieved_keys = simple_map::keys(&map);
        // No assertions, just exercise the function
    }

    /// Struct representing a ModuleInfo, referencing an unpacked struct.
    struct ModuleInfo has copy, drop {
        name: vector<u8>,
        address: address,
        // Suppose we have a reference to some module
        module_id: vector<u8>,
    }

    /// Example unpacked struct containing module information
    struct ModuleStruct has copy, drop {
        info: ModuleInfo,
        version: u64,
    }

    /// Function demonstrating access to module info within unpacked structs
    public fun access_module_info() {
        let info = ModuleInfo {
            name: b"TestModule",
            address: @0x1,
            module_id: b"ModuleID",
        };
        let module_struct = ModuleStruct {
            info: info,
            version: 1,
        };

        // Access fields
        let name_ref = &module_struct.info.name;
        let addr_ref = &module_struct.info.address;
        let version_ref = &module_struct.version;
        // No assertions, just references to exercise access
    }
}

//# run 0x1::TestModule::run_target_function