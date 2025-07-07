//# publish
module 0xCADE {
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
        (counter_ref.clone(), value)
    }

    //# run 0xCADE::test_suite::run_tests
}

//# run 0xCADE::test_suite::run_tests
module 0xCADE::test_suite {
    use 0xCADE;

    // Runner function to perform sequence of tests
    public fun run_tests() {
        let addr = 0xCAFÉ; // Use a different address than 0x1
        // Initialize Counter resource at addr
        0xCADE::initialize(addr);
        // Increment counter by 5
        0xCADE::test_feature_with_params(addr, 5);
        // Increment counter by 10
        0xCADE::test_feature_with_params(addr, 10);
        // Get current value
        let current_value = 0xCADE::get_value(addr);
        // Copy value to exercise copy constructor
        let copied_value = 0xCADE::copy_value(current_value);
        // Unpack tuple return
        let (counter_resource, value) = 0xCADE::get_counter_and_value(addr);
    }
}

// Featurres:
// 90412034e9d821593c8fc32a21266754: Declare function parameters with explicit variable names and types using the syntax 'name: Type'.
// bbbc9c0cd146e4bac89b8e3b9201cf08: Use language features that require a specific minimum Move language version.
// 798dc00b2432a853c699ef97cbf4b3f0: Specify resources to be acquired using the `acquires R` clause in function signatures
