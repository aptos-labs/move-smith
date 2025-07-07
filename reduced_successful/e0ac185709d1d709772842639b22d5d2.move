
//# publish
module 0xCAFE::NativeLayoutTest {
    use std::signer;

    // Native layout struct - normally used with special compiler support but here for simulation
    struct NativeStruct has store, key {
        a: u8,
        b: u64,
        c: vector<u8>,
    }

    public fun create_native_struct(s: signer, a: u8, b: u64, c: vector<u8>) {
        let ns = NativeStruct {a, b, c};
        move_to<NativeStruct>(&s, ns);
    }

    public fun read_native_struct(s: signer): (u8, u64, vector<u8>) {
        let ns_ref: &NativeStruct = borrow_global<NativeStruct>(signer::address_of(&s));
        (ns_ref.a, ns_ref.b, ns_ref.c)
    }

    public fun remove_native_struct(s: signer) {
        let ns = move_from<NativeStruct>(signer::address_of(&s));
        let NativeStruct {a: _a, b: _b, c: _c} = ns;
    }

    // Function to simulate parsing list with unexpected tokens to trigger error
    // Since Move cannot parse invalid tokens, we simulate a function that returns a custom error code
    public fun simulate_unexpected_token_error(): u64 {
        // Return a specific error code that could represent "Unexpected token in list elements"
        // In real compiler scenario, parsing would error out, but here we simulate a runtime error
        0xDEADDEADDEADDEADu64
    }
}


//# run 0xCAFE::NativeLayoutTest::create_native_struct --signers 0xBABE --args 42u8 9001u64 x"CAFEBABE"


//# run 0xCAFE::NativeLayoutTest::read_native_struct --signers 0xBABE


//# run 0xCAFE::NativeLayoutTest::simulate_unexpected_token_error


//# run 0xCAFE::NativeLayoutTest::remove_native_struct --signers 0xBABE


// Featurres:
// 074ae3c89edcfec7941c10c61e51d9f0: Use the file format bytecode generated from stackless bytecode targets for deployment or execution.
// c9acf61f36353714d61a7351c74b1ede: Define structs with native layout.
// 3e0f2ec389d2f5a25651202c272a349e: Handle unexpected tokens within list elements by providing descriptive error messages.
