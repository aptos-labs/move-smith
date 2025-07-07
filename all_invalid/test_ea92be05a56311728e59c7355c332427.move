//# publish
module 0xAB::MathOperations {
    // Function to add two u64 values
    public fun add(x: u64, y: u64): u64 {
        x + y
    }

    // Runner to test add function
    public fun test_add(): u64 {
        add(123u64, 456u64)
    }
}

//# run 0xAB::MathOperations::test_add

//# publish
module 0xAB::ResourceManager {
    use 0xAB::MathOperations;

    resource struct Data {
        value: u64,
    }

    // Initialize resource and set value
    public fun init(s: &signer, initial_value: u64) {
        move_to(s, Data { value: initial_value });
    }

    // Increment the resource value by a delta
    public fun increment(s: &signer, delta: u64) acquires Data {
        let data_ref = borrow_global_mut<Data>(Signer::address_of(s));
        data_ref.value = MathOperations::add(data_ref.value, delta);
    }

    // Read the current value
    public fun get_value(addr: address): u64 acquires Data {
        let data_ref = borrow_global<Data>(addr);
        data_ref.value
    }
}

//# publish
module 0xAB::NestedWorkFlow {
    use 0xAB::ResourceManager;

    // A helper function that performs some work and then calls a continuation
    public fun work_continuation(s: &signer, cont: &vector<u8>) acquires ResourceManager.Data {
        ResourceManager::increment(s, 10);
        // We simulate a nested work operation by unlocking the resource, performing the continuation
        // For the purpose of this test, just call a function (simulate nested call)
        // Here, just call a no-arg function to mimic nested workflow
        Self::nested_operation();
        // After nested operation, continue
    }

    // Simulate a nested workflow
    public fun nested_operation() {
        // dummy nested operation
        // e.g., just a placeholder for deeper nested calls
    }

    // Main function to initialize resources and perform nested work
    public fun execute_workflow(s: &signer) {
        ResourceManager::init(s, 0);
        work_continuation(s, &vector[]);
    }
}

//# run 0xAB::NestedWorkFlow::execute_workflow --signers 0xAB

//# run 0xAB::ResourceManager::init --signers 0xAB --args 100u64

//# run 0xAB::ResourceManager::increment --signers 0xAB --args 55u64

//# run 0xAB::ResourceManager::get_value 0xAB