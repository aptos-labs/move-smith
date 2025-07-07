//# publish
module 0x1::TestModule {
    struct MyStruct {
        field1: u64,
        field2: bool,
    }

    // Function to test assigning to unused local variables
    public fun test_unused_assignments() {
        let unused_var1 = 42;
        let used_var = 100;
        let unused_var2 = false;
        // Usage of used_var
        assert!(used_var > 50, 42);
        // unused_var1 and unused_var2 are assigned but not used
    }

    // Function to test destructuring of structs in 'let' statements
    public fun test_destructuring(s: MyStruct) {
        let MyStruct { field1, field2 } = s;
        assert!(field1 > 0, 1);
        if (field2) {
            assert!(true, 2);
        }
    }

    // Helper function that calls another function
    public fun helper_function() {
        // Do nothing for now
    }

    // Function that calls helper_function
    public fun caller_function() {
        Self::helper_function();
    }

    // Runner function to execute all tests
    public fun run_tests() {
        Self::test_unused_assignments();
        let s = MyStruct { field1: 10, field2: true };
        Self::test_destructuring(s);
        Self::caller_function();
    }
}

//# run 0x1::TestModule::run_tests --signers 0x0

// Featurres:
// c27969d4f35a7486332f9ed9bcca96fc: Check for assignments to local variables that are never used.
// 4d17e29b8395df65d47bd8c1abe74d5f: Destructure structs in 'let' statements using named field unpacking.
// 19db95b4897be15317116e3fdd089b31: Define functions that call other functions in your Move code.
