//# publish
module 0xBADD::TestModule {
    use std::signer;

    // A private function that should not be accessible outside
    fun private_private_fn(): u8 {
        42
    }

    // A public function to test private access
    public fun public_fn(): u8 {
        7
    }

    // Function to perform optional conditional update
    public fun conditional_update(flag: bool, x: &mut u8) {
        if (flag) {
            *x = *x + 1;
        } else {
            *x = *x + 2;
        }; // Corrected: added semicolon after if-else block
    }

    // Function using nested blocks and mutable reference
    public fun nested_blocks_test(flag: bool, x: &mut u8) {
        {
            let y = *x;
            if (flag) {
                *x = y + 10;
            } else {
                *x = y + 20;
            }; // Corrected: added semicolon after if-else block
        }
        // Additional nested block
        {
            let z = *x;
            *x = z + 5;
        }
    }

    // Public runner to perform tests
    public fun run_tests() {
        let s = signer::specify signer;
        let s_address = signer::address_of(&s);
        // Note: This is just a placeholder call, actual calls from outside should not access private functions.
        // We test public functions are accessible.
        let val1 = public_fn();

        // Test conditional update
        let x = 0u8;
        conditional_update(true, &mut x);
        assert!(x == 1, 100);
        conditional_update(false, &mut x);
        assert!(x == 3, 101);

        // Test nested blocks with mutable reference
        let y = 5u8;
        nested_blocks_test(true, &mut y);
        // 5 + 10 + 5
        assert!(y == 20, 102);

        let z = 3u8;
        nested_blocks_test(false, &mut z);
        // 3 + 20 + 5
        assert!(z == 28, 103);
    }
}
