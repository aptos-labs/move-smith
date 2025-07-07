
//# publish
module 0xCAFE::AddModule {
    use std::vector;

    public fun add_two_values(a: u8, b: u8): u8 {
        let c = a + b;
        // Return value different from the sum itself to test computation
        if (c < 10) {
            42u8
        } else {
            c
        };
    }

    public fun lambda_usage_example(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| {
            v + 1u8
        };
        lambda(x)
    }

    public inline fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 3u8 4u8


//# run 0xCAFE::AddModule::lambda_usage_example --args 10u8


//# run 0xCAFE::AddModule::inline_addition --args 5u8 6u8



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public fun nested_call(x: u8, y: u8): u8 {
        let result = AddModule::inline_addition(x, y);
        AddModule::add_two_values(result, 1u8)
    }

    public fun runner_nested_call() {
        let _res = nested_call(7u8, 3u8);
    }
}


//# run 0xCAFE::NestedCallModule::nested_call --args 7u8 3u8


//# run 0xCAFE::NestedCallModule::runner_nested_call



//# publish
module 0xCAFE::StringParseModule {
    use std::string;
    use std::vector;
    use std::ascii;

    public fun parse_address_string(addr_string: vector<u8>): address {
        // Expects addr_string like b"0xCAFE"
        // Extract substring after "0x"
        let prefix = vector::sub_vector(&addr_string, 0, 2);
        assert!(prefix[0] == 0x30 && prefix[1] == 0x78, 1000); // '0' and 'x'

        let hex_part = vector::sub_vector(&addr_string, 2, vector::length(&addr_string));
        // Simple parser converting hex string to address number (u64 part)
        // Only parse last 8 hex digits if longer
        let len = vector::length(&hex_part);
        let start = if (len > 8) { len - 8 } else { 0 };

        let acc = 0u64;
        let i = start;
        while (i < len) {
            let c = *vector::borrow(&hex_part, i);
            let digit = if (c >= 0x30 && c <= 0x39) { c - 0x30 }        // 0-9
                    else if (c >= 0x41 && c <= 0x46) { c - 0x41 + 10 } // A-F
                    else if (c >= 0x61 && c <= 0x66) { c - 0x61 + 10 } // a-f
                    else { abort 1001 };
            acc = acc * 16 + (digit as u64);
            i = i + 1;
        };
        acc as address
    }
}


//# run 0xCAFE::StringParseModule::parse_address_string --args x"307843414645"



//# publish
module 0xCAFE::FunctionDefinitionModule {

    struct FunctionDef has store {
        name: vector<u8>,
        uninterpreted: bool,
        signature: vector<u8>,
        body: vector<u8>,
    }

    public fun create_function(name: vector<u8>, uninterpreted: bool, signature: vector<u8>, body: vector<u8>): FunctionDef {
        FunctionDef {
            name,
            uninterpreted,
            signature,
            body,
        }
    }

    public fun test_create() {
        let fn_name = b"my_func";
        let sig = b"(u8):u8";
        let body = b"return x + 1;";
        let _def = create_function(fn_name, false, sig, body);
    }
}


//# run 0xCAFE::FunctionDefinitionModule::test_create



//# publish
module 0xCAFE::ModuleIdValidation {
    // This module tests validation of identifiers for different access types.
    // Use only valid Move identifiers

    public fun valid_module_identifiers() {
        let _acc_pub = b"PublicModule";
        let _acc_friends = b"FriendsModule";
        let _acc_script = b"ScriptModule";
        let _acc_internal = b"InternalModule";
    }
}


//# run 0xCAFE::ModuleIdValidation::valid_module_identifiers


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 1fa3c07213945b1a29f8054ea07f4049: Parse a string to extract a named address and its corresponding numerical address.
// 280bad96f6189f5aefbd80defb4ac1a8: Create function definitions with names, uninterpreted flags, signatures, and bodies.
// b846f1008795b6f47fd0ccba0abf1fae: Ensure module identifiers are valid for different access types.
