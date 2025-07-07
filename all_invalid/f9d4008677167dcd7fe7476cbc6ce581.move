
//# publish
module 0xCAFE::TestLoops {
    // Function to sum 65 u64 arguments
    public fun sum_65_args(
        a1: u64, a2: u64, a3: u64, a4: u64, a5: u64,
        a6: u64, a7: u64, a8: u64, a9: u64, a10: u64,
        a11: u64, a12: u64, a13: u64, a14: u64, a15: u64,
        a16: u64, a17: u64, a18: u64, a19: u64, a20: u64,
        a21: u64, a22: u64, a23: u64, a24: u64, a25: u64,
        a26: u64, a27: u64, a28: u64, a29: u64, a30: u64,
        a31: u64, a32: u64, a33: u64, a34: u64, a35: u64,
        a36: u64, a37: u64, a38: u64, a39: u64, a40: u64,
        a41: u64, a42: u64, a43: u64, a44: u64, a45: u64,
        a46: u64, a47: u64, a48: u64, a49: u64, a50: u64,
        a51: u64, a52: u64, a53: u64, a54: u64, a55: u64,
        a56: u64, a57: u64, a58: u64, a59: u64, a60: u64,
        a61: u64, a62: u64, a63: u64, a64: u64, a65: u64
    ): u64 {
        a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 +
        a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19 + a20 +
        a21 + a22 + a23 + a24 + a25 + a26 + a27 + a28 + a29 + a30 +
        a31 + a32 + a33 + a34 + a35 + a36 + a37 + a38 + a39 + a40 +
        a41 + a42 + a43 + a44 + a45 + a46 + a47 + a48 + a49 + a50 +
        a51 + a52 + a53 + a54 + a55 + a56 + a57 + a58 + a59 + a60 +
        a61 + a62 + a63 + a64 + a65
    }

    // Function to execute nested loops with break and verify termination
    public fun nested_loops_sample(): bool {
        let counter = 0u64;
        // Outer loop
        loop {
            // Inner loop
            while (counter < 100) {
                if (counter == 50) {
                    break;
                }
                // increment counter
                counter = counter + 1;
            }
            // Exit outer loop when counter >= 50
            if (counter >= 50) {
                break;
            }
        };
        // After breaking, check if counter is 50
        counter == 50
    }

    // Runner function to test the nested loop and sum function
    public fun run_tests(): bool {
        // Test summing 65 arguments
        let sum = Self::sum_65_args(
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1
        );
        assert sum == 65;

        // Test nested loops with break
        Self::nested_loops_sample()
    }
}



//# run 0xCAFE::TestLoops::run_tests --signers 0xCAFE