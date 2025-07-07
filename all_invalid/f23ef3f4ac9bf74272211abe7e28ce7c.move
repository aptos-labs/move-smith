//# publish
module 0xCAFE::TestModule {
    // Test importing with 'use'
    use 0xCAFE::InnerModule as IM;
    use 0xCAFE::OuterModule;

    // Public resource to use for storage
    resource struct Counter {
        value: u64,
    }

    // Function to initialize resource
    public fun init_counter(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    // Generic function accepting a function argument
    public fun run_with_function<F: &fun()>(f: F) {
        f();
    }

    // Attribute with module name
    #[test]
    public fun test_imports() {
        // Call a function from imported alias
        IM::inner_function();
        OuterModule::outer_function();
    }

    // Function with generic function parameter
    public fun exec_fn<F: &fun()>(func: F) {
        move_with_borrow(func);
    }

    // Internal helper that accepts the function
    fun move_with_borrow<F: &fun()>(f: F) {
        f();
    }

    // Function to demonstrate attribute with valid module identifier
    #[test]
    public fun attribute_with_module_name() {
        // do nothing, just testing attribute recognition
    }
}

//# run 0xCAFE::TestModule::test_imports --signers 0xCAFE
//# run 0xCAFE::TestModule::exec_fn --signers 0xCAFE --args 0xCAFE::TestModule::dummy_fn
//# run 0xCAFE::TestModule::attribute_with_module_name --signers 0xCAFE

// Additional module to define dummy function used as argument
//# publish
module 0xCAFE::DummyFunctions {
    public fun dummy_fn() {
        // do nothing
    }
}

//please note: The above test demonstrates:
    // 1. Use statement with alias (use 0xCAFE::InnerModule as IM)
    // 2. Generic function accepting a function argument (`run_with_function`)
    // 3. Attribute with module identifier ([# attribute_with_module_name])
    // 4. Script commands invoking the functions with correct signer and argument setup

// Featurres:
// 14991b7ba6a9c075cb9057501327b151: Use the 'use' statement to import modules or give them aliases.
// e003a7dfb459df4e1f343a32890d3391: Define generic function types that accept functions as arguments.
// 618ec165be600d3844d66fbef3466d89: Handle attributes with valid module identifiers or names, ensuring correct association of code locations with modules.
