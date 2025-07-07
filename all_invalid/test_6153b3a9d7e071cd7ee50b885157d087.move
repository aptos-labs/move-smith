//# publish

module 0x10::inventory {

    // A simple resource to hold a token count for each user.
    resource struct Inventory {
        count: u64,
    }

    // Public function to initialize inventory for an account.
    public fun init(signer: &signer) {
        move_to<Inventory>(signer, Inventory { count: 0 });
    }

    // Function to add tokens to an inventory.
    public fun add_tokens(owner: &signer, amount: u64) acquires Inventory {
        let inv_ref = borrow_global_mut<Inventory>(signer_address_of(owner));
        inv_ref.count = inv_ref.count + amount;
    }

    // Function to get the current token count.
    public fun get_count(owner: &signer): u64 acquires Inventory {
        let inv_ref = borrow_global<Inventory>(signer_address_of(owner));
        inv_ref.count
    }
}

//# publish

module 0x10::token {

    use 0x10::inventory;

    struct Token has key {
        value: u64,
    }

    // Create a new token resource under the owner's account
    public fun create(owner: &signer, val: u64) {
        move_to<Token>(owner, Token { value: val });
    }

    // Read the token value
    public fun get_token_value(owner: &address): u64 acquires Token {
        borrow_global<Token>(*owner).value
    }

    // Update (set) the token value
    public fun set_token_value(owner: &signer, val: u64) acquires Token {
        let token_ref = borrow_global_mut<Token>(*signer_address_of(owner));
        token_ref.value = val;
    }

    // Transfer tokens: decrease sender and increase receiver
    public fun transfer(sender: &signer, receiver: &signer, amount: u64) acquires Token, inventory::Inventory {
        let sender_addr = signer_address_of(sender);
        let receiver_addr = signer_address_of(receiver);

        // Update sender's inventory
        inventory::add_tokens(sender, -(amount as i64) as u64); // Note: ensure non-negative in real code
        // Save sender's token value
        let sender_token = borrow_global<Token>(sender_addr);
        // Reduce sender's token value
        let mut sender_token_mut = borrow_global_mut<Token>(sender_addr);
        sender_token_mut.value = sender_token.value - amount;

        // Update receiver's inventory and token
        inventory::add_tokens(receiver, amount);
        // Create token resource under receiver if not exists
        if (!exists<Token>(receiver_addr)) {
            move_to<Token>(receiver, Token { value: amount });
        } else {
            let receiver_token_mut = borrow_global_mut<Token>(receiver_addr);
            receiver_token_mut.value = receiver_token_mut.value + amount;
        }
    }
}

//# run --signers 0xABC, 0xDEF

script {
    use 0x10::inventory;
    use 0x10::token;

    fun main(signer: &signer, receiver: &signer) {
        // Initialize inventories
        inventory::init(signer);
        inventory::init(receiver);

        // Create token for signer with initial value
        token::create(signer, 100);
        // Assert initial token value
        let token_val = token::get_token_value(&signer_address_of(signer));
        assert!(token_val == 100, 0);

        // Add tokens via inventory to simulate value change
        inventory::add_tokens(signer, 50);
        let total_value = inventory::get_count(signer);
        assert!(total_value == 50, 1);

        // Set token value directly to simulate update
        token::set_token_value(signer, 150);
        assert!(token::get_token_value(&signer_address_of(signer)) == 150, 2);

        // Transfer tokens from signer to receiver
        token::transfer(signer, receiver, 50);

        // Verify sender's token reduced
        let sender_token_val = token::get_token_value(&signer_address_of(signer));
        assert!(sender_token_val == 100, 3);

        // Verify receiver's token increased
        let receiver_token_val = token::get_token_value(&signer_address_of(receiver));
        assert!(receiver_token_val == 50, 4);
    }
}