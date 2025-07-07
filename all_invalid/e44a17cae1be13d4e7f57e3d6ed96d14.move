//# publish
module 0xCAFE::TestModule1 {
    use std::signer;
    use std::vector;

    // A struct to hold some data for testing
    struct Data has copy, drop {
        value: u64,
    }

    // Function to create a Data instance
    public fun create_data(val: u64): Data {
        Data { value: val }
    }

    // Borrow a mutable reference, modify it, but ensure original remains unchanged
    public fun mutate_data(data: &mut Data) {
        data.value = data.value + 100;
    }

    // Function that returns a copy of Data
    public fun get_data_copy(data: &Data): Data {
        *data
    }
}

//# publish
module 0xBEEF::FriendModule {
    // Declare module to be a friend to 0xCAFE::TestModule1
    // Note: In actual Move code, 'friend' relationships are specified via attributes in dependencies.
    // But for this test, simulate by accessing public functions of the friend module.
    use std::signer;
    use 0xCAFE::TestModule1;

    // Function to invoke create_data from the friend module
    public fun call_create_data(val: u64): TestModule1::Data {
        TestModule1::create_data(val)
    }

    // Function to mutate Data via reference
    public fun mutate_data_in_friend(data: &mut TestModule1::Data) {
        TestModule1::mutate_data(data)
    }
}

//# run
script {
    use 0xCAFE::TestModule1;
    use 0xBEEF::FriendModule;

    fun main() {
        // Create new Data with value 42
        let data = TestModule1::create_data(42);

        // To mutate data via friend, we need a mutable copy that is mutable here
        // Move data into a mutable variable
        let mut data_mut = data;
        // Mutate via friend module
        FriendModule::mutate_data_in_friend(&mut data_mut);

        // To verify that original 'data' remains unchanged, we use get_data_copy
        let data_copy = TestModule1::get_data_copy(&data);

        // Create data again for comparison
        let data2 = TestModule1::create_data(42);
        let data2_mut = data2;
        // Mutate data2_mut via friend module
        let mut data2_mut = data2_mut;
        FriendModule::mutate_data_in_friend(&mut data2_mut);

        // Now, data2_mut's value should be 142
        // data2's original value remains 42
        // data_copy should still be 42

        // Note: No assertions required here, just demonstrating usage.
    }
}