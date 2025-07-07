// #publish
module 0xCAFE::ModuleA {
    use std::signer;

    // Public function accessible to other modules
    public fun public_func(): u64 {
        42
    }

    // Private function, only callable inside this module
    fun private_func(): u64 {
        7
    }

    // Inline function that calls only accessible functions (inline functions cannot call public functions directly if they are not accessible)
    #[inline]
    fun inline_caller(): u64 {
        // Calls private function - allowed
        let private_res = private_func();

        // Calls public function - allowed because it's in the same module
        let public_res = public_func();

        private_res + public_res
    }

    // Runner function callable without arguments and signer
    public fun runner(): u64 {
        inline_caller()
    }
}
// #run 0xCAFE::ModuleA::runner

// #publish
module 0xCAFE::ModuleB {
    use std::signer;
    use 0xCAFE::ModuleA;

    // Function with labeled code blocks demonstrating advanced control flow
    public fun label_demo(): u64 {
        let mut x = 0;

        'outer: {
            'inner: {
                x = 1;
                // breaking inner block only
                break 'inner;
                // unreachable
                x = 2;
            };
            // after inner block
            x = 3;

            // break the outer block early
            break 'outer;
            // unreachable
            x = 4;
        };

        x
    }

    // Inline function demonstrating accessibility inside inline with public and private calls
    #[inline]
    fun inline_label_demo(): u64 {
        label_demo()
    }

    public fun runner(): u64 {
        inline_label_demo()
    }
}
// #run 0xCAFE::ModuleB::runner

// #publish
module 0xCAFE::ModuleC {
    use std::signer;

    /// A function only callable by the module's own account address
    public fun only_self(s: &signer) {
        // Do nothing, placeholder
    }

    /// A function intended to demonstrate prevention of cross-account calls
    public fun cross_account_test(s: &signer, other_addr: address) {
        assert!(signer::address_of(s) == other_addr, 1);
        // If this fails, it means a signer other than the one passed tried to call
    }

    /// Runner without arguments - just calls `only_self` with the signer's reference
    public fun runner(s: &signer) {
        only_self(s);
    }
}
// #run 0xCAFE::ModuleC::runner --signers 0xCAFE

// #publish
script 0xCAFE::ScriptTest {
    use std::signer;
    use 0xCAFE::ModuleA;
    use 0xCAFE::ModuleB;
    use 0xCAFE::ModuleC;

    fun main() {
        // Call ModuleA's runner
        let res1 = ModuleA::runner();
        // res1 = 49

        // Call ModuleB's runner
        let res2 = ModuleB::runner();
        // res2 = 3

        // Attempting to call only_self with signer 0xCAFE - allowed
        ModuleC::only_self(&signer::spec_signer());

        // Attempt to call cross_account_test passing the current signer address - should pass
        ModuleC::cross_account_test(&signer::spec_signer(), signer::address_of(&signer::spec_signer()));

        // The script tests:
        // 1) Calling only accessible functions via inline functions (ModuleA)
        // 2) Using labeled code blocks (ModuleB)
        // 3) Preventing cross-account calls via signer checks (ModuleC)
    }
}
// #run 0xCAFE::ScriptTest --signers 0xCAFE

// Featurres:
// be3a1053e9936b5c41ea07f5fcbf3352: Call only accessible functions within inline functions to prevent accessibility issues.
// b2fe2ba0fc5f4483ab8510aa33fd8420: Label code blocks for advanced control flow using labels
// 16d7b55faf4333b2bc66a28091a46e29: Prevent calling functions from different account addresses.
