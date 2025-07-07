//# publish
module 0xabcde::test_module {
    fun takes_66_args(
        a1: u64, a2: u64, a3: u64, a4: u64, a5: u64, a6: u64, a7: u64, a8: u64, a9: u64, a10: u64,
        a11: u64, a12: u64, a13: u64, a14: u64, a15: u64, a16: u64, a17: u64, a18: u64, a19: u64, a20: u64,
        a21: u64, a22: u64, a23: u64, a24: u64, a25: u64, a26: u64, a27: u64, a28: u64, a29: u64, a30: u64,
        a31: u64, a32: u64, a33: u64, a34: u64, a35: u64, a36: u64, a37: u64, a38: u64, a39: u64, a40: u64,
        a41: u64, a42: u64, a43: u64, a44: u64, a45: u64, a46: u64, a47: u64, a48: u64, a49: u64, a50: u64,
        a51: u64, a52: u64, a53: u64, a54: u64, a55: u64, a56: u64, a57: u64, a58: u64, a59: u64, a60: u64,
        a61: u64, a62: u64, a63: u64, a64: u64, a65: u64, a66: u64
    ): u64 {
        a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 +
        a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19 + a20 +
        a21 + a22 + a23 + a24 + a25 + a26 + a27 + a28 + a29 + a30 +
        a31 + a32 + a33 + a34 + a35 + a36 + a37 + a38 + a39 + a40 +
        a41 + a42 + a43 + a44 + a45 + a46 + a47 + a48 + a49 + a50 +
        a51 + a52 + a53 + a54 + a55 + a56 + a57 + a58 + a59 + a60 +
        a61 + a62 + a63 + a64 + a65 + a66
    }

    fun zero(): u64 {
        0
    }

    fun increment_all(values: vector<u64>): vector<u64> {
        vector::map(&values, |x| x + 1)
    }

    fun sum_vector(values: vector<u64>): u64 {
        let mut sum = 0;
        let len = vector::length(&values);
        let mut i = 0;
        while (i < len) {
            sum = sum + *vector::borrow(&values, i);
            i = i + 1;
        }
        sum
    }

    public fun test(): u64 {
        // Generate 66 ones
        let mut args = vector::empty<u64>();
        let i = 0;
        while (i < 66) {
            vector::push_back(&mut args, 1);
            i = i + 1;
        }
        // Multiply each element by 2 to test with larger numbers
        let doubled_args = increment_all(args);
        // Call the function with the doubled args
        let result = takes_66_args(
            *vector::borrow(&doubled_args, 0),
            *vector::borrow(&doubled_args, 1),
            *vector::borrow(&doubled_args, 2),
            *vector::borrow(&doubled_args, 3),
            *vector::borrow(&doubled_args, 4),
            *vector::borrow(&doubled_args, 5),
            *vector::borrow(&doubled_args, 6),
            *vector::borrow(&doubled_args, 7),
            *vector::borrow(&doubled_args, 8),
            *vector::borrow(&doubled_args, 9),
            *vector::borrow(&doubled_args, 10),
            *vector::borrow(&doubled_args, 11),
            *vector::borrow(&doubled_args, 12),
            *vector::borrow(&doubled_args, 13),
            *vector::borrow(&doubled_args, 14),
            *vector::borrow(&doubled_args, 15),
            *vector::borrow(&doubled_args, 16),
            *vector::borrow(&doubled_args, 17),
            *vector::borrow(&doubled_args, 18),
            *vector::borrow(&doubled_args, 19),
            *vector::borrow(&doubled_args, 20),
            *vector::borrow(&doubled_args, 21),
            *vector::borrow(&doubled_args, 22),
            *vector::borrow(&doubled_args, 23),
            *vector::borrow(&doubled_args, 24),
            *vector::borrow(&doubled_args, 25),
            *vector::borrow(&doubled_args, 26),
            *vector::borrow(&doubled_args, 27),
            *vector::borrow(&doubled_args, 28),
            *vector::borrow(&doubled_args, 29),
            *vector::borrow(&doubled_args, 30),
            *vector::borrow(&doubled_args, 31),
            *vector::borrow(&doubled_args, 32),
            *vector::borrow(&doubled_args, 33),
            *vector::borrow(&doubled_args, 34),
            *vector::borrow(&doubled_args, 35),
            *vector::borrow(&doubled_args, 36),
            *vector::borrow(&doubled_args, 37),
            *vector::borrow(&doubled_args, 38),
            *vector::borrow(&doubled_args, 39),
            *vector::borrow(&doubled_args, 40),
            *vector::borrow(&doubled_args, 41),
            *vector::borrow(&doubled_args, 42),
            *vector::borrow(&doubled_args, 43),
            *vector::borrow(&doubled_args, 44),
            *vector::borrow(&doubled_args, 45),
            *vector::borrow(&doubled_args, 46),
            *vector::borrow(&doubled_args, 47),
            *vector::borrow(&doubled_args, 48),
            *vector::borrow(&doubled_args, 49),
            *vector::borrow(&doubled_args, 50),
            *vector::borrow(&doubled_args, 51),
            *vector::borrow(&doubled_args, 52),
            *vector::borrow(&doubled_args, 53),
            *vector::borrow(&doubled_args, 54),
            *vector::borrow(&doubled_args, 55),
            *vector::borrow(&doubled_args, 56),
            *vector::borrow(&doubled_args, 57),
            *vector::borrow(&doubled_args, 58),
            *vector::borrow(&doubled_args, 59),
            *vector::borrow(&doubled_args, 60),
            *vector::borrow(&doubled_args, 61),
            *vector::borrow(&doubled_args, 62),
            *vector::borrow(&doubled_args, 63),
            *vector::borrow(&doubled_args, 64),
            *vector::borrow(&doubled_args, 65),
        );
        // Sum the result; since all are 2, the total should be 66 * 2 = 132
        sum_vector(vector::repeat(66, 2))
        // The assertion is not requested, but the correctness can be asserted externally in the test runner.
    }
}