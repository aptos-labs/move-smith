
//# publish
module 0xBABE::InternalAccess {
    // Internal function only accessible within this module
    fun internal_func() acquires Trait {
        42
    }

    // Public function that calls internal
    public fun call_internal() acquires Trait {
        internal_func()
    }
}


//# publish
module 0xCAFE::AliasTest {
    // Define an alias to the internal module with a different name to test indirect referencing
    alias InternalAlias = 0xBABE::InternalAccess;

    // Public function to invoke internal method via alias
    public fun invoke_internal_via_alias(): u8 {
        InternalAlias::call_internal()
    }
}


//# publish
module 0xCAFE::VisibilityTest {
    use std::signer;

    struct OuterStruct has store, key {
        value: u8
    }

    // Internal function with private visibility
    fun internal_only_function(): u8 {
        7
    }

    // Public function, accessible from scripts
    public fun public_interface(): u8 {
        internal_only_function()
    }
}


//# publish
module 0xCAFE::AliasVisibility {
    alias VisTest = 0xCAFE::VisibilityTest;

    public fun call_internal_via_alias(): u8 {
        VisTest::public_interface()
    }
}


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
            // Confirm x is shadowed
            // Increment i
            i = i + 1;
        };
        // After while loop, check final value
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


//# run 0xCAFE::MainModule::cleanup_bytecode --args b"\x01\x02\x03\x04\x05"

// Expect the resulting bytecode to have the first byte removed, rest unchanged


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 19b3347fb09813cc821a900427f665c5: Define a single main function as the entry point in a script, and ensure the script is omitted if this function is filtered out.
// 8c0b011f40cced98514ac42974aa1159: Use module aliases in attribute values to refer to modules indirectly.
// 0c5654bd569406574cefb2f5df29c13d: Remove the leading label from a sequence of bytecode instructions to clean up or prepare code for further processing.
