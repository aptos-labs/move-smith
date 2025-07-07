//# publish
module 0xDEADBEEF::Registry {
    use std::signer;
    use std::vector;

    // Registry for custom structs: associate with an account for storage
    resource struct DataRegistry {
        entries: vector<(vector<u8>, vector<u8>)>, // (type_id, serialized struct)
    }

    // Initialize registry for an account
    public fun init_registry(account: &signer) {
        if (!exists<DataRegistry>(signer::address_of(account))) {
            move_to(account, DataRegistry { entries: vector::empty() });
        }
    }

    // Store a custom struct with a type_id
    public fun store_struct(account: &signer, type_id: vector<u8>, serialized_struct: vector<u8>) {
        let registry = borrow_global_mut<DataRegistry>(signer::address_of(account));
        vector::push_back(&mut registry.entries, (type_id, serialized_struct));
    }

    // Check existence of a struct by type_id
    public fun exists_struct(account_addr: address, type_id: vector<u8>): bool {
        if (!exists<DataRegistry>(account_addr)) {
            return false;
        }
        let registry = borrow_global<DataRegistry>(account_addr);
        let len = vector::length(&registry.entries);
        let mut i = 0;
        while (i < len) {
            let (stored_type_id, _) = &vector::borrow(&registry.entries, i);
            if (vector::equals(stored_type_id, &type_id)) {
                return true;
            }
            i = i + 1;
        }
        false
    }

    // Retrieve a struct's serialized data by type_id (returns option)
    public fun retrieve_struct(account_addr: address, type_id: vector<u8>): option<vector<u8>> {
        if (!exists<DataRegistry>(account_addr)) {
            return option::none();
        }
        let registry = borrow_global<DataRegistry>(account_addr);
        let len = vector::length(&registry.entries);
        let mut i = 0;
        while (i < len) {
            let (stored_type_id, serialized_struct) = &vector::borrow(&registry.entries, i);
            if (vector::equals(stored_type_id, &type_id)) {
                return option::some(vector::copy(serialized_struct));
            }
            i = i + 1;
        }
        option::none()
    }

    // Remove a struct by type_id
    public fun remove_struct(account: &signer, type_id: vector<u8>) {
        let registry = borrow_global_mut<DataRegistry>(signer::address_of(account));
        let len = vector::length(&registry.entries);
        let mut i = 0;
        while (i < len) {
            let (stored_type_id, _) = &vector::borrow(&registry.entries, i);
            if (vector::equals(stored_type_id, &type_id)) {
                vector::remove(&mut registry.entries, i);
                break;
            }
            i = i + 1;
        }
    }
}

// Define custom structs with different type parameters and modifiers
//# publish
module 0xDEADBEEF::CustomStructs {
    use std::bvector;

    // Basic struct with a type parameter
    struct Container<T> {
        value: T,
    }

    // Struct with a user-defined modifier (simulate via different struct names)
    struct ModifierA<T> {
        payload: T,
        modifier: bool,
    }

    // Function to create and serialize Container
    public fun create_container<T>(value: T): vector<u8> {
        // Serialization logic (placeholder, in real scenario we'd serialize properly)
        // Here, just placeholder returning empty vector
        vector::empty()
    }

    // Function to create and serialize ModifierA
    public fun create_modifier_a<T>(payload: T, modifier_flag: bool): vector<u8> {
        // Serialization placeholder
        vector::empty()
    }
}

// Test script to check storage, retrieval, existence, removal, and complex control flow
//# run
script {
    use 0xDEADBEEF::Registry;
    use 0xDEADBEEF::CustomStructs;

    fun main() {
        let account = signer::borrow_address();

        // Initialize registry
        Registry::init_registry(&signer::borrow_signer());

        // Define type identifiers for structs
        let type_id_container = b"Container<u64>".to_vec();
        let type_id_modifierA = b"ModifierA<bool>".to_vec();

        // Create custom structs
        let container_data = CustomStructs::create_container(42u64);
        let modifier_data = CustomStructs::create_modifier_a(true, true);

        // Store structs
        Registry::store_struct(&signer::borrow_signer(), vector::clone(&type_id_container), container_data);
        Registry::store_struct(&signer::borrow_signer(), vector::clone(&type_id_modifierA), modifier_data);

        // Verify existence
        assert(Registry::exists_struct(account, vector::clone(&type_id_container)), 0);
        assert(Registry::exists_struct(account, vector::clone(&type_id_modifierA)), 0);
        // Check non-existing type
        assert(!Registry::exists_struct(account, b"NonExistent".to_vec()), 0);

        // Retrieve and verify data
        let retrieved_container = Registry::retrieve_struct(account, vector::clone(&type_id_container));
        let retrieved_modifier = Registry::retrieve_struct(account, vector::clone(&type_id_modifierA));
        // We can add assertions if proper serialization was implemented

        // Remove one struct
        Registry::remove_struct(&signer::borrow_signer(), vector::clone(&type_id_container));

        // Verify removal
        assert(!Registry::exists_struct(account, vector::clone(&type_id_container)), 0);
        assert(Registry::exists_struct(account, vector::clone(&type_id_modifierA)), 0);
    }
} // end script