
//# publish
module 0xCAFE::ModuleKeyAndDisclaimerTest {
    use std::signer;

    // Simulate module key creation by concatenating address and module name
    public fun create_module_key(address: address, module_name: &vector<u8>): vector<u8> {
        let key = vector::empty<u8>();
        let addr_bytes = vector::empty<u8>();
        // Move std currently does not provide direct address to bytes,
        // but for test, we treat address as opaque and pretend to serialize
        // Usually this would require platform-specific std lib, 
        // so here just add dummy bytes for simplicity
        let _ = address; // unused, but placeholder
        // Add address dummy bytes (8 bytes 0xCA to simulate 64bit)
        vector::push_back(&mut key, 0xCA);
        vector::push_back(&mut key, 0xFE);
        vector::push_back(&mut key, 0xBA);
        vector::push_back(&mut key, 0xBE);
        vector::push_back(&mut key, 0x00);
        vector::push_back(&mut key, 0x00);
        vector::push_back(&mut key, 0x00);
        vector::push_back(&mut key, 0x01);
        // Add '_' separator
        vector::push_back(&mut key, b'_'[0]);
        // Append module_name bytes
        let i = 0;
        while (i < vector::length(module_name)) {
            vector::push_back(&mut key, *vector::borrow(module_name, i));
            i = i + 1;
        };
        key
    }

    // DISCLAIMER: This function is externally visible and should have disclaimer comment
    public fun ext_fun_one(): u8 {
        42u8
    }

    // DISCLAIMER: This function is externally visible and should have disclaimer comment
    public fun ext_fun_two(x: u8): u8 {
        internal_helper(x) + 1
    }

    fun internal_helper(x: u8): u8 {
        x * 2
    }

    // DISCLAIMER: Script visible function with disclaimer
    public(script) fun script_fun(s: signer): u8 {
        ext_fun_one() + 1
    }

    // DISCLAIMER: This function calls functions from this module and other module
    public fun combined_calls(s: signer): u8 {
        let x = ext_fun_two(3);
        let y = 0xCAFE::MyModule::f1(4u8, true);
        x + y
    }
}


//# run 0xCAFE::ModuleKeyAndDisclaimerTest::create_module_key --args 0x0CAFE b"TestMod"


//# run 0xCAFE::ModuleKeyAndDisclaimerTest::ext_fun_one


//# run 0xCAFE::ModuleKeyAndDisclaimerTest::ext_fun_two --args 10u8


//# run 0xCAFE::ModuleKeyAndDisclaimerTest::script_fun --signers 0xBEEF


//# run 0xCAFE::ModuleKeyAndDisclaimerTest::combined_calls --signers 0xBEEF



//# publish
module 0xBA5E::AnotherModule {
    // DISCLAIMER: This function is externally visible and should have disclaimer comment
    public fun greet(): u8 {
        1u8
    }
}


//# run 0xBA5E::AnotherModule::greet


// Featurres:
// 017b6b6a632470501fba26c324c0fae5: Create module keys with a specific address and module name when both are available.
// 9e6a4e0412bfe1fa910830ed16dd9897: Insert a disclaimer comment before externally visible functions.
// 19db95b4897be15317116e3fdd089b31: Define functions that call other functions in your Move code.
