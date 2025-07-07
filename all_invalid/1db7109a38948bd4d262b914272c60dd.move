
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::assert;

    // Testing internal functions and resource access control
    struct SecretResource has key {
        secret_value: u64,
    }

    // Internal function to initialize the resource, should only be accessible within the module
    fun init_secret(s: &signer, val: u64) {
        move_to<SecretResource>(s, SecretResource {secret_value: val});
    }

    // Internal function to get secret value; accessible within module
    fun get_secret(s: &signer): u64 {
        let secret_ref: &SecretResource = borrow_global<SecretResource>(signer::address_of(s));
        secret_ref.secret_value
    }

    // Exposed for test: check if secret can be read within the module
    public fun access_secret(s: &signer): u64 {
        get_secret(s)
    }

    // Function to test shadowed variables and variable bindings
    public fun variable_binding_test() {
        let a = 100u64;
        // Shadowing inside a block
        if (true) {
            let a = a + 1;
        };
        assert!(a == 100, 99999); // Outer 'a' should still be 100
        // Binding variables to expression results
        let (b, c) = f_sum_and_product(5, 10);
        assert!(b == 15 && c == 50, 99998);
    }

    fun f_sum_and_product(x: u64, y: u64): (u64, u64) {
        (x + y, x * y)
    }

    // Function that uses a loop with local variable and variable shadowing
    public fun loop_variable_scope_test() {
        let sum = 0u64;
        let index = 0u64;
        while (index < 5) {
            // Shadowed variable inside loop: local index
            let index = index + 1;
            sum = sum + index;
        };
        // After loop, 'index' should still be 0 (outer), but inside loop, shadowed index increments
        assert!(sum == 15, 99997);
    }

    // Move wrapper functions to invoke script for comprehensive testing
    public fun run_internal_access_test(s: &signer): u64 {
        // Initialize secret resource
        init_secret(s, 42);
        // Access secret internally
        get_secret(s)
    }

    public fun run_variable_binding_test() {
        variable_binding_test()
    }

    public fun run_loop_scope_test() {
        loop_variable_scope_test()
    }

    // Function that tests specification assertions: ensure they match expectations
    public fun spec_assertions() {
        // The outer variable 'a' is 100
        // Inside if block, shadow 'a' and check
        let a = 100u64;
        if (true) {
            let a = a + 10;
            // Inside block, 'a' should be 110
            assert!(a == 110, 99996);
        };
        // Outside block, 'a' should still be 100
        assert!(a == 100, 99995);
    }
}


//# run 0xCAFE::TestModule::run_internal_access_test --signers 0xBADD --args 0xBADD

//# run 0xCAFE::TestModule::run_variable_binding_test

//# run 0xCAFE::TestModule::run_loop_scope_test

//# run 0xCAFE::TestModule::spec_assertions

// Additional script to test comprehensive interactions and visibility

//# run
script {
    use 0xCAFE::TestModule;

    fun main(s: &signer) {
        let secret = TestModule::access_secret(s);
        assert!(secret == 42, 88888);
        // Call other test functions
        TestModule::run_variable_binding_test();
        TestModule::run_loop_scope_test();
        TestModule::spec_assertions();
    }
}


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// caa4ab8a3e36141117c8c50d0a12748d: Specify global or local variables in specifications.
// b97f161fc46919e92f4e2b88ea9444ff: Bind variables to the result of expressions
// 82f755af6a64ca1b7520a8282c6064dc: Define scripts using the 'script' keyword in Move files.
