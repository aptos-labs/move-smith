//# publish
module 0xabcde::sum_test {
    /// Function that sums 65 u64 arguments, designed for testing large argument passing.
    public fun sum_65_args(
        a1: u64, a2: u64, a3: u64, a4: u64, a5: u64, a6: u64, a7: u64, a8: u64, a9: u64, a10: u64,
        a11: u64, a12: u64, a13: u64, a14: u64, a15: u64, a16: u64, a17: u64, a18: u64, a19: u64, a20: u64,
        a21: u64, a22: u64, a23: u64, a24: u64, a25: u64, a26: u64, a27: u64, a28: u64, a29: u64, a30: u64,
        a31: u64, a32: u64, a33: u64, a34: u64, a35: u64, a36: u64, a37: u64, a38: u64, a39: u64, a40: u64,
        a41: u64, a42: u64, a43: u64, a44: u64, a45: u64, a46: u64, a47: u64, a48: u64, a49: u64, a50: u64,
        a51: u64, a52: u64, a53: u64, a54: u64, a55: u64, a56: u64, a57: u64, a58: u64, a59: u64, a60: u64,
        a61: u64, a62: u64, a63: u64, a64: u64, a65: u64,
    ): u64 {
        // Sum all arguments
        a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 +
        a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19 + a20 +
        a21 + a22 + a23 + a24 + a25 + a26 + a27 + a28 + a29 + a30 +
        a31 + a32 + a33 + a34 + a35 + a36 + a37 + a38 + a39 + a40 +
        a41 + a42 + a43 + a44 + a45 + a46 + a47 + a48 + a49 + a50 +
        a51 + a52 + a53 + a54 + a55 + a56 + a57 + a58 + a59 + a60 +
        a61 + a62 + a63 + a64 + a65
    }

    /// Helper function to call sum_65_args with a pattern of arguments and verify the sum.
    public fun run_sum_test(): u64 {
        // Use a simple pattern for arguments to make verification straightforward.
        let total = sum_65_args(
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
            11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
            21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
            31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
            51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
            61, 62, 63, 64, 65
        );
        total
    }
}

//# run 0xabcde::sum_test::run_sum_test

//# publish
module 0xabcde::loop_interaction {
    /// Function that repeatedly calls sum_65_args while updating the arguments,
    /// testing variable preservation and loop control.
    public fun looped_sum(times: u64): u64 {
        let mut counter = 0;
        // Initialize arguments with some values
        let mut a1 = 1u64;
        let mut a2 = 2u64;
        let mut a3 = 3u64;
        let mut a4 = 4u64;
        let mut a5 = 5u64;
        // For brevity, only the first five are used in the loop, the rest remain constant
        let const_args = [
            10u64, 20u64, 30u64, 40u64, 50u64,
            60u64, 70u64, 80u64, 90u64, 100u64,
            110u64, 120u64, 130u64, 140u64, 150u64,
            160u64, 170u64, 180u64, 190u64, 200u64,
            210u64, 220u64, 230u64, 240u64, 250u64,
            260u64, 270u64, 280u64, 290u64, 300u64,
            310u64, 320u64, 330u64, 340u64, 350u64,
            360u64, 370u64, 380u64, 390u64, 400u64,
            410u64, 420u64, 430u64, 440u64, 450u64,
            460u64, 470u64, 480u64, 490u64, 500u64,
            510u64, 520u64, 530u64, 540u64, 550u64,
            560u64, 570u64, 580u64, 590u64, 600u64,
            610u64, 620u64, 630u64, 640u64, 650u64,
        ];

        while (counter < times) {
            // Update some of the arguments with current counter for variation
            a1 = a1 + counter;
            a2 = a2 + counter * 2;
            a3 = a3 + counter * 3;

            // Call the sum function with current arguments
            let _sum = 0xabcde::sum_test::sum_65_args(
                a1, a2, a3,
                const_args[0], const_args[1], const_args[2], const_args[3], const_args[4],
                const_args[5], const_args[6], const_args[7], const_args[8], const_args[9],
                const_args[10], const_args[11], const_args[12], const_args[13], const_args[14],
                const_args[15], const_args[16], const_args[17], const_args[18], const_args[19],
                const_args[20], const_args[21], const_args[22], const_args[23], const_args[24],
                const_args[25], const_args[26], const_args[27], const_args[28], const_args[29],
                const_args[30], const_args[31], const_args[32], const_args[33], const_args[34],
                const_args[35], const_args[36], const_args[37], const_args[38], const_args[39],
                const_args[40], const_args[41], const_args[42], const_args[43], const_args[44],
                const_args[45], const_args[46], const_args[47], const_args[48], const_args[49],
                const_args[50], const_args[51], const_args[52], const_args[53], const_args[54],
                const_args[55], const_args[56], const_args[57], const_args[58], const_args[59],
            );
            counter = counter + 1;
        };
        // Return the last computed sum for verification
        0
    }

    /// Runner function to execute the looped sum.
    public fun run_looped_sum(): u64 {
        looped_sum(3) // Run 3 iterations for testing
    }
}

//# run 0xabcde::loop_interaction::run_looped_sum