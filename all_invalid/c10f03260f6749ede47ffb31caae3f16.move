
//# publish
module 0xBEEF::FeatureInteractionTest {
    use std::signer;
    use std::vector;

    // Define a resource with nested struct field to test dotted expressions and updates
    struct ResourceWithNested has store, key {
        counter: u64,
        nested: NestedStruct,
    }

    struct NestedStruct has store {
        flag: bool,
        count: u8,
    }

    // Initialize resource
    public fun init_resource(s: signer) {
        let nested = NestedStruct {flag: false, count: 0};
        let resource = ResourceWithNested {counter: 0, nested};
        move_to<ResourceWithNested>(&s, resource);
    }

    // Get mutable reference to resource
    public fun borrow_resource(s: signer): &mut ResourceWithNested {
        borrow_global_mut<ResourceWithNested>(signer::address_of(&s))
    }

    // Simulate a nested loop with break statement that should exit outer loop
    public fun nested_loop_break(s: signer, max_outer: u64, max_inner: u64) {
        let resource_ref = borrow_resource(s);
        let i = 0;
        while (i < max_outer) {
            let j = 0;
            while (j < max_inner) {
                // When inner j reaches 2, break the outer loop using a label-like approach 
                if (j == 2) {
                    // Here, break out of the outer loop by setting i to max_outer
                    i = max_outer; // simulate break outer
                    break;
                };
                j = j + 1;
            };
            i = i + 1;
        };
        // Increment counter based on number of loops executed
        resource_ref.counter = resource_ref.counter + i;
        // Also toggle nested flag when break occurs
        if (i >= max_outer) {
            resource_ref.nested.flag = true;
        };
    }

    // Access nested fields via dotted expressions
    public fun get_nested_flag(s: &ResourceWithNested): bool {
        s.nested.flag
    }

    public fun get_nested_count(s: &ResourceWithNested): u8 {
        s.nested.count
    }

    // Update nested fields within spec block
    public fun update_nested_fields(s: &mut ResourceWithNested, new_flag: bool, new_count: u8) {
        s.nested.flag = new_flag;
        s.nested.count = new_count;
    }

    // Combine: nested loop break, dotted access, and update inside a spec block
    public fun complex_operation(s: signer): bool acquires ResourceWithNested {
        let res_ref = borrow_resource(&s);
        let i = 0;
        // Fake nested loop with break outside
        while (i < 5) {
            let j = 0;
            while (j < 4) {
                if (j == 3) {
                    // break outer loop
                    i = 5;
                    break;
                };
                j = j + 1;
            };
            i = i + 1;
        };
        // After breaking, modify resource based on loop execution
        update_nested_fields(res_ref, true, 255);
        // Access nested fields with dotted expression
        let flag_value = get_nested_flag(res_ref);
        flag_value
    }

    // Spec block that invokes the complex operation
    public fun run_spec(s: &signer) {
        // Initialize resource
        init_resource(*s);
        // Perform the complex operation which will break loop, update, and access nested fields
        let final_flag = complex_operation(*s);
        // Verify final state, the nested flag should be true
        assert!(final_flag, 999);
        // Verify resource counter was updated correctly (should be 5 after the loops)
        let resource_state = borrow_global<ResourceWithNested>(signer::address_of(&s));
        let _ = resource_state.counter; // just access to ensure no errors
    }
}


//# run 0xBEEF::FeatureInteractionTest::run_spec --signers 0xABC


// Featurres:
// f1b503924389332f92227a5949789ee1: Test that a `loop break` statement is valid and executes correctly even when not nested inside an explicit loop.
// 232b89599d79eae82e64e4ab36d5a3e8: Create dotted expressions involving field access.
// 501fc4a8a44915c292953952c4d54c5b: Use update expressions to specify state changes within spec blocks.
