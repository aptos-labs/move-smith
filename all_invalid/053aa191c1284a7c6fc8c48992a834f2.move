
//# publish
module 0xCAFE::NativeLayoutTest {
    use std::signer;
    use std::vector;

    // Native layout structs to test the compiler handling
    struct NativeS has key, store {
        a: u64,
        b: vector<u8>,
    }

    struct ComplexNative has key, store {
        id: u64,
        data: NativeS,
        flags: u8,
    }

    public fun create_native_struct(s: signer) {
        let data = NativeS {
            a: 42u64,
            b: vector[b"native", 0x00, 0x01],
        };
        let obj = ComplexNative {
            id: 7u64,
            data,
            flags: 0xffu8,
        };
        move_to<ComplexNative>(&s, obj);
    }

    public fun inspect_native_struct(s: signer): (u64, u64, u8) {
        let c_ref = borrow_global<ComplexNative>(signer::address_of(&s));
        (c_ref.id, c_ref.data.a, c_ref.flags)
    }

    // Function to test variable coalescing optimization manually by reusing variables
    public fun variable_coalescing_example(x: u64, y: u64): u64 {
        let tmp1 = x + y;
        let tmp2 = tmp1 * 2;
        let tmp1 = tmp2 + 10; // reuse tmp1 variable (simulate coalescing)
        tmp1
    }
}



//# run 0xCAFE::NativeLayoutTest::create_native_struct --signers 0xBEEF



//# run 0xCAFE::NativeLayoutTest::inspect_native_struct --signers 0xBEEF



//# run 0xCAFE::NativeLayoutTest::variable_coalescing_example --args 5u64 7u64




//# publish
module 0xCAFE::ErrorHandlingParse {
    // This module intentionally provides a function that tries to parse a list with an unexpected token,
    // to demonstrate compiler or VM descriptive error messages.
    // Since Move does not have runtime parsing, simulate by parsing strings into vectors with incorrect format.

    use std::vector;

    // A dummy parser that expects a vector<u8> with no zero byte. If zero is present, abort with descriptive error.
    public fun parse_vector(data: vector<u8>): u8 {
        let i = 0;
        // Move does not support mut, so we do a loop with "let i = i + 1" to simulate
        let len = vector::length(&data);
        let idx = 0u64;
        let error_found = false;
        while (idx < len as u64) {
            let val = *vector::borrow(&data, idx as u64);
            if (val == 0) {
                // Unexpected token found (0 byte).
                // Abort with error code 1001 to indicate unexpected token
                abort 1001;
            };
            idx = idx + 1;
        };
        // Return length as u8 for simplicity
        len as u8
    }
}



//# run 0xCAFE::ErrorHandlingParse::parse_vector --args b"abc"

// The following run expects abort due to unexpected token (0 byte)
// Corrected to avoid unsupported escape sequences by directly using vector syntax:


//# run 0xCAFE::ErrorHandlingParse::parse_vector --args vector[97u8, 0u8, 98u8]



//# run 0xCAFE::ErrorHandlingParse::parse_vector --args vector[]



//# run 0xCAFE::ErrorHandlingParse::parse_vector --args vector[1u8, 2u8, 3u8]




//# publish
module 0xCAFE::BytecodeFileFormat {
    use std::vector;
    use std::signer;

    // Dummy struct to test deployment via file format bytecode
    struct Dummy has key, store {
        val: u64,
    }

    public fun deploy_dummy(s: signer, v: u64) {
        let d = Dummy { val: v };
        move_to<Dummy>(&s, d);
    }

    public fun read_dummy(s: signer): u64 {
        let d_ref = borrow_global<Dummy>(signer::address_of(&s));
        d_ref.val
    }
}



//# run 0xCAFE::BytecodeFileFormat::deploy_dummy --signers 0xBABE --args 123u64



//# run 0xCAFE::BytecodeFileFormat::read_dummy --signers 0xBABE


// Featurres:
// 074ae3c89edcfec7941c10c61e51d9f0: Use the file format bytecode generated from stackless bytecode targets for deployment or execution.
// c9acf61f36353714d61a7351c74b1ede: Define structs with native layout.
// 3e0f2ec389d2f5a25651202c272a349e: Handle unexpected tokens within list elements by providing descriptive error messages.
// d3097607e23b946d5eae1e2dece5cd50: Use VariableCoalescing to optimize variable usage by coalescing variables.
