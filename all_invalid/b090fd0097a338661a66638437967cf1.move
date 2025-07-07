
//# publish
module 0xCAFE::TestModule {
    // Struct defined as an enum with multiple variants
    struct MyEnum has copy, drop {
        VariantA { x: u64, y: bool }: Option<(u64, bool)>,
        VariantB(u8, u16): Option<(u8, u16)>,
        VariantC { a: bool, b: u8, c: u64 }: Option<(bool, u8, u64)>,
    }

    // Function to test multiple code blocks as expressions and local variable mutations in return
    public fun complex_return(): (u64, bool, u8, u16, bool, u8, u64) {
        let local_var1 = 10u64;
        let local_var2 = true;

        let result = {
            local_var1 = local_var1 + 5;
            local_var2 = !local_var2;
            (local_var1, local_var2)
        };

        let local_var3 = 200u8;
        let local_var4 = 500u16;

        let result2 = {
            local_var3 = local_var3 + 1;
            local_var4 = local_var4 - 10;
            (local_var3, local_var4)
        };

        // Compose the return tuple with the local variables and inner code blocks
        (result.0, result.1, result2.0, result2.1, local_var2, local_var3, local_var1)
    }

    // Function to test various operations with assertions
    public fun operation_tests(): (bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool) {
        let a = 10u64;
        let b = 20u64;

        // Comparison
        assert!(a < b);
        assert!(b > a);
        assert!(a <= a);
        assert!(b >= b);
        assert!(!(a == b));
        assert!(a != b);

        // Arithmetic
        let sum = a + b;
        let diff = b - a;
        let prod = a * 2;
        let div = b / 2;
        let rem = b % 3;

        assert!(sum == 30);
        assert!(diff == 10);
        assert!(prod == 20);
        assert!(div == 10);
        assert!(rem == 2);

        // Logical
        let t = true;
        let f = false;
        assert!(t && !f);
        assert!(t || f);
        assert!(!f && !f);
        assert!(t || !t);

        // Bitwise
        let x = 0b1010u8;
        let y = 0b1100u8;
        assert!(x & y == 0b1000);
        assert!(x | y == 0b1110);
        assert!(x ^ y == 0b0110);
        assert!(x << 1 == 0b10100);
        assert!(y >> 1 == 0b0110);

        // Shift (cover shift bounds)
        let shift_amount = 3;
        let shifted_left = x << shift_amount;
        let shifted_right = y >> shift_amount;

        assert!(shifted_left == 0b101000);
        assert!(shifted_right == 0b0110);

        // Return tuple of all bool assertions for verification
        (
            a < b, a > b, a <= a, b >= b, a == b, a != b,
            t && !f, t || f, !f && !f, t || !t,
            x & y == 0b1000, x | y == 0b1110, x ^ y == 0b0110,
            shifted_left == 0b101000, shifted_right == 0b0110, true, true
        )
    }
}

//! The following are the executed commands to test the module functions


//# run 0xCAFE::TestModule::complex_return --signers 0xBADD


//# run 0xCAFE::TestModule::operation_tests --signers 0xBADD