//# publish
module 0xA1B2::test_module {
    // A simple module to test the main function asserting the result from a test function
    public fun test_value(input: u64): u64 {
        // Compute input + 1, then return fixed value 2 if input == 5, else 0
        if (input == 5) {
            2
        } else {
            0
        }
    }

    public fun main() {
        // Call test_value with 5 and assert that the result is 2
        assert!(test_value(5) == 2, 0);
    }
}

//# run 0xA1B2::test_module::main


//# publish
module 0xDEADBEEF::registry_tests {
    use std::signer;

    // Generic registry to store and manage structs per account
    struct Registry<F: store+copy> has key, store {
        data: F
    }

    // Save a struct instance into the account’s registry
    public fun save_item<F: store+copy>(owner: &signer, item: F) {
        move_to<Registry<F>>(owner, Registry { data: item });
    }

    // Remove the struct instance from the account’s registry and return it
    public fun remove_item<F: store+copy>(addr: address): F acquires Registry {
        let Registry { data } = move_from<Registry<F>>(addr);
        data
    }

    // Check if a struct instance exists for the account
    public fun item_exists<F: store+copy>(addr: address): bool {
        exists<Registry<F>>(addr)
    }

    // Retrieve a reference to the stored struct instance
    public fun get_item<F: store+copy>(addr: address): F acquires Registry {
        borrow_global<Registry<F>>(addr).data
    }
}

//# publish
module 0xDEADBEEF::struct_tests {
    use std::signer;
    use 0xDEADBEEF::registry_tests;

    // Define two different structs to test storage
    struct StructAlpha has key, store, copy {
        alpha_value: u64
    }

    struct StructBeta has key, store, copy {
        beta_value: u8
    }

    // Function to test storing, confirming, retrieving, and removing structs
    public fun perform_struct_tests(owner: &signer, store_alpha: bool): bool {
        let owner_addr = signer::address_of(owner);

        // Store StructAlpha if needed
        if (!exists<StructAlpha>(owner_addr)) {
            let alpha = StructAlpha { alpha_value: 42 };
            registry_tests::save_item(owner, alpha);
        }

        // Store StructBeta if needed
        if (store_alpha) {
            let beta = StructBeta { beta_value: 7 };
            registry_tests::save_item(owner, beta);
        }

        // Check existence
        assert!(registry_tests::item_exists<StructAlpha>(owner_addr));
        assert!(registry_tests::item_exists<StructBeta>(owner_addr));

        // Retrieve and verify data
        let alpha_retrieved = registry_tests::get_item<StructAlpha>(owner_addr);
        assert!(alpha_retrieved.alpha_value == 42);

        let beta_retrieved = registry_tests::get_item<StructBeta>(owner_addr);
        assert!(beta_retrieved.beta_value == 7);

        // Remove stored structs
        let _ = registry_tests::remove_item<StructAlpha>(owner_addr);
        let _ = registry_tests::remove_item<StructBeta>(owner_addr);

        // Confirm removal
        assert!(!registry_tests::item_exists<StructAlpha>(owner_addr));
        assert!(!registry_tests::item_exists<StructBeta>(owner_addr));

        true
    }
}

//# run 0xDEADBEEF::struct_tests::perform_struct_tests --signers 0xDEADBEEF --args true

//# run 0xDEADBEEF::struct_tests::perform_struct_tests --signers 0xDEADBEEF --args false


//# run
script {
    fun main() {
        // Test that a loop with an immediate break executes without errors
        loop {
            break;
        }
    }
}