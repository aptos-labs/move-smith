// # publish
module 0xCAFE::LocationTracker {
    use std::debug;
    use std::string;

    // A function that returns a string describing the caller's location
    // We use this dummy function to test location tracking.
    public fun location_info(): string::String {
        let loc = debug::location();
        let mut s = string::utf8(b"File: ");
        s = string::append(&s, loc.file_name);
        s = string::append(&s, b", Line: ");
        s = string::append(&s, string::utf8(debug::u64_to_string(loc.line)));
        s = string::append(&s, b", Column: ");
        s = string::append(&s, string::utf8(debug::u64_to_string(loc.column)));

        s
    }

}


// # publish
module 0xCAFE::LargeParams {
    // A function with exactly 65 parameters, all u8, that returns their sum.
    // Then it uses a lambda expression inside to do it again.
    public fun sum_65(
        p0: u8, p1: u8, p2: u8, p3: u8, p4: u8, p5: u8, p6: u8, p7: u8,
        p8: u8, p9: u8, p10: u8, p11: u8, p12: u8, p13: u8, p14: u8, p15: u8,
        p16: u8, p17: u8, p18: u8, p19: u8, p20: u8, p21: u8, p22: u8, p23: u8,
        p24: u8, p25: u8, p26: u8, p27: u8, p28: u8, p29: u8, p30: u8, p31: u8,
        p32: u8, p33: u8, p34: u8, p35: u8, p36: u8, p37: u8, p38: u8, p39: u8,
        p40: u8, p41: u8, p42: u8, p43: u8, p44: u8, p45: u8, p46: u8, p47: u8,
        p48: u8, p49: u8, p50: u8, p51: u8, p52: u8, p53: u8, p54: u8, p55: u8,
        p56: u8, p57: u8, p58: u8, p59: u8, p60: u8, p61: u8, p62: u8, p63: u8,
        p64: u8
    ): u64 {
        // sum them directly
        let sum1 = 
            (p0 as u64) + (p1 as u64) + (p2 as u64) + (p3 as u64) + (p4 as u64) + (p5 as u64) + (p6 as u64) + (p7 as u64) +
            (p8 as u64) + (p9 as u64) + (p10 as u64) + (p11 as u64) + (p12 as u64) + (p13 as u64) + (p14 as u64) + (p15 as u64) +
            (p16 as u64) + (p17 as u64) + (p18 as u64) + (p19 as u64) + (p20 as u64) + (p21 as u64) + (p22 as u64) + (p23 as u64) +
            (p24 as u64) + (p25 as u64) + (p26 as u64) + (p27 as u64) + (p28 as u64) + (p29 as u64) + (p30 as u64) + (p31 as u64) +
            (p32 as u64) + (p33 as u64) + (p34 as u64) + (p35 as u64) + (p36 as u64) + (p37 as u64) + (p38 as u64) + (p39 as u64) +
            (p40 as u64) + (p41 as u64) + (p42 as u64) + (p43 as u64) + (p44 as u64) + (p45 as u64) + (p46 as u64) + (p47 as u64) +
            (p48 as u64) + (p49 as u64) + (p50 as u64) + (p51 as u64) + (p52 as u64) + (p53 as u64) + (p54 as u64) + (p55 as u64) +
            (p56 as u64) + (p57 as u64) + (p58 as u64) + (p59 as u64) + (p60 as u64) + (p61 as u64) + (p62 as u64) + (p63 as u64) +
            (p64 as u64);

        // Now use a lambda expression that sums again with the same parameters using move v2.2 lambda spec block
        let lambda = move | 
            a0: u8, a1: u8, a2: u8, a3: u8, a4: u8, a5: u8, a6: u8, a7: u8,
            a8: u8, a9: u8, a10: u8, a11: u8, a12: u8, a13: u8, a14: u8, a15: u8,
            a16: u8, a17: u8, a18: u8, a19: u8, a20: u8, a21: u8, a22: u8, a23: u8,
            a24: u8, a25: u8, a26: u8, a27: u8, a28: u8, a29: u8, a30: u8, a31: u8,
            a32: u8, a33: u8, a34: u8, a35: u8, a36: u8, a37: u8, a38: u8, a39: u8,
            a40: u8, a41: u8, a42: u8, a43: u8, a44: u8, a45: u8, a46: u8, a47: u8,
            a48: u8, a49: u8, a50: u8, a51: u8, a52: u8, a53: u8, a54: u8, a55: u8,
            a56: u8, a57: u8, a58: u8, a59: u8, a60: u8, a61: u8, a62: u8, a63: u8,
            a64: u8
        move {
            spec {
                // spec block attached to lambda for Move 2.2+
                ensures true;
            }
            let sum_lambda = 
                (a0 as u64) + (a1 as u64) + (a2 as u64) + (a3 as u64) + (a4 as u64) + (a5 as u64) + (a6 as u64) + (a7 as u64) +
                (a8 as u64) + (a9 as u64) + (a10 as u64) + (a11 as u64) + (a12 as u64) + (a13 as u64) + (a14 as u64) + (a15 as u64) +
                (a16 as u64) + (a17 as u64) + (a18 as u64) + (a19 as u64) + (a20 as u64) + (a21 as u64) + (a22 as u64) + (a23 as u64) +
                (a24 as u64) + (a25 as u64) + (a26 as u64) + (a27 as u64) + (a28 as u64) + (a29 as u64) + (a30 as u64) + (a31 as u64) +
                (a32 as u64) + (a33 as u64) + (a34 as u64) + (a35 as u64) + (a36 as u64) + (a37 as u64) + (a38 as u64) + (a39 as u64) +
                (a40 as u64) + (a41 as u64) + (a42 as u64) + (a43 as u64) + (a44 as u64) + (a45 as u64) + (a46 as u64) + (a47 as u64) +
                (a48 as u64) + (a49 as u64) + (a50 as u64) + (a51 as u64) + (a52 as u64) + (a53 as u64) + (a54 as u64) + (a55 as u64) +
                (a56 as u64) + (a57 as u64) + (a58 as u64) + (a59 as u64) + (a60 as u64) + (a61 as u64) + (a62 as u64) + (a63 as u64) +
                (a64 as u64);
            sum_lambda
        };

        let sum2 = lambda(
            p0, p1, p2, p3, p4, p5, p6, p7,
            p8, p9, p10, p11, p12, p13, p14, p15,
            p16, p17, p18, p19, p20, p21, p22, p23,
            p24, p25, p26, p27, p28, p29, p30, p31,
            p32, p33, p34, p35, p36, p37, p38, p39,
            p40, p41, p42, p43, p44, p45, p46, p47,
            p48, p49, p50, p51, p52, p53, p54, p55,
            p56, p57, p58, p59, p60, p61, p62, p63,
            p64
        );
        // Return sum1 + sum2 to check both are captured (though no assertion needed)
        sum1 + sum2
    }

    // Runner function that calls sum_65 with range 0..64 values as u8
    public fun runner(): u64 {
        sum_65(
            0u8, 1u8, 2u8, 3u8, 4u8, 5u8, 6u8, 7u8,
            8u8, 9u8, 10u8, 11u8, 12u8, 13u8, 14u8, 15u8,
            16u8, 17u8, 18u8, 19u8, 20u8, 21u8, 22u8, 23u8,
            24u8, 25u8, 26u8, 27u8, 28u8, 29u8, 30u8, 31u8,
            32u8, 33u8, 34u8, 35u8, 36u8, 37u8, 38u8, 39u8,
            40u8, 41u8, 42u8, 43u8, 44u8, 45u8, 46u8, 47u8,
            48u8, 49u8, 50u8, 51u8, 52u8, 53u8, 54u8, 55u8,
            56u8, 57u8, 58u8, 59u8, 60u8, 61u8, 62u8, 63u8,
            64u8
        )
    }
}
// # run 0xCAFE::LargeParams::runner 


// # publish
module 0xCAFE::SpecLambda {
    // A function to test attaching spec block directly to lambda expressions.
    public fun spec_lambda_test(): u8 {
        let f = move |x: u8| : u8 {
            spec {
                ensures result == x + 1;
            }
            x + 1
        };
        f(41)
    }

    // Runner for the above to test spec block attachment.
    public fun runner(): u8 {
        spec_lambda_test()
    }
}
// # run 0xCAFE::SpecLambda::runner
  

// # run
script {
    use 0xCAFE::LocationTracker;
    use 0xCAFE::LargeParams;
    use 0xCAFE::SpecLambda;

    fun main() {
        // Call LocationTracker.location_info to test source location tracking
        let loc_str = LocationTracker::location_info();

        // Call LargeParams.runner to test 65 arguments and lambda sum & spec blocks
        let large_sum = LargeParams::runner();

        // Call SpecLambda runner to test lambda spec blocks
        let spec_result = SpecLambda::runner();

        // NOTE: No assertions or prints needed per instruction, just invoke.
        // Variables loc_str, large_sum, spec_result are captured to keep references.
        // (In Aptos framework these calls trigger compilation/runtime testing)
        let _ = (loc_str, large_sum, spec_result);
    }
}

// Featurres:
// b00948efb0b3c8d1dd5276b4014b388d: Track the exact source code location of any value or syntax element within Move files
// d0921d70165ce83b0824987f7aed05f4: Test that a function can have 65 parameters and that all of them are correctly captured and usable in a lambda expression.
// 2611bafe16f9adceb2ab6973cbb59ffe: Attach specification blocks (spec blocks) directly to lambda expressions when using Move version 2.2 or above.
