
//# publish
module 0xCAFE::TestModulesAtOne {
    native public fun is_aptos_std(name: vector<u8>): bool;
    native public fun is_aptos_framework(name: vector<u8>): bool;

    // Runner function to test checking module names
    public fun run() {
        // simulate module names as vector<u8>
        let std_name = b"aptos_std";
        let framework_name = b"aptos_framework";
        let other_name = b"other_module";

        let _std_check = is_aptos_std(std_name);
        let _framework_check = is_aptos_framework(framework_name);
        let _other_check_std = is_aptos_std(other_name);
        let _other_check_fw = is_aptos_framework(other_name);

        // We also test by direct calls with numerical address
        // but since these are natives, real checks rely on VM/native support
    }
}

//# run 0xCAFE::TestModulesAtOne::run


//# publish
module 0xCAFE::TestInfiniteLoop {
    public fun test_exit_if_true(cond: bool): u8 {
        loop {
            if (cond) {
                return 1u8;
            };
            // If cond is false on first loop, break immediately, should not hit here.
            break;
        };
        2u8
    }

    public fun test_exit_if_false_with_return(cond: bool): u8 {
        loop {
            if (!cond) {
                return 3u8;
            };
            break;
        };
        // Should be reached only when cond == true
        4u8
    }
}


//# run 0xCAFE::TestInfiniteLoop::test_exit_if_true --args true

//# run 0xCAFE::TestInfiniteLoop::test_exit_if_true --args false


//# run 0xCAFE::TestInfiniteLoop::test_exit_if_false_with_return --args true

//# run 0xCAFE::TestInfiniteLoop::test_exit_if_false_with_return --args false


//# publish
module 0xCAFE::TestMacroCalls {
    // Define a simple macro-like function that returns value multiplied by 2
    public fun double(x: u8): u8 {
        x * 2
    }

    // Using a function that mimics macro call with ! and args as call expression
    public fun call_macro_style_1(x: u8): u8 {
        // Simulated macro call as direct function call (no macros really in Move)
        double!(x)
    }

    public fun call_macro_style_2(x: u8): u8 {
        double!(x + 1)
    }
}


//# run 0xCAFE::TestMacroCalls::call_macro_style_1 --args 10u8


//# run 0xCAFE::TestMacroCalls::call_macro_style_2 --args 10u8


// Featurres:
// 42ea313cce7b739ddd5f5b66f85c3a35: Identify modules residing at the address '0x1' with the names 'aptos_std' or 'aptos_framework' by their module name or numerical address.
// b4d4ff053b5c53f8a6af53843a1eadd6: Test that an infinite loop with a conditional return exits immediately when the condition is true, and that code after the loop is not executed when the initial condition is false.
// a41ec282b293eaafccf1998093f292df: Create macro calls by following a name with an exclamation mark '!' and call arguments in parentheses or as a call expression.
