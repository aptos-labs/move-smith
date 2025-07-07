//# publish
module 0xCAFE::TestSuite {
    use std::signer;
    use std::vector;

    // Basic utility: simulate an external dependency
    
    
//# publish
    module 0x42::foo {
        struct Foo has key {
            owner: address,
        }

        public fun make_foo(addr: address): Foo {
            Foo { owner: addr }
        }
    }

    // Internal function to test access restrictions
    
    
//# publish
    module 0xCAFE::AccessControl {
        struct SecretData has key {
            value: u64,
        }

        // Internal function to generate secret
        // Move does not support 'internal' functions; instead, use private functions within the module
        // So, define a private function here, and expose only the allowed functions

        fun generate_secret(): u64 {
            999u64
        }

        public fun call_generated_secret(): u64 {
            generate_secret()
        }
    }

    // Resource for holding data
    struct DummyResource has key {
        value: u64,
    }

    // Entry point to test variable shadowing and loops
    public fun run_variable_scope_tests(s: &signer) {
        // Outer scope variable
        let x = 5;
        // Shadowing inside main

        // While loop with shadowing
        let i = 0;
        while (i < 3) {
            let x = i + 10; // shadow x
            // x should be i+10 in this block
            assert!(x >= 10 && x <= 12, 1000);
            i = i + 1;
        };
        // After loop, x should remain 5
        assert!(x == 5, 1001);
    }

    // Function to test that no external function can call internal function
    public fun test_access_restrictions() {
        // Should succeed if called from allowed place
        let _secret_value = AccessControl::call_generated_secret();
    }

    // Function to test anonymous function invocation
    public fun test_anonymous_function(caller: &signer) {
        let f: |unit| struct Foo has key {
            owner: address,
        } = |_| {
            // Call external module function
            let foo_resource = 0x42::foo::make_foo(signer::address_of(caller));
            // move the resource into storage (simulate)
            move_to(&caller, foo_resource);
        };

        // Call the anonymous function
        f(());
    }

    // Function to test resource creation in account
    public fun create_dummy_resource(s: &signer, val: u64) {
        let resource = DummyResource { value: val };
        move_to(&s, resource);
    }

    // Function to test internal visibility restriction
    public fun invoke_internal_secret() {
        // Call internal function within the module
        let _ = InternalFunctions::internal_test();
    }

    // Internal module for private functions
    
//# publish
    module 0xCAFE::InternalFunctions {
        // Move does not support 'internal' visibility; use 'private' functions
        // in the module; so define as private
        fun internal_test(): u64 {
            42u64
        }
    }

    // Entry point for stackless bytecode pipeline test
    public fun run_bytecode_pipeline_tests() {
        // simulate invocation of specific functions
        // (assuming some pipeline mechanism)
        run_test_pipeline();
    }

    // Stub for pipeline execution
    fun run_test_pipeline() {
        // Call several testing functions
        // For illustrative purposes only
        // e.g., calling some functions, no implementation needed here
    }
}


//# run 0xCAFE::TestSuite::run_variable_scope_tests --signers 0xBADD --args

//# run 0xCAFE::TestSuite::test_access_restrictions --signers 0xBADD

//# run 0xCAFE::TestSuite::test_anonymous_function --signers 0xBADD

//# run 0xCAFE::TestSuite::create_dummy_resource --signers 0xBADD --args 123u64

//# run 0xCAFE::TestSuite::invoke_internal_secret --signers 0xBADD

//# run 0xCAFE::TestSuite::run_bytecode_pipeline_tests
