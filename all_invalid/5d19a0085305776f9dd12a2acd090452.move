
//# run
script {
    // Call modules from address 0x1, testing module existence and identification
    // Calling functions from aptos_std and aptos_framework modules.
    // These are pseudo-interfaces since we only check their invocation and identification.

    // For aptos_std, assume a function `fold` exists in some module at 0x1
    // For aptos_framework, assume a function `initialize` exists

    // Since we can't directly invoke real modules in this test snippet,
    // we will assume they have accessible functions named `test_module_exec`.

    // Call aptos_std module from address 0x1
    // (This should just exercise the referencing and module recognition)
    // Similarly for aptos_framework

    // These calls are placeholders; in a real test, you would invoke actual functions.
}

//# publish
module 0xCAFE::InteractionTest {
    use std::signer;
    use std::vector;

    // Module to facilitate internal functions visibility
    // and testing invocation boundaries
//# publish
    module 0x1::StdModule {
        // Internal function, should only be callable within this module
        public fun internal_func() {
        }
        // Public function that calls internal_func
        public fun call_internal() {
            internal_func();
        }
    }

//# publish
    module 0x1::FrameworkModule {
        // Internal function
        public fun internal_func_fw() {
        }
        // Public function that calls internal_func_fw
        public fun call_internal_fw() {
            internal_func_fw();
        }
    }

    // Entry point to test external calls to internal functions indirectly
    public fun invoke_std_module(s: signer) {
        0x1::StdModule::call_internal();
    }

    public fun invoke_fw_module(s: signer) {
        0x1::FrameworkModule::call_internal_fw();
    }

    // Test variable scope and shadowing across loops
    public fun variable_scope_test() {
        let x = 0u64;
        // Outer scope
        let _ = while_loop(x);
        // After loop, check value of x (should be unchanged)
        // For testing purposes, just use x
    }

    fun while_loop(init_x: u64): u64 {
        let x = init_x;
        while (x < 5) {
            // Shadowing is not allowed in move as per rule, use new var instead
            // Simulate variable inside loop
            x = x + 1;
        };
        x
    }

    // Internal function: should only be callable within this module
    fun internal_only_function() {
    }

    // External function trying to call internal, should not compile
    // (not invoked here, just illustrative)
    // public fun external_caller() {
    //     internal_only_function();
    // }

    // This demonstrates that internal functions can't be called outside this module
    // but internal logic here can call it freely.
}

//# run 0xCAFE::InteractionTest::invoke_std_module --signers 0xBEEF

//# run 0xCAFE::InteractionTest::invoke_fw_module --signers 0xBEEF

//# run 0xCAFE::InteractionTest::variable_scope_test --signers 0xBEEF


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 42ea313cce7b739ddd5f5b66f85c3a35: Identify modules residing at the address '0x1' with the names 'aptos_std' or 'aptos_framework' by their module name or numerical address.
