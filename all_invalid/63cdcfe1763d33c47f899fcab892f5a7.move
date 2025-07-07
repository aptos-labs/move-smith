//# publish
module 0xTEST environmental_test {
    use std::signer;
    use std::debug;

    // This struct represents a simple token with a value.
    resource struct Token {
        value: u64,
    }

    // Store the token in global storage under the module address
    // Initialize once for testing.
    public fun init_token(account: &signer, initial_value: u64) {
        // Ensure only initialized once.
        if (!exists<Token>(signer::address_of(account))) {
            move_to(account, Token { value: initial_value });
        }
    }

    // Read the token's value through a reference with a specified type domain
    public fun read_token_value<TokenRef: &Token>(token_ref: &TokenRef): u64 {
        token_ref.value
    }

    // Update the token's value via a writer reference with specified type domain
    public fun update_token_value<TokenRef: &mut Token>(token_ref: &mut TokenRef, new_value: u64) {
        token_ref.value = new_value;
    }

    // Runner function to test creation, reading, updating, and environment options
    public fun run_environmental_token_test(account: &signer) {
        // Initialize the token with value 100
        init_token(account, 100);

        // Obtain an immutable reference to the token
        let token_ref = borrow_global::<Token>(signer::address_of(account));

        // Read current value
        let current_value = read_token_value::<&Token>(&token_ref);

        // Log the current value for debugging
        debug::print(&"Initial token value:", &current_value);

        // Obtain a mutable reference to the token
        let mut token_mut_ref = borrow_global_mut::<Token>(signer::address_of(account));

        // Update the token value
        update_token_value::<&mut Token>(&mut token_mut_ref, 200);

        // Verify the update
        let updated_ref = borrow_global::<Token>(signer::address_of(account));
        let updated_value = read_token_value::<&Token>(&updated_ref);

        // Log the updated value
        debug::print(&"Updated token value:", &updated_value);

        // Optionally, perform environment-specific logic here, e.g., check extensions
        // For demonstration, simulate environment extension with dummy behavior
        // (In real usage, replace with actual environment extension options if available)
        // e.g., environment_extension_option(some_option);
    }
}

//# run 0xTEST::environmental_test::run_environmental_token_test --signers 0x123 --args