//# publish
module 0x-adobe::callback_resource {
    // A resource that can be used to demonstrate reentrancy restrictions
    struct R has key, store {
        value: u64
    }

    public fun create(signer: &signer, initial_value: u64): R {
        move_to(signer, R { value: initial_value })
    }

    public fun get_value(r: &R): u64 {
        r.value
    }

    public fun set_value(r: &mut R, new_value: u64) {
        r.value = new_value
    }
}

//# publish
module 0x-adobe::callback_tests {
    use 0x-adobe::callback_resource;

    struct Fixture has key {
        r_addr: address,
        success: bool
    }

    public fun setup(signer: &signer): Fixture {
        let r = callback_resource::create(signer, 0);
        Fixture {
            r_addr: move(r).0, // Obtain the address where R is stored
            success: false
        }
    }

    // Helper function to load resource reference
    fun get_r_ref(addr: address): &mut callback_resource::R acquires callback_resource {
        borrow_global_mut<callback_resource::R>(addr)
    }

    // Function to test reentrancy guard: calling a callback, which modifies the resource,
    // within a resource context, should not cause reentrancy errors.
    public fun test_reentrancy(s: &signer, fixture: &mut Fixture) {
        let r_ref = get_r_ref(fixture.r_addr);
        // Call the callback with a lambda that modifies the resource
        callback_resource::call_me(r_ref, |x| {
            // Inside callback, modify the resource
            callback_resource::set_value(x, callback_resource::get_value(x) + 1);
        });
        // After callback, further modify the resource
        callback_resource::set_value(r_ref, callback_resource::get_value(r_ref) + 1);
        // Mark success if no errors occurred
        fixture.success = true;
    }

    // Runner to perform the test
    public fun run_callback_test(s: &signer) {
        let mut fixture = setup(s);
        test_reentrancy(s, &mut fixture);
        // Verify final value
        let r_ref = get_r_ref(fixture.r_addr);
        assert!(callback_resource::get_value(r_ref) == 2, 0);
        assert!(fixture.success, 0);
    }
}

//# run 0x-adobe::callback_tests::run_callback_test --signers 0x1

//# run
script {
    fun main() {
        // Testing variable assignment within if-else branches
        let mut result;
        if (true) {
            result = 42;
        } else {
            result = 0;
        }
        assert!(result == 42, 0);

        let mut result2;
        if (false) {
            result2 = 100;
        } else {
            result2 = 7;
        }
        assert!(result2 == 7, 0);
    }
}

//# run
script {
    fun main() {
        // Testing assert! macro with a condition that causes abort
        // The following should abort if uncommented:
        // assert!(false, 1 / 0);
        // But to keep the test safe, we'll test a passing condition
        assert!(true, 1 / 0);
    }
}