//# publish
module 0xCAFE {
    // Declare a simple resource with abilities
    struct Counter has key, store {
        value: u64,
    }

    // Function to initialize a Counter resource at a specific address
    public fun initialize(address: address) {
        move_to(address, Counter { value: 0 });
    }

    // Function to increment the counter, acquiring the resource
    public fun increment(counter_addr: address) acquires Counter {
        let counter_ref = borrow_global_mut<Counter>(counter_addr);
        counter_ref.value = counter_ref.value + 1;
    }

    // Function to get the current value of counter
    public fun get_value(counter_addr: address): u64 acquires Counter {
        let counter_ref = borrow_global<Counter>(counter_addr);
        counter_ref.value
    }

    // Inline function involving resource copy (requires copy ability)
    public inline fun copy_value(value: u64): u64 {
        value
    }

    // Function to test explicit parameter typing and resource acquisition
    public fun test_feature_with_params(counter_addr: address, increment_by: u64): u64 acquires Counter {
        let counter_ref = borrow_global_mut<Counter>(counter_addr);
        counter_ref.value = counter_ref.value + increment_by;
        counter_ref.value
    }

    // Function to demonstrate explicit variable names and types with a tuple return
    public fun get_counter_and_value(address: address): (Counter, u64) acquires Counter {
        let counter_ref = borrow_global<Counter>(address);
        let value = counter_ref.value;
        (copy counter_ref, value)
    }

    //# run 0xCAFE::test_suite::run_tests
}

//# run 0xCAFE::test_suite
module 0xCAFE::test_suite {
    use 0xCAFE;

    // Runner function to perform sequence of tests
    public fun run_tests() {
        let addr = 0xCAFÉ; // Use a different address than 0x1
        // Initialize Counter resource at addr
        0xCAFE::initialize(addr);
        // Increment counter by 5
        0xCAFE::test_feature_with_params(addr, 5);
        // Increment counter by 10
        0xCAFE::test_feature_with_params(addr, 10);
        // Get current value
        let current_value = 0xCAFE::get_value(addr);
        // Copy value to exercise copy constructor
        let copied_value = 0xCAFE::copy_value(current_value);
        // Unpack tuple return
        let (counter_resource, value) = 0xCAFE::get_counter_and_value(addr);
    }
}