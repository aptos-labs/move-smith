
//# publish
module 0xCAFE::CapabilityTest {
    use std::signer;
    use std::vector;

    // Define a struct with key ability to test automatic acquires inference 
    struct KeyedResource has key, store {
        id: u64,
        data: u8,
    }

    // Function to create and move resource to caller's account
    public fun create_resource(s: signer, id: u64, data: u8) {
        let res = KeyedResource { id, data };
        move_to<KeyedResource>(&s, res);
    }

    // Function to update resource - no explicit acquires annotations, relying on compiler inference
    public fun update_resource(s: signer, new_data: u8) {
        let addr = signer::address_of(&s);
        let res_mut: &mut KeyedResource = borrow_global_mut<KeyedResource>(addr);
        res_mut.data = new_data;
    }

    // Function to read resource data
    public fun read_resource(s: signer): u8 {
        let addr = signer::address_of(&s);
        let res_ref: &KeyedResource = borrow_global<KeyedResource>(addr);
        res_ref.data
    }

    // A struct with multiple type parameters and ability constraints 
    struct MultiParamStruct<T: copy + drop, U: store> has drop {
        t_field: T,
        u_field: U,
    }

    // Function to create MultiParamStruct, convert ability constraints into a vector of strings (set representation) and return its size
    // This simulates handling ability sets (Move abilities) but only in type system, so we fake set rep by string vectors
    public fun type_param_ability_info<T: copy + drop, U: store>(): u64 {
        let abilities = vector::empty<vector<u8>>();
        vector::push_back(&mut abilities, b"copy");
        vector::push_back(&mut abilities, b"drop");
        vector::push_back(&mut abilities, b"store");
        // Return number of unique abilities represented
        (vector::length(&abilities) as u64)
    }

    // Two unique functions with distinct names to test their coexistence
    public fun first_function(): u64 {
        42
    }

    public fun second_function(): u64 {
        24
    }

    // Function that returns a lambda capturing a copied variable (u8) with correct abilities included 
    public fun lambda_with_capture(x: u8): |u8|u8 {
        // Capture x, which has 'copy + drop + store' by default abilities for u8
        let closure = |y: u8| {
            x + y
        };
        closure
    }

    // A function demonstrating missing ability capture detection by capturing a signer which can't be copied or dropped
    public fun closure_capture_signer(s: signer): |u8|u8 {
        // Capture signer s - signer is neither copy nor drop
        // This lambda will only be used internally here to test ability constraints
        let closure = |_y: u8| {
            // Unable to use signer here, so just return fixed number
            0u8
        };
        closure
    }
}



//# run 0xCAFE::CapabilityTest::create_resource --signers 0xBEEF --args 123u64 10u8



//# run 0xCAFE::CapabilityTest::read_resource --signers 0xBEEF



//# run 0xCAFE::CapabilityTest::update_resource --signers 0xBEEF --args 42u8



//# run 0xCAFE::CapabilityTest::read_resource --signers 0xBEEF



//# run 0xCAFE::CapabilityTest::type_param_ability_info



//# run 0xCAFE::CapabilityTest::first_function



//# run 0xCAFE::CapabilityTest::second_function



//# run 0xCAFE::CapabilityTest::lambda_with_capture --args 7u8



//# run 0xCAFE::CapabilityTest::closure_capture_signer --signers 0xBEEF
