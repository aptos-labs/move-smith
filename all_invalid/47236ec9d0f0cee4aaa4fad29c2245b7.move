//# publish
module 0xCAFE::IntegratedFeatureTest {
    use std::signer;
    use std::debug;
    use std::vector; // Add this line to include vector module

    // Internal function not accessible outside module
    fun internal_add(a: u8, b: u8): u8 {
        a + b
    }

    // Internal function with abort conditions
    fun internal_abort_test(x: u8): u8 {
        if (x == 0) {
            abort 100;
        } else if (x == 1) {
            abort 200;
        } else if (x == 2) {
            abort 300;
        };
        x + 10
    }

    // Entry point to test internal functions and abort scenarios
    public fun test_entry(signer_addr: address) acquires None {
        // Call a regular internal function
        let sum = internal_add(5, 10);
        // Call internal function that may abort
        let result1 = if (false) { // dummy condition to avoid abort
            internal_abort_test(0)
        } else {
            internal_abort_test(3)
        };

        // Call internal_abort_test with different abort conditions
        let res;
        if (false) {
            // simulate abort with 0 (should abort with code 100)
            res = internal_abort_test(0);
        } else if (false) {
            // simulate abort with 1 (should abort with code 200)
            res = internal_abort_test(1);
        } else if (false) {
            // simulate abort with 2 (should abort with code 300)
            res = internal_abort_test(2);
        } else {
            // normal path
            res = internal_abort_test(4);
        };

        // Combine results into a vector
        let v = vector::empty<u8>();
        vector::push_back(&mut v, sum);
        vector::push_back(&mut v, result1);
        vector::push_back(&mut v, res);
        v
    }
}
