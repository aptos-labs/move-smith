//# publish
module 0xA11C::RegistryTest {
    use std::signer;

    // Generic registry struct to associate any copy + store type with an account
    struct Registry<F: store+copy> has key, store {
        value: F
    }

    public fun store_value<F: store+copy>(owner: &signer, val: F) {
        move_to<Registry<F>>(owner, Registry { value: val });
    }

    public fun remove_value<F: store+copy>(addr: address): F acquires Registry {
        let Registry { value } = move_from<Registry<F>>(addr);
        value
    }

    public fun value_exists<F: store+copy>(addr: address): bool {
        exists<Registry<F>>(addr)
    }

    public fun get_value<F: store+copy>(addr: address): F acquires Registry {
        borrow_global<Registry<F>>(addr).value
    }

    // Runner function to test storing, retrieving, verifying, and removing a custom struct
    public fun run_test_structs(owner: &signer) {
        // Define two custom structs dynamically (as type parameters)
        // Store and verify MyStructA (with u128 field)
        // and MyStructB (with bool field)
        // Note: In move, types are statically defined, so we will define them outside
        
        // We manually specify the types here for testing
        // (In real code, you'd test with actual types; for the test, we'll just do two separate blocks)

        // Store MyStructA
        let val_a = MyStructA { data: 123456789u128 };
        store_value(&owner, val_a);
        assert!(value_exists::<MyStructA>(signer::address_of(owner)),  "MyStructA should exist after storing");
        let retrieved_a = get_value::<MyStructA>(signer::address_of(owner));
        assert!(retrieved_a.data == 123456789u128, "Retrieved MyStructA data mismatch");
        // Remove
        let removed_a = remove_value::<MyStructA>(signer::address_of(owner));
        assert!(removed_a.data == 123456789u128, "Removed MyStructA data mismatch");
        assert!(!value_exists::<MyStructA>(signer::address_of(owner)), "MyStructA should not exist after removal");

        // Store MyStructB
        let val_b = MyStructB { flag: true };
        store_value(&owner, val_b);
        assert!(value_exists::<MyStructB>(signer::address_of(owner)), "MyStructB should exist after storing");
        let retrieved_b = get_value::<MyStructB>(signer::address_of(owner));
        assert!(retrieved_b.flag, "Retrieved MyStructB flag should be true");
        // Remove
        let removed_b = remove_value::<MyStructB>(signer::address_of(owner));
        assert!(removed_b.flag, "Removed MyStructB flag should be true");
        assert!(!value_exists::<MyStructB>(signer::address_of(owner)), "MyStructB should not exist after removal");
    }

    // Define example structs used in the test
    struct MyStructA has key, store, copy {
        data: u128
    }
    struct MyStructB has key, store, copy {
        flag: bool
    }
}

//# run 0xA11C::RegistryTest::run_test_structs --signers 0xA11C

//# publish
module 0xA11C::ConditionalReturn {
    // Function that always returns 100 to test branch execution
    public fun get_value(): u64 {
        if (true) {
            return 100;
        }
        0
    }
}

//# run
script {
    use 0xA11C::ConditionalReturn;

    fun main() {
        assert!(ConditionalReturn::get_value() == 100, 101);
    }
}