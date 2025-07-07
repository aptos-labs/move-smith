
//# publish
module 0xCAFE::NativeStructsExample {
    // Declaring native structs that the Move VM handles outside Move language.
    native struct NativeStruct1 has store, drop, copy, key;
    native struct NativeStruct2 has store, drop, copy;

    // Using a native struct as a resource with a key
    struct Wrapper has key, store {
        inner: NativeStruct1
    }

    public fun create_wrapper(): Wrapper acquires NativeStruct1 {
        // Just create a Wrapper with an uninitialized NativeStruct1 (native)
        // For simulation, we use a dummy_wrapper function native implemented.
        dummy_wrapper()
    }

    native fun dummy_wrapper(): Wrapper;
}


//# publish
module 0xCAFE::MemberAliasValidator {
    // This module stores some member names and validates them before usage.

    const VALID_MEMBER_0: &vector<u8> = b"valid";
    const VALID_MEMBER_1: &vector<u8> = b"memberName";
    const INVALID_MEMBER_0: &vector<u8> = b"123startsWithNumber";
    const INVALID_MEMBER_1: &vector<u8> = b"name with spaces";

    public fun is_valid_member_name(name: &vector<u8>): bool {
        // Check that the name first character is alphabetic (a-z or A-Z)
        // and contains only alphanumerics or underscore (for simplicity, we check ascii ranges)
        if (vector::is_empty(name)) {
            false
        } else {
            let first_char = *vector::borrow(name, 0);
            let is_alpha = (first_char >= 65u8 && first_char <= 90u8) || (first_char >= 97u8 && first_char <= 122u8);
            if (!is_alpha) {
                false
            } else {
                let len = vector::length(name);
                let i = 1;
                while (i < len) {
                    let c = *vector::borrow(name, i);
                    let is_valid_char =
                        (c >= 65u8 && c <= 90u8) || // A-Z
                        (c >= 97u8 && c <= 122u8) || // a-z
                        (c >= 48u8 && c <= 57u8) || // 0-9
                        (c == 95u8); // underscore '_'
                    if (!is_valid_char) {
                        return false;
                    };
                    i = i + 1;
                };
                true
            }
        }
    }

    public fun validate_all(): bool {
        // This function checks all above const names and returns true if all valid ones pass 
        // and invalid ones fail the is_valid_member_name test.
        let valid0 = is_valid_member_name(VALID_MEMBER_0);
        let valid1 = is_valid_member_name(VALID_MEMBER_1);
        let invalid0 = !is_valid_member_name(INVALID_MEMBER_0);
        let invalid1 = !is_valid_member_name(INVALID_MEMBER_1);
        valid0 && valid1 && invalid0 && invalid1
    }
}


//# publish
module 0xCAFE::SumManyArguments {
    // Function to sum exactly 65 u64 arguments.
    public fun sum_65(
        a0: u64,  a1: u64,  a2: u64,  a3: u64,  a4: u64,
        a5: u64,  a6: u64,  a7: u64,  a8: u64,  a9: u64,
        a10: u64, a11: u64, a12: u64, a13: u64, a14: u64,
        a15: u64, a16: u64, a17: u64, a18: u64, a19: u64,
        a20: u64, a21: u64, a22: u64, a23: u64, a24: u64,
        a25: u64, a26: u64, a27: u64, a28: u64, a29: u64,
        a30: u64, a31: u64, a32: u64, a33: u64, a34: u64,
        a35: u64, a36: u64, a37: u64, a38: u64, a39: u64,
        a40: u64, a41: u64, a42: u64, a43: u64, a44: u64,
        a45: u64, a46: u64, a47: u64, a48: u64, a49: u64,
        a50: u64, a51: u64, a52: u64, a53: u64, a54: u64,
        a55: u64, a56: u64, a57: u64, a58: u64, a59: u64,
        a60: u64, a61: u64, a62: u64, a63: u64, a64: u64
    ): u64 {
        let s0 = a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9;
        let s1 = a10 + a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19;
        let s2 = a20 + a21 + a22 + a23 + a24 + a25 + a26 + a27 + a28 + a29;
        let s3 = a30 + a31 + a32 + a33 + a34 + a35 + a36 + a37 + a38 + a39;
        let s4 = a40 + a41 + a42 + a43 + a44 + a45 + a46 + a47 + a48 + a49;
        let s5 = a50 + a51 + a52 + a53 + a54 + a55 + a56 + a57 + a58 + a59;
        let s6 = a60 + a61 + a62 + a63 + a64;
        s0 + s1 + s2 + s3 + s4 + s5 + s6
    }

    // Wrapper function calling sum_65 with 0..64 inclusive (65 arguments)
    public fun sum_0_to_64(): u64 {
        sum_65(
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
            10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
            20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
            30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
            40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
            50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
            60, 61, 62, 63, 64
        )
    }
}


//# run 0xCAFE::NativeStructsExample::dummy_wrapper


//# run 0xCAFE::MemberAliasValidator::validate_all


//# run 0xCAFE::SumManyArguments::sum_0_to_64


// Featurres:
// c56bfafaf415b862617fe07b2aa5805f: Declare native structs that are implemented outside Move.
// 15bf487ffac07bc955b6ba19d2f96cd5: Validate module member alias names to ensure they meet naming standards before usage.
// 02c17bd545c75accdf95e0364664920e: Test that the function correctly sums 65 u64 arguments when invoked.
