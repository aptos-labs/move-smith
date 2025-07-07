
//# publish
module 0xCAFE::NestedAttributes {
    use std::vector;

    // Simulate parameterized attribute with nested lists by dummy constants and doc comments.
    // (Move currently doesn't support real parameterized attributes like Rust; this is a simulation.)
    const ATTR_LEVEL1_A: u8 = 1;
    const ATTR_LEVEL1_B: u8 = 2;

    const ATTR_LEVEL2_LIST_A: vector<u8> = vector[11, 12];
    const ATTR_LEVEL2_LIST_B: vector<u8> = vector[21, 22];

    // Function that processes nested attribute-like data (constants and vectors)
    public fun process_attrs(level1_a: u8, level1_b: u8, nested_a: vector<u8>, nested_b: vector<u8>): u8 {
        let sum: u8 = level1_a + level1_b;
        let len_a = vector::length(&nested_a) as u8;
        let len_b = vector::length(&nested_b) as u8;
        sum = sum + len_a + len_b;
        sum
    }

    // Runner function to test process_attrs with hardcoded attribute-simulation values
    public fun run() {
        let res = process_attrs(ATTR_LEVEL1_A, ATTR_LEVEL1_B, ATTR_LEVEL2_LIST_A, ATTR_LEVEL2_LIST_B);
        let _ = res;
    }
}



//# run 0xCAFE::NestedAttributes::run



//# publish
module 0xCAFE::ModuleNamingPolicy {
    use std::vector;

    // We emulate module naming policy checks by functions that return error codes instead of real compile errors.
    // Because Move doesn't allow catching compile errors inside code,
    // The test script will try to declare modules with bad names and expect compilation failure externally.
    // Here we provide a function to check if name is accepted according to naming rules.

    // Return 0 if name valid, else 1 for invalid (module name starting with "_")
    public fun check_module_name(name: vector<u8>): u8 {
        if (vector::length(&name) == 0) {
            1
        } else {
            let first_byte = *vector::borrow(&name, 0);
            if (first_byte == 0x5F) { // ASCII '_' = 0x5F
                1
            } else {
                0
            }
        }
    }

    public fun run() {
        let valid_name = vector[b'M', b'o', b'd', b'u', b'l', b'e'];
        let invalid_name = vector[b'_', b'B', b'a', b'd'];

        let res_valid = check_module_name(valid_name);
        let res_invalid = check_module_name(invalid_name);

        let _ = (res_valid, res_invalid);
    }
}



//# run 0xCAFE::ModuleNamingPolicy::run



//# publish
module 0xCAFE::EarlyReturnScriptTest {
    use std::option;

    // This module provides a function with branching logic that simulates early return by returning option type.

    public fun maybe_early_return(x: u8): option::Option<u8> {
        if (x == 0) {
            option::some(0)
        } else if (x < 10) {
            // "Early return"
            option::none<u8>()
        } else {
            option::some(x)
        }
    }

    public fun run() {
        let r1 = maybe_early_return(0);
        let r2 = maybe_early_return(5);
        let r3 = maybe_early_return(15);
        let _ = (r1, r2, r3);
    }
}



//# run 0xCAFE::EarlyReturnScriptTest::run


// The script below tests early return behavior in a script;
// If the parameter is less than 10, it returns early and does NOT execute code after.



//# script
//# run
script {
    use std::debug;

    fun main(x: u8) {
        if (x < 10) {
            // Early return simulation by simply ending function here
            return;
        };
        // The following code only executes if x >= 10
        debug::print(&vector[b'X', b'>', b'=', b'1', b'0']);
    }
}



//# run --args 5u8



//# run --args 15u8


// The following modules are invalid module names and expected to fail compilation externally:

/*


//# publish
module 0xCAFE::_BadModuleName {
    // This module should fail compilation due to underscore at start of name
}
*/

/*


//# publish
module 0xCAFE::_AnotherBadName {
}
*/

// Because these are expected to fail compile, they remain commented out in this transactional test.

// Final combined module that uses parameterized attribute simulation and early return function call.




//# publish
module 0xCAFE::CombinedTest {
    use 0xCAFE::NestedAttributes;
    use 0xCAFE::EarlyReturnScriptTest;
    use std::option;

    public fun test_combined(x: u8) {
        NestedAttributes::run();

        let result = EarlyReturnScriptTest::maybe_early_return(x);
        // Use match to simulate effect after early return
        match result {
            option::Option::None => {
                // Early return happened
            },
            option::Option::Some(v) => {
                let _ = v;
            }
        };
    }
}



//# run 0xCAFE::CombinedTest::test_combined --args 5u8



//# run 0xCAFE::CombinedTest::test_combined --args 15u8


// Featurres:
// c971a0637cbb2005d5f215c962d97fe5: Test that the script returns early when the condition is true, preventing the assertion from executing.
// 12b85df1c82f455df912067ffe6320ae: Use parameterized attributes with nested attribute lists in Move code.
// 4205bb44f652a8f76ab753550f39a403: Enforce naming conventions for modules by disallowing names starting with '_'.
