//# publish
module 0x1::TestModule {
    use 0x1::Debug;

    // Declare friend module
    friend 0x2::FriendModule;

    // Structs and enums for testing
    struct SimpleStruct has copy, drop, store {
        value: u64,
    }

    enum MyEnum {
        VariantA,
        VariantB(u8),
        VariantC { x: u64 },
    }

    // Function to test assignment, mutable references, and control flow
    public fun test_assignments_and_control_flow() {
        let mut count = 0u64;

        // While loop counting from 0 to 5
        while (count < 6) {
            count = count + 1;
        }

        // Assert that count reached 6
        assert!(count == 6, 42);
    }

    // Function to test struct and enum creation and pattern matching
    public fun test_struct_enum() {
        let s = SimpleStruct { value: 10 };
        let e1 = MyEnum::VariantA;
        let e2 = MyEnum::VariantB(255);
        let e3 = MyEnum::VariantC { x: 1000 };

        // Pattern match on enum
        let res = match e2 {
            MyEnum::VariantA => 0,
            MyEnum::VariantB(b) => b as u64,
            MyEnum::VariantC { x } => x,
        };
        // Suppress unused variable warning
        Debug::print(&res);
    }

    // Function to test friend module access (assuming friend module is declared)
    public fun test_friend_access() {
        // Potentially access friend module functions if needed
        // (Placeholder, as actual friend access depends on module code)
    }

    // Runner function to execute all tests
    public fun run_all_tests() {
        test_assignments_and_control_flow();
        test_struct_enum();
        test_friend_access();
    }
}

//# run 0x1::TestModule::run_all_tests

//# publish
module 0x2::FriendModule {
    // A simple friend module that can access private members (if any)
    public fun greet() {
        Debug::print(&b"Hello from FriendModule"[..]);
    }
}

//# run 0x2::FriendModule::greet