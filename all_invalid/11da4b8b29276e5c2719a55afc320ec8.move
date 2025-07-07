
//# publish
module 0xCAFE::TestModule {
    // Define a constant with an uppercase name
    const MaxCount: u64 = 100;

    // Define a struct with an uppercase name
    struct MyResource has key, store {
        id: u64,
        name: vector<u8>,
    }

    // Example schema-like struct with uppercase name for fields
    struct DataSchema {
        FieldA: u64,
        FieldB: vector<u8>,
    }

    // Runner function to set up and test the behaviors
    public fun run_tests() {
        let signer_ref = signer;
        // Instantiate the resource
        let resource = MyResource { id: 1, name: b"Test" };
        move_to<MyResource>(&signer_ref, resource);

        // Access constant
        let _max = Self::MaxCount;

        // Create schema-like data
        let schema = DataSchema { FieldA: 42, FieldB: b"Schema" };
    }
}



//# run 0xCAFE::TestModule::run_tests --signers 0xBEEF



//# publish
module 0xCAFE::ResourceModule {
    // Define a resource with uppercase schema name
    struct UserProfile has key, store {
        UserID: u64,
        UserName: vector<u8>,
    }

    // Resource acquisition with 'acquires' syntax
    public fun update_user_name(addr: address, new_name: vector<u8>) acquires UserProfile {
        let profile = borrow_global_mut<UserProfile>(addr);
        profile.UserName = new_name;
    }

    // Runner function that calls update_user_name
    public fun run_update() {
        let addr = @0xBEEF;
        let signer_ref = signer;
        move_to<UserProfile>(&signer_ref, UserProfile { UserID: 1, UserName: b"OldName" });
        Self::update_user_name(addr, b"NewName");
    }
}



//# run 0xCAFE::ResourceModule::run_update --signers 0xBEEF