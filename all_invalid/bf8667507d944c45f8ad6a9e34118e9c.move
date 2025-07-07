
//# publish
module 0xCAFE::VectorTests {
    use std::signer;
    use std::vector;

    // Struct for testing vector of structs
    struct Item has copy, drop {
        id: u64,
        name: vector<u8>,
    }

    // Function returning an empty vector of u64
    public fun get_empty_u64_vector(): vector<u64> {
        vector::empty<u64>()
    }

    // Function returning an empty vector of signers
    public fun get_empty_signer_vector(): vector<signer> {
        vector::empty<signer>()
    }

    // Function returning an empty vector of Item structs
    public fun get_empty_item_vector(): vector<Item> {
        vector::empty<Item>()
    }

    // Function returning nested vector of u8
    public fun get_nested_u8_vector(): vector<vector<u8>> {
        vector::empty<vector<u8>>()
    }

    // Function returning nested vector of Item
    public fun get_nested_item_vector(): vector<vector<Item>> {
        vector::empty<vector<Item>>()
    }

    // Create and return a vector of u64 with some elements
    public fun create_u64_vector(): vector<u64> {
        let v = vector::empty<u64>();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);
        vector::push_back(&mut v, 3);
        v
    }

    // Create and return a vector of Item with some items
    public fun create_item_vector(): vector<Item> {
        let item1 = Item {id: 101, name: b"item1"};
        let item2 = Item {id: 102, name: b"item2"};
        let v = vector::empty<Item>();
        vector::push_back(&mut v, item1);
        vector::push_back(&mut v, item2);
        v
    }

    // Create nested vector of u8 with inner vectors
    public fun create_nested_u8_vector(): vector<vector<u8>> {
        let inner1 = b"abc";
        let inner2 = b"xyz";
        let outer = vector::empty<vector<u8>>();
        vector::push_back(&mut outer, inner1);
        vector::push_back(&mut outer, inner2);
        outer
    }

    // Create nested vector of Item
    public fun create_nested_item_vector(): vector<vector<Item>> {
        let item1 = Item {id: 201, name: b" nested1"};
        let item2 = Item {id: 202, name: b" nested2"};
        let inner_vec1 = vector::empty<Item>();
        vector::push_back(&mut inner_vec1, item1);
        let inner_vec2 = vector::empty<Item>();
        vector::push_back(&mut inner_vec2, item2);
        let outer = vector::empty<vector<Item>>();
        vector::push_back(&mut outer, inner_vec1);
        vector::push_back(&mut outer, inner_vec2);
        outer
    }

    // Test for numeric addition overflow, should panic
    public fun cause_overflow(): u8 {
        // deliberately cause overflow (255 + 1)
        255u8 + 1u8
    }

    // Resource with move semantics
    struct MyResource has key, store, drop {
        value: u64,
    }

    // Function to create and move resource, then check existence
    public fun create_and_check_resource(account: &signer): bool {
        move_to(account, MyResource {value: 42});
        borrow_global<MyResource>(signer::address_of(account)).is_some()
    }

    // Function to move resource out, then check nonexistent
    public fun move_resource_out(account: &signer): bool {
        let resource = move_from<MyResource>(signer::address_of(account));
        // after move, resource no longer exists
        borrow_global<MyResource>(signer::address_of(account)).is_none()
    }

    // Function to intentionally abort
    public fun aborting_function() {
        abort 0xDEADBEEF;
    }

    // Generic module with no cyclic type parameters
    module <T> 0xCAFE::GenericModule {
        public fun return_default(): T {
            // This function intentionally unimplemented to simulate generic behavior
            // placeholder for generic default value
            abort 42;
        }
    }
}



//# run 0xCAFE::VectorTests::get_empty_u64_vector --signers 0xBEEF


//# run 0xCAFE::VectorTests::get_empty_signer_vector --signers 0xBEEF


//# run 0xCAFE::VectorTests::get_empty_item_vector --signers 0xBEEF


//# run 0xCAFE::VectorTests::get_nested_u8_vector --signers 0xBEEF


//# run 0xCAFE::VectorTests::get_nested_item_vector --signers 0xBEEF


//# run 0xCAFE::VectorTests::create_u64_vector --signers 0xBEEF


//# run 0xCAFE::VectorTests::create_item_vector --signers 0xBEEF


//# run 0xCAFE::VectorTests::create_nested_u8_vector --signers 0xBEEF


//# run 0xCAFE::VectorTests::create_nested_item_vector --signers 0xBEEF


//# run 0xCAFE::VectorTests::cause_overflow --signers 0xBEEF


//# run 0xCAFE::VectorTests::create_and_check_resource --signers 0xBEEF


//# run 0xCAFE::VectorTests::move_resource_out --signers 0xBEEF


//# run 0xCAFE::VectorTests::aborting_function --signers 0xBEEF