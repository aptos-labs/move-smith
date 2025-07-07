//# publish
module 0xABC::TestModule {
    // Constant definition
    const MAX_LIMIT: u64 = 1000;

    // Struct definitions
    struct AccountInfo has copy, drop, store {
        address: address,
        balance: u64,
    }

    struct UserData has copy, drop, store {
        id: u64,
        name: vector<u8>,
    }

    // Function to create a new account info
    public fun create_account_info(addr: address, bal: u64): AccountInfo {
        AccountInfo { address: addr, balance: bal }
    }

    // Function to create user data
    public fun create_user_data(id: u64, name: vector<u8>): UserData {
        UserData { id, name }
    }

    // Runner function to initialize module data
    public fun initialize() {
        // Dummy initializer
    }
}

//# run 0xABC::TestModule::initialize

//# publish
module 0xDEF::NestedAttributes {
    use 0xABC::TestModule;

    // Function that returns nested attribute collections (simulate with vector of attributes)
    public fun get_attributes(): vector<attribute::Attribute> {
        // In Move, attributes are not first-class; simulate as vector of key-value pairs
        let mut attrs = vector::empty<attribute::Attribute>();
        // Flatten nested attribute collections into a single list
        vector::push_back(&mut attrs, attribute::create_attribute(b"author", b"Alice"));
        vector::push_back(&mut attrs, attribute::create_attribute(b"version", b"1.0"));
        vector::push_back(&mut attrs, attribute::create_attribute(b"status", b"active"));
        attrs
    }

    // Runner function to test attribute flattening
    public fun run_attributes() {
        let attrs = get_attributes();
        // No assertions required; just exercise the attribute collection
    }
}

//# run 0xDEF::NestedAttributes::run_attributes

//# publish
module 0x123::StructCollisions {
    use 0xABC::TestModule;

    // Attempt to define two structs with the same name to test duplicate struct detection
    struct DuplicateStruct has copy, drop, store {
        field: u64,
    }

    // This second struct with the same name should cause a compile error if duplicated within the same module
    // Uncommenting below would trigger duplicate struct error; this is to test enforcement
    /*
    struct DuplicateStruct has copy, drop, store {
        other_field: u64,
    }
    */

    // Valid separate struct
    struct UniqueStruct has copy, drop, store {
        data: vector<u8>,
    }

    // Runner function to instantiate structs
    public fun run_structs() {
        let _dup = DuplicateStruct { field: 10 }; // test instantiation
        let _unique = UniqueStruct { data: vector::empty<u8>() };
    }
}

//# run 0x123::StructCollisions::run_structs

// Featurres:
// 070c1100f7e02cc1cacd103bd588767b: Flatten nested attribute collections into a single attribute list.
// cbf9c66be899e3d28ae69bf46264946a: Define a module with various members including functions, constants, structs, and schema specifications.
// 9ed516af7a96fbc4dc354976e0781049: Prevent duplicate struct definition by enforcing unique struct names within a module.
