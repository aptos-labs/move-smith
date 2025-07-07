
//# publish
module 0xDABBAD00::TestModule {
    use std::signer;
    use std::vector;
    use std::option;

    // Define a constant attribute with a module-qualified identifier
    const ATTRIBUTE_CONST: u32 = 0xDEAD;

    // Resource to test access within lambda closure
    struct SharedResource has store, key {
        count: u64,
    }

    // Function to create and initialize the resource
    public fun init_resource(s: signer): () {
        let resource = SharedResource { count: 0 };
        move_to<SharedResource>(&s, resource);
    }

    // Function to get the current value of the resource (for verification)
    public fun get_resource_count(address: address): u64 acquires SharedResource {
        let resource_ref: &SharedResource = borrow_global<SharedResource>(address);
        resource_ref.count
    }

    // Function to modify resource directly
    public fun modify_resource(address: address, delta: u64): () acquires SharedResource {
        let resource_ref: &mut SharedResource = borrow_global_mut<SharedResource>(address);
        resource_ref.count = resource_ref.count + delta;
    }

    // Lambda closure that captures a resource in global storage and modifies it
    public fun lambda_modify_resource(s: signer, delta: u64) {
        let address = signer::address_of(&s);
        // Capture current resource value
        let resource_ref: &mut SharedResource = borrow_global_mut<SharedResource>(address);
        // Lambda: increase the count by delta
        let closure = |mut x: u64| -> u64 {
            // Access the resource directly
            let res: &mut SharedResource = borrow_global_mut<SharedResource>(address);
            res.count = res.count + x;
            // Return the new count
            res.count
        };
        // Call lambda
        let new_value = closure)(delta);
        // The lambda modifies global storage directly, so global resource must reflect change
        // (The lambda's modification is within the resource, so no further action needed)
    }

    // Function to verify resource's final value
    public fun verify_resource(address: address, expected: u64): bool acquires SharedResource {
        let current = get_resource_count(address);
        current == expected
    }

    // Use a partially applied function within a lambda (not in scripts)
    public fun partial_apply_example(
        s: signer,
        f: |u64| -> u64
    ) {
        let result = f(10);
        // For testing, we don't need to do anything further
    }

    // Example function with partial application just to keep code conformant
    public fun run_partial_apply(s: signer) {
        // Partially apply a simple function: multiply by 2
        let multiply_by_two = |x: u64| -> u64 {
            x * 2
        };
        partial_apply_example(s, multiply_by_two);
    }
}


//# run 0xDABBAD00::TestModule::init_resource --signers 0xBADD

//# run 0xDABBAD00::TestModule::lambda_modify_resource --signers 0xBADD --args 5u64

//# run 0xDABBAD00::TestModule::verify_resource --args (0xBADD, 5u64)


// Featurres:
// acf0a8237c18af53c3ab3a951204da8b: Annotate your Move code with attributes that have either constant values or module-qualified identifiers as their values.
// baddac62716d4373cd3b5ac3b99dc0ef: Test whether a lambda closure can access and modify a resource in global storage, and verify that direct resource modifications after the closure's invocation behave as expected.
// 50ee0c7b7d1856d5244efa476d5a1a06: Use lambda expressions that partially apply existing functions, except that such lambda lifting is not allowed in scripts.
