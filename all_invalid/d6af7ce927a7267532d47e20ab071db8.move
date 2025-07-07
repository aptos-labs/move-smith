//# publish
module 0xA55::experiment_flags {
    /// Struct to hold experiment flags.
    struct Flags has copy, drop, store {
        enable_feature_x: bool,
        enable_feature_y: bool,
    }

    /// Initialize flags with default values.
    public fun new_flags(enable_x: bool, enable_y: bool): Flags {
        Flags {
            enable_feature_x: enable_x,
            enable_feature_y: enable_y,
        }
    }

    /// Setter for feature x.
    public fun set_feature_x(flags: &mut Flags, enable_x: bool) {
        flags.enable_feature_x = enable_x;
    }

    /// Setter for feature y.
    public fun set_feature_y(flags: &mut Flags, enable_y: bool) {
        flags.enable_feature_y = enable_y;
    }
}

//# publish
module 0xA55::test_virtual_machine {
    use std::signer;
    use 0xA55::experiment_flags::Flags;

    // Define a resource holding a numerical value.
    struct S has key {
        value: u64,
    }

    // Initialize a global resource for testing sum,
    // here we keep a vector of S references.
    resource struct Store {
        items: vector<&'static S>,
    }

    public entry fun init_store(account: &signer) {
        move_to(account, Store { items: vector::empty<&S>() });
    }

    // Function to add an S resource to the store.
    public fun add_s(store_addr: address, val: u64) {
        let s = borrow_global<S>(store_addr);
        // For test purposes, we just create a new S
        move_to(&signer::address_of(&signer::public_key()), S { value: val });
    }

    // Function to run tests on sum with references.
    public fun run_sum_test() {
        // Initialize flags with default false.
        let flags = Flags::new_flags(false, false);

        // Create some S resources for testing.
        // For simplicity, we assume the store is at address 0x1.
        let store_addr = @0x1;

        // Add some S resources.
        // In a real test, you'd initialize and add S instances.
        // For simulation, assume we have references to some S values.
        // Use 'seq' to test sequential expressions.
        seq {
            // Create S resources with different values.
            // Note: In actual code, you'd create and store resources properly.
            // Here, for test purposes, we simulate references.

            // Assume we have references to existing S resources.
            let s1_ref = &S { value: 10 };
            let s2_ref = &S { value: 20 };
            let s3_ref = &S { value: 30 };

            // Call sum functions with references.
            let total = sum(&s1_ref) + sum(&s2_ref) + sum(&s3_ref);
            // Optionally, test with mutable references.
            let mut s4 = S { value: 40 };
            let mref = &mut s4;
            let total_mut = sum(mref);
        }
    }

    /// Helper function to sum a reference to S.
    public fun sum(s_ref: &S): u64 {
        s_ref.value
    }

    /// Helper function to sum a mutable reference to S.
    public fun sum(s_ref: &mut S): u64 {
        s_ref.value
    }

    // Optional: provide a runner to invoke run_sum_test.
    public fun run_all() {
        run_sum_test();
    }
}

//# run 0xA55::test_virtual_machine::run_all