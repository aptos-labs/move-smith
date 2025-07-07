// Corrected Move module with proper 'use' statements and module references


//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::assert; // Correctly use std::assert; no 'unbound module' error

    // Testing internal functions and resource access control
    struct SecretResource has key {
        secret_value: u64,
    }

    // Internal function to initialize the resource, should only be accessible within the module
    fun init_secret(s: &signer, val: u64) {
        move_to<SecretResource>(s, SecretResource { secret_value: val });
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
        let sum = 0u64; // 'sum' must be mutable
        let index = 0u64; // 'index' must be mutable
        while (index < 5) {
            // Shadowed variable inside loop: local index
            let index = index + 1;
            sum = sum + index;
        };
        // After loop, 'index' remains 0; 'sum' should be 15
        assert!(sum == 15, 99997);
    }

    // Move wrapper functions to invoke script for comprehensive testing
    public fun run_internal_access_test(s: &signer): u64 {
        init_secret(s, 42);
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

//# script
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

//# end
