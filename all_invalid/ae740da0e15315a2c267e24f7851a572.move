//# publish
module 0xCAFE::TestModule {
    // Use import statements to test module member importing
    // Note: 'use' statements are only valid at the module scope, not inside functions
    use 0xCAFE::HelperModule::{get_value, set_value};

    // A public function to test package-level boundary enforcement
    public fun package_visible_fun() {
        // Internal logic (nothing to do here)
    }

    // A friend function to test access beyond package boundary
    friend fun friend_function() {
        // This function can access private members if any
    }

    // Helper struct to test mutability and moves
    struct Data {
        value: u64,
        flag: bool,
    }

    // A public function to create and manipulate Data instances
    public fun create_data(): Data {
        Data { value: 42, flag: false }
    }

    // A function to mutate the value field
    public fun update_value(data: &mut Data, new_value: u64) {
        data.value = new_value;
    }
}

//# publish
module 0xCAFE::HelperModule {
    // Helper functions to test import and package boundaries
    public fun get_value(data: &0xCAFE::TestModule::Data): u64 {
        data.value
    }
    public fun set_value(data: &mut 0xCAFE::TestModule::Data, val: u64) {
        data.value = val;
    }

    // The module can include private functions as well
}

//# run
script {
    fun main() {
        // Create an instance of Data
        let data = 0xCAFE::TestModule::create_data();

        // Import specific member functions using 'use' at module scope (already done above)
        // So just call the imported functions directly

        // Read value using imported function
        let val = get_value(&data);
        // We expect val to be 42

        // Create a mutable copy of data for mutation
        let mut data_mut = data;

        // Update the value via helper function
        set_value(&mut data_mut, 100);

        // Access the value after mutation
        let new_val = get_value(&data_mut);
        // Expect new_val to be 100

        // Enforce package boundary: call package_visible_fun from outside module (should be allowed)
        0xCAFE::TestModule::package_visible_fun();

        // Test friend function (accessible within the same package)
        0xCAFE::TestModule::friend_function();

        // Now test struct move semantics and multiple moves
        let data2 = 0xCAFE::TestModule::create_data();

        // Do multiple moves of data2
        let val1 = data2.value;
        // Move data2 out, cannot use data2 after move, but can access fields before move
        let data2_moved = data2;

        // Access the field of moved data
        let val2 = data2_moved.value;

        // Create another Data instance
        let data3 = 0xCAFE::TestModule::create_data();

        // Obtain mutable reference to a field
        let data_ref = &mut data3;

        // Mutate through the reference
        data_ref.value = 999;

        // Access via another variable
        let val3 = data3.value;
        // Expect val3 to be 999
    }
}

// Featurres:
// 856cee270806f36c7f5a492dd5982c36: Import specific members from modules using the 'use' statement
// 0ef6c610c35853f3409aab0a62c7da63: Enforce package-level boundaries for friend and package-visible functions.
// 55401a24ffdc0ca1f02ebd60ec152d5f: Test that taking a mutable reference to a field after multiple moves of a struct (using let bindings) does not prevent access to the original value through another variable.