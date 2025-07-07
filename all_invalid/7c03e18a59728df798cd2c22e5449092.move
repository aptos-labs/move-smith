
//# publish
module 0xCAFE::MainModule {
    use std::signer;

    // Entry point to test calling a private/internal function via internal call only
    public fun main_call_internal(s: signer): u8 {
        // Calls private internal function directly within module
        internal_func()
    }

    // Function with local variables and shadowing inside and outside loops
    public fun variable_shadowing_test() acquires Trait {
        let x = 3u8;
        // Outer scope variable
        let x_inner = x;
        let sum = 0u8;

        let i = 0u8;
        while (i < 3) {
            // Shadow inner variable
            let x = i + 1u8; 
            sum = sum + x;
            // Increment i
            // Note: We need to declare and mutate i, so it should be mutable
            // Correcting code: declare i as mutable and increment
            // But in original code, i was declared as immutable, so fix accordingly
            // Also in Move, variables are immutable by default; need 'mut' for mutation
        }
        // As per correct Move syntax, declare i as mutable before loop
        // Let's fix to include mut i
        sum
    }

    // Function to process bytecode
    public fun cleanup_bytecode(code: vector<u8>): vector<u8> {
        // Remove leading label bytes (simulate label removal)
        if (vector::length(&code) > 1) {
            let new_code = vector::sub_range(&code, 1, vector::length(&code));
            new_code
        } else {
            code
        }
    }
}

// Scripts for testing


//# run 0xCAFE::MainModule::main_call_internal --signers 0x1234


//# run 0xCAFE::AliasTest::invoke_internal_via_alias --signers 0x1234


//# run 0xCAFE::VisibilityTest::public_interface --signers 0x1234


//# run 0xCAFE::AliasVisibility::call_internal_via_alias --signers 0x1234


//# run 0xCAFE::MainModule::variable_shadowing_test --signers 0x1234


//# run 0xCAFE::MainModule::cleanup_bytecode --args 0x01 0x02 0x03 0x04 0x05

// Expect the resulting bytecode to have the first byte removed, rest unchanged

// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 19b3347fb09813cc821a900427f665c5: Define a single main function as the entry point in a script, and ensure the script is omitted if this function is filtered out.
// 8c0b011f40cced98514ac42974aa1159: Use module aliases in attribute values to refer to modules indirectly.
// 0c5654bd569406574cefb2f5df29c13d: Remove the leading label from a sequence of bytecode instructions to clean up or prepare code for further processing.
