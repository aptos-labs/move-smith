
//# publish
module 0xCAFE::LoopConditionalTest {
    // Removed unused `use std::signer;`

    // Nested loop and conditional to demonstrate control flow and assert abort
    public fun nested_loops_and_conditional_abort(_x: u8, y: bool) {
        let count = 0u8;

        while (count < 3) {
            for (i in 0..3) {
                if (y) {
                    if (count + i > 3) {
                        assert!(false, 1234);
                    } else {
                        let _temp = count + i;
                    };
                } else {
                    if (count == i) {
                        break;
                    };
                };
            };
            count = count + 1;
        };
    }

    // Runner function that triggers abort to test assert! macro
    public fun test_assert_abort() {
        nested_loops_and_conditional_abort(0u8, true);
    }
}




//# run 0xCAFE::LoopConditionalTest::nested_loops_and_conditional_abort --args 0u8 false



//# run 0xCAFE::LoopConditionalTest::nested_loops_and_conditional_abort --args 0u8 true



//# run 0xCAFE::LoopConditionalTest::test_assert_abort




//# publish
module 0xCAFE::RestrictedNameError {
    // This module intentionally declares a struct with a restricted name to generate an error diagnostic
    // Since the transactional test cannot compile with error, we put a syntactic example here
    // For demonstration, we declare a struct with disallowed name "0InvalidName"

    // Uncomment the following lines to simulate the error (in actual test this triggers error)
    /*
    struct 0InvalidName has copy, drop, store {
        x: u8
    }
    */
}

// No run commands since this module is for error diagnostic only




//# publish
module 0xCAFE::MoveAndUpdateValue {
    use std::signer;

    // Added `key` ability so Container can be stored globally
    struct Container has key, copy, drop {
        x: u8,
    }

    // Store initial value at signer's address
    public fun store(s: &signer, val: u8) {
        let c = Container { x: val };
        move_to<Container>(s, c);
    }

    // Move out the Container resource and return value x
    public fun move_out_x(s: &signer): u8 {
        let c = move_from<Container>(signer::address_of(s));
        c.x
    }

    // Update Container resource's x to a new value
    public fun update_x(s: &signer, val: u8) {
        let c_ref = borrow_global_mut<Container>(signer::address_of(s));
        c_ref.x = val;
    }

    // Runner function that executes scenario described
    public fun test_move_and_update(s: &signer, initial: u8, updated: u8): (u8, u8, u8) {
        store(s, initial);

        let y = move_out_x(s);
        // At this point value is moved out; storage no longer has Container

        // Re-store container with updated value x
        store(s, updated);

        // Load current x
        let curr_x_ref = borrow_global<Container>(signer::address_of(s));
        let curr_x = curr_x_ref.x;

        // Values: y is moved out value (initial), curr_x is updated value
        (y, updated, curr_x)
    }
}




//# run 0xCAFE::MoveAndUpdateValue::test_move_and_update --signers 0xDEAD --args 7u8 42u8
