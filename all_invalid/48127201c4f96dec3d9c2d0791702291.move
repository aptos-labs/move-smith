
//# publish
module 0xDEAD::ScopeAndVisibilityTest {
    use std::signer;

    // Internal resource with private access (module only)
    struct SecretResource {
        data: u64,
    }

    // Public resource with no restrictions
    struct PublicResource {
        count: u64,
    }

    // Initialize resources for a signer
    public fun init_resources(account: &signer) {
        move_to<SecretResource>(account, SecretResource { data: 42 });
        move_to<PublicResource>(account, PublicResource { count: 0 });
    }

    // Internal function to mutate secret resource
    fun increment_secret(secret_ref: &mut SecretResource) {
        secret_ref.data = secret_ref.data + 1;
    }

    // Public function to access secret resource within the module
    public fun access_secret_within_module(account: &signer): u64 {
        let secret_ref: &mut SecretResource = borrow_global_mut<SecretResource>(signer::address_of(account));
        increment_secret(secret_ref);
        secret_ref.data
    }

    // Attempt outside access (should be invalid; for test, just noted as comment)
    // Note: From outside, this should not compile. Access restrictions are enforced by compiler.
    // public fun external_access_secret(account: &signer): u64 {
    //     let secret_ref: &mut SecretResource = borrow_global_mut<SecretResource>(signer::address_of(account));
    //     increment_secret(secret_ref);
    //     secret_ref.data
    // }

    // Function to modify public resource (accessible anywhere)
    public fun increment_public(account: &signer) {
        let pub_ref: &mut PublicResource = borrow_global_mut<PublicResource>(signer::address_of(account));
        pub_ref.count = pub_ref.count + 1;
    }

    // Internal function with variable shadowing in nested blocks
    fun variable_shadowing_example() {
        let x = 5;
        // Shadowing in inner block
        {
            let x = x + 10; // inner shadow
            while (x < 20) {
                let y = x * 2; // local variable in loop
                x = x + 2; // update inner x
            };
            // After loop, inner x retains last value
            // Shadowed x goes out of scope here
        };
        // Outer x remains unchanged by inner shadow
    }

    // External entry point calling internal functions and setting variables
    public fun run_scope_tests(account: &signer) {
        init_resources(account);
        let secret_value = access_secret_within_module(account);
        // Mutate secret resource
        let secret_value_after = access_secret_within_module(account);
        // Mutate public resource
        increment_public(account);
        // Run variable shadowing example
        variable_shadowing_example();
    }
}


//# run 0xDEAD::ScopeAndVisibilityTest::run_scope_tests --signers 0xBADD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
