
//# run
script {
    // Call modules from address 0x1, testing module existence and identification
    // Calling functions from aptos_std and aptos_framework modules.
    // These are pseudo-interfaces since we only check their invocation and identification.

    // Call to internal functions indirectly via public functions exposing internal calls

    // Invoke std module functions
    // Note: For test purposes, these calls may be made from test environments
    // They do not modify state but invoke the functions
    // Use signer for permissions if required
    // Here, dummy signer for demo
    
    // These run commands would be executed separately, or you could trigger from test framework
    // e.g.,
    // 0xCAFE::InteractionTest::invoke_std_module --signers 0xBEEF
    // 0xCAFE::InteractionTest::invoke_fw_module --signers 0xBEEF
    // 0xCAFE::InteractionTest::variable_scope_test --signers 0xBEEF
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
        fun internal_func() {
        }

        // Public function that calls internal_func, accessible outside
        public fun call_internal() {
            internal_func();
        }
    }

    
//# publish
    module 0x1::FrameworkModule {
        // Internal function
        fun internal_func_fw() {
        }

        // Public function that calls internal_func_fw
        public fun call_internal_fw() {
            internal_func_fw();
        }
    }

    // Entry point to test external calls to internal functions indirectly
    // These functions are public and can be called from scripts
    public fun invoke_std_module(s: signer.Signer) {
        0x1::StdModule::call_internal();
    }

    public fun invoke_fw_module(s: signer.Signer) {
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
            // Increment x inside loop, shadowing is not allowed, so use mut
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
}
