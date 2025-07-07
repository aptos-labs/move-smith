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
//# run 0xCAFE::TestModule::exec_fn --signers 0xCAFE --args 0xCAFE::DummyFunctions::dummy_fn
//# run 0xCAFE::TestModule::attribute_with_module_name --signers 0xCAFE

// Additional module to define dummy function used as argument
//# publish
module 0xCAFE::DummyFunctions {
    public fun dummy_fn() {
        // do nothing
    }
}