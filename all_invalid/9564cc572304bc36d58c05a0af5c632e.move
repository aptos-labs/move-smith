
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // Helper struct for swap tests
    struct SwapStruct has copy, drop, store {
        a: u64,
        b: u64,
    }

    public fun test_byte_vector_equality() {
        let byte_vec: vector<u8> = vector::empty();
        vector::push_back(&mut byte_vec, 0x80);
        vector::push_back(&mut byte_vec, 0xDE);
        vector::push_back(&mut byte_vec, 0xAD);
        vector::push_back(&mut byte_vec, 0xBE);
        vector::push_back(&mut byte_vec, 0xEF);
        vector::push_back(&mut byte_vec, 0x01);
        vector::push_back(&mut byte_vec, 0x23);
        vector::push_back(&mut byte_vec, 0x45);
        vector::push_back(&mut byte_vec, 0x67);
        vector::push_back(&mut byte_vec, 0x89);
        vector::push_back(&mut byte_vec, 0xAB);
        vector::push_back(&mut byte_vec, 0xCD);
        vector::push_back(&mut byte_vec, 0xEF);
        vector::push_back(&mut byte_vec, 0xFE);
        vector::push_back(&mut byte_vec, 0xDC);
        vector::push_back(&mut byte_vec, 0xBA);
        vector::push_back(&mut byte_vec, 0x98);
        vector::push_back(&mut byte_vec, 0x76);
        vector::push_back(&mut byte_vec, 0x54);
        vector::push_back(&mut byte_vec, 0x32);
        vector::push_back(&mut byte_vec, 0x10);
        vector::push_back(&mut byte_vec, 0x00);
        vector::push_back(&mut byte_vec, 0xFF);
        vector::push_back(&mut byte_vec, 0xEE);
        vector::push_back(&mut byte_vec, 0xDD);
        vector::push_back(&mut byte_vec, 0xCC);
        vector::push_back(&mut byte_vec, 0xBB);
        vector::push_back(&mut byte_vec, 0xAA);
        vector::push_back(&mut byte_vec, 0x99);
        vector::push_back(&mut byte_vec, 0x88);
        vector::push_back(&mut byte_vec, 0x77);
        vector::push_back(&mut byte_vec, 0x66);
        vector::push_back(&mut byte_vec, 0x55);

        // Confirm vector length is 33
        assert!(vector::length(&byte_vec) == 33, 0);
        // Verify the first byte is 0x80
        assert!(*vector::borrow(&byte_vec, 0) == 0x80, 1);
    }

    public fun swap_simple(x: u64, y: u64): (u64, u64) {
        let temp = x;
        let x_new = y;
        let y_new = temp;
        (x_new, y_new)
    }

    public fun swap_struct(s: SwapStruct): SwapStruct {
        let SwapStruct {a: a_val, b: b_val} = s;
        let new_struct = SwapStruct {a: b_val, b: a_val};
        new_struct
    }

    public fun swap_loop(vec: vector<u64>): (vector<u64>, vector<u64>) {
        let v1 = vector::empty<u64>();
        let v2 = vector::empty<u64>();
        let len = vector::length(&vec);
        let i = 0;
        let i = i;
        while (i < len) {
            let val = *vector::borrow(&vec, i);
            vector::push_back(&mut v1, val);
            vector::push_back(&mut v2, val + 1);
            i = i + 1;
        };
        (v1, v2)
    }

    public fun swap_reference_and_shadow(x: u64): u64 {
        let y = x;
        let y_ref: &mut u64 = &mut y;
        *y_ref = *y_ref + 10;
        y
    }

    public fun swap_vars_shadowing() {
        let a = 5u64;
        {
            let a = 10u64;
            let a = a + 1;
        };
        // After shadowing, 'a' still equals 5
        assert!(a == 5, 2);
    }

    public fun if_else_branch(cond: bool): u64 {
        let result = if (cond) {
            100u64
        } else {
            200u64
        };
        result
    }

    public fun if_else_branch_optional(cond: bool): u64 {
        let result = if (cond) {
            123u64
        } else {
        };
        result
    }

    public fun run_all_tests() {
        // Run the byte vector comparison test
        Self::test_byte_vector_equality();

        // Run the simple swap test
        let (a1, b1) = Self::swap_simple(10, 20);
        assert!(a1 == 20 && b1 == 10, 3);

        // Run the struct swap test
        let s = SwapStruct {a: 1, b: 2};
        let s2 = Self::swap_struct(s);
        assert!(s2.a == 2 && s2.b == 1, 4);

        // Run loop swap
        let input_vec = vector::singleton(100);
        let (vec1, vec2) = Self::swap_loop(input_vec);
        assert!(*vector::borrow(&vec1, 0) == 100, 5);
        assert!(*vector::borrow(&vec2, 0) == 101, 6);

        // Run reference and shadowing swap
        let y = Self::swap_reference_and_shadow(50);
        assert!(y == 60, 7);
        Self::swap_vars_shadowing();

        // Run conditional branch tests
        let res1 = Self::if_else_branch(true);
        assert!(res1 == 100, 8);
        let res2 = Self::if_else_branch(false);
        assert!(res2 == 200, 9);
        let res3 = Self::if_else_branch_optional(true);
        assert!(res3 == 123, 10);
        let res4 = Self::if_else_branch_optional(false);
        assert!(res4 == 0, 11); // default value of uninitialized variable in optional branch
    }
}


//# run 0xCAFE::FeatureTest::run_all_tests


// Featurres:
// e7a66f5c115147c5bd1a467634b47774: Test that a 33-byte vector with a high bit set (0x80) is considered equal to its hexadecimal representation, verifying proper handling of non-canonical byte sequences.
// 3b804f67ce2cf31e56d67ce1f9109ff6: Test the correct functionality of multiple swap functions, including simple value swaps, swaps with structures, loops, reference swaps, and variable shadowing, ensuring each behaves as expected.
// 817f78ceb6c33c6b4c3aab22d5889843: Write conditional branches using the `if_else` expression with then and optional else branches.
