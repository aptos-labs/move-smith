//# publish
module 0x123456::test_module {
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

    fun one(): u64 {
        1
    }

    // Verify summation accuracy with mixed arguments
    public fun test_various_args(): u64 {
        // Use a pattern of mixed values
        let vals = [
            one(), one() * 2, one() * 3, one() * 4, one() * 5,
            one() * 6, one() * 7, one() * 8, one() * 9, one() * 10,
            one() * 11, one() * 12, one() * 13, one() * 14, one() * 15,
            one() * 16, one() * 17, one() * 18, one() * 19, one() * 20,
            one() * 21, one() * 22, one() * 23, one() * 24, one() * 25,
            one() * 26, one() * 27, one() * 28, one() * 29, one() * 30,
            one() * 31, one() * 32, one() * 33, one() * 34, one() * 35,
            one() * 36, one() * 37, one() * 38, one() * 39, one() * 40,
            one() * 41, one() * 42, one() * 43, one() * 44, one() * 45,
            one() * 46, one() * 47, one() * 48, one() * 49, one() * 50,
            one() * 51, one() * 52, one() * 53, one() * 54, one() * 55,
            one() * 56, one() * 57, one() * 58, one() * 59, one() * 60,
            one() * 61, one() * 62, one() * 63, one() * 64, one() * 65,
            one() * 66
        ];

        // Expected sum: sum of (1 + 2 + ... + 66) = (66*67)/2 = 2211
        let result = 0;
        let mut total: u64 = 0;
        let mut i = 0;
        while (i < 66) {
            total = total + vals[i];
            i = i + 1;
        };
        result = total;

        // Call the function with the same args
        let sum_from_fn = takes_66_args(
            vals[0], vals[1], vals[2], vals[3], vals[4], vals[5], vals[6], vals[7], vals[8], vals[9],
            vals[10], vals[11], vals[12], vals[13], vals[14], vals[15], vals[16], vals[17], vals[18], vals[19],
            vals[20], vals[21], vals[22], vals[23], vals[24], vals[25], vals[26], vals[27], vals[28], vals[29],
            vals[30], vals[31], vals[32], vals[33], vals[34], vals[35], vals[36], vals[37], vals[38], vals[39],
            vals[40], vals[41], vals[42], vals[43], vals[44], vals[45], vals[46], vals[47], vals[48], vals[49],
            vals[50], vals[51], vals[52], vals[53], vals[54], vals[55], vals[56], vals[57], vals[58], vals[59],
            vals[60], vals[61], vals[62], vals[63], vals[64], vals[65]
        );

        // Return the sum from the function, expect 2211
        sum_from_fn
    }
}

    //# run 0x123456::test_module::test_various_args --signers 0x1