//# publish
module 0xCAFE::FriendA {
    // Declare friendship with 0xBADD::FriendB
    public fun declare_friendship() {
        // For testing, we don't need actual logic; just a placeholder
    }
}
//# publish
module 0xBADD::FriendB {
    // Declare friendship with 0xCAFE::FriendA
    public fun declare_friendship() {}
}
//# publish
module 0xCAFE::TestStructs {
    // Define a simple struct with copy and drop abilities
    struct MyStruct has copy, drop {
        value: u64,
    }

    // Define a nested struct with no abilities
    struct NestedStruct {
        inner: u8,
    }
}
//# publish
module 0xCAFE::FeatureTester {
    use 0xCAFE::TestStructs::{MyStruct, NestedStruct};

    // Function to create and return a MyStruct
    public fun create_my_struct(val: u64): MyStruct {
        MyStruct { value: val }
    }

    // Function to create a NestedStruct
    public fun create_nested_struct(): NestedStruct {
        NestedStruct { inner: 42 }
    }

    // Function to test non-native functions and variable unpacking
    public fun test_functions() {
        let s = create_my_struct(100);
        let n = create_nested_struct();

        // Unpack nested struct
        let NestedStruct { inner } = n;

        // Use the structs to prevent compiler warnings about unused variables
        assert!(s.value == 100);
        assert!(inner == 42);
    }

    // Additional function to test that functions in nested modules can be called
    public fun run_all() {
        // Call the declared function in the FriendA module
        0xCAFE::FriendA::declare_friendship();
        // Call functions in the TestStructs module
        let _s = create_my_struct(999);
        let _n = create_nested_struct();
        test_functions();
    }
}
//# run 0xCAFE::FeatureTester::run_all