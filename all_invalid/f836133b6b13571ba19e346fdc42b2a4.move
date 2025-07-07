// Test case to verify consecutive mutable borrows, returning a custom address, and summing multiple arguments


//# publish
module 0xBADD::TestModule {
    use std::vector;

    // Struct to test mutable borrows and updates
    struct Data has store {
        a: u64,
        b: u64,
    }

    // A struct to represent a spanned (location-aware) numerical address for analysis purposes
    struct NumericalAddress has copy, drop {
        addr: u64,
        location_info: vector<u8>,
    }

    // Function to test consecutive mutable borrows with computations
    public fun test_borrows_and_updates(data: &mut Data): u64 {
        let value1 = {
            let data_ref: &mut Data = data;
            data_ref.a = data_ref.a + 10;
            data_ref.a
        };

        let value2 = {
            let data_ref: &mut Data = data;
            data_ref.b = data_ref.b + 20;
            data_ref.b
        };

        let sum = value1 + value2;
        // At the end, update the fields again for cumulative effect
        data.a = data.a + sum;
        data.b = data.b + sum;
        sum
    }

    // Function to return a spanned (location-aware) address
    public fun get_spanned_address(): NumericalAddress {
        let addr_value = 0xFEED_BEEF_DEAD_BEEF; // Example address
        let location_info = vector::empty<u8>();
        // Assume some location info is added here for analysis
        // For simplicity, just push some bytes
        vector::push_back(&mut location_info, 0x01u8);
        vector::push_back(&mut location_info, 0x02u8);
        NumericalAddress { addr: addr_value, location_info }
    }

    // Function to sum 65 u64 arguments
    public fun sum_65_args(args: vector<u64>): u64 {
        let total = 0u64;
        let count = vector::length(&args);
        let i = 0;
        while (i < count) {
            let current = *vector::borrow(&args, i);
            // Update total
            total = total + current;
            // Increment index
            i = i + 1;
        };
        total
    }

    // Runner that demonstrates all features
    public fun run_tests() {
        // Remove the 'let data = ...' which implies implicit drop of the borrowed value
        // Instead, directly borrow mutably in the function call
        let data = &mut Data {a: 1, b: 2};
        let sum_borrows = Self::test_borrows_and_updates(data);
        let address = Self::get_spanned_address();
        
        // Prepare 65 arguments for sum
        let args_vec = vector::empty<u64>();
        let j = 0;
        let j_local = 0; // assign a mutable variable for loop counter
        while (j_local < 65) {
            vector::push_back(&mut args_vec, j_local as u64);
            j_local = j_local + 1;
        };

        let total_sum = Self::sum_65_args(args_vec);
        
        // to avoid unused variable warnings
        // Use the variables for no op
        assert!(sum_borrows > 0, 42);
        assert!(address.addr != 0, 42);
        assert!(total_sum != 0, 42);
    }
}
