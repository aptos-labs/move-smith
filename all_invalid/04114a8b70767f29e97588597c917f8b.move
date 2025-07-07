//# publish
module 0xA550C0FFEE::TestModule {

    // A struct with multiple fields to test unpacking
    struct MultiFieldStruct has copy, drop, store {
        field1: u64,
        field2: bool,
        field3: vector<u8>,
    }

    // Function to create and publish an instance of MultiFieldStruct
    public fun create_struct(account: &signer): MultiFieldStruct {
        let s = MultiFieldStruct {
            field1: 42,
            field2: true,
            field3: vector::empty<u8>(),
        };
        s
    }

    // Runner function to instantiate struct and do some operation
    public fun run_create_struct(): vector<u8> {
        // For testing, just return an empty vector
        vector::empty<u8>()
    }

    // Function to test filtering module members (simulate by defining functions with specific attributes)
    public fun filtered_function(): bool {
        true
    }
}

//# run
script {
    // Call the runner function in the module
    0xA550C0FFEE::TestModule::run_create_struct();
}

//# run 0xA550C0FFEE::TestModule::create_struct --signers 0x1 --args