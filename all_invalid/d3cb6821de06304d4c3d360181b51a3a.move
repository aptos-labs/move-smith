
// Reassign variable within a function to test variable reassignment and shadowing
public fun test_variable_reassignment() {
    let x = 10u8;
    let x = x + 5u8; // reassign to x + 5
    let x = x * 2;   // reassign to previous value times 2
};

// Use of logical negation operator '!'
public fun test_logical_negation(flag: bool): bool {
    let negated_flag = !flag;
    negated_flag
}

// Global resource for testing access, mutation, existence, and error handling
//# publish
module 0xCAFE::GlobalResourceTest {
    use std::errors;

    struct GlobalResource has key, store {
        counter: u64,
        value: bool,
    }

    // Initialize the resource for testing
    public fun init(signer: signer) {
        let resource = GlobalResource { counter: 0, value: false };
        move_to<GlobalResource>(&signer, resource);
    }

    // Read resource
    public fun get_resource(address: address): &GlobalResource {
        borrow_global<GlobalResource>(address)
    }

    // Mutate resource
    public fun increment_counter(address: address) {
        let res: &mut GlobalResource = borrow_global_mut<GlobalResource>(address);
        res.counter = res.counter + 1;
    }

    // Toggle boolean value
    public fun toggle_value(address: address) {
        let res: &mut GlobalResource = borrow_global_mut<GlobalResource>(address);
        res.value = !res.value;
    }

    // Check existence
    public fun resource_exists(address: address): bool {
        exists<GlobalResource>(address)
    }

    // Remove resource - expected to abort if not exists
    public fun remove_resource(address: address) {
        if (exists<GlobalResource>(address)) {
            move_from<GlobalResource>(address);
        } else {
            errors::abort(errors::cost_invariant_violation());
        }
    }
}


//# run 0xCAFE::GlobalResourceTest::init --signers 0xBEEF

//# run 0xCAFE::GlobalResourceTest::get_resource --args 0xBEEF

//# run 0xCAFE::GlobalResourceTest::increment_counter --args 0xBEEF

//# run 0xCAFE::GlobalResourceTest::toggle_value --args 0xBEEF

//# run 0xCAFE::GlobalResourceTest::resource_exists --args 0xBEEF

//# run 0xCAFE::GlobalResourceTest::remove_resource --args 0xBEEF

//# run 0xCAFE::GlobalResourceTest::resource_exists --args 0xBEEF

//# run 0xCAFE::GlobalResourceTest::remove_resource --args 0xBEEF


// Featurres:
// 1418e667301691482936c74e8131da72: Test that variable reassignment works correctly within a function body.
// aebf58ec057a3449ce7b6e56d8b9b22d: Use the '!' operator to perform logical negation in expressions.
// 500933c97914f99890312aac314abd9b: Test the correct behavior of global resource access, mutation, existence checks, and proper error handling for unauthorized or invalid operations.
