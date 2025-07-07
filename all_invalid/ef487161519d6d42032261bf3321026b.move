//# publish
module 0xCAFE::LinterConfig {
    use std::vector;

    /// An enum defining possible linters
    struct Linter has copy, drop, store {
        name: vector<u8>,
    }

    /// A resource storing enabled linters
    struct LinterSet has key {
        enabled: vector<vector<u8>>,
    }

    /// Initialize the linter config on the account
    public fun init(account: &signer) {
        let linter_set = LinterSet {
            enabled: vector::empty<vector<u8>>(),
        };
        move_to(account, linter_set);
    }

    /// Enable a linter by name
    public fun enable_linter(account: &signer, linter_name: vector<u8>) {
        let linter_set = borrow_global_mut<LinterSet>(signer::address_of(account));
        vector::push_back(&mut linter_set.enabled, linter_name);
    }

    /// Check if a linter is enabled
    public fun is_enabled(account: address, linter_name: &vector<u8>): bool {
        let linter_set = borrow_global<LinterSet>(account);
        let mut i = 0;
        while (i < vector::length(&linter_set.enabled)) {
            if (vector::borrow(&linter_set.enabled, i) == linter_name) {
                return true;
            }
            i = i + 1;
        }
        false
    }

    /// "Runner" function tests enabling and checking some linters
    public fun runner(signer: &signer) {
        init(signer);
        enable_linter(signer, b"no_unused_vars");
        enable_linter(signer, b"no_shadowing");
        let enabled1 = is_enabled(signer::address_of(signer), &b"no_unused_vars");
        let enabled2 = is_enabled(signer::address_of(signer), &b"no_shadowing");
        let enabled3 = is_enabled(signer::address_of(signer), &b"no_implicit_cast");
        // here just consume the bools to not cause warnings
        let _ = enabled1;
        let _ = enabled2;
        let _ = enabled3;
    }

    native fun native_validator_function(): u64;

    /// A defined function that returns a u64 literal
    public fun defined_function(): u64 {
        42u64
    }

    /// A function to test calling the native and defined functions
    public fun test_functions(signer: &signer) {
        let val1 = defined_function();
        let val2 = native_validator_function();
        let sum = val1 + val2;
        let _ = sum;
    }

    /// Model attribute with u64 literal (model attributes appear as comments in Move)
    // model val_constant: u64 = 1000u64;

    /// Runner function calls the above test functions
    public fun runner2(signer: &signer) {
        test_functions(signer);
    }
}

//# run 0xCAFE::LinterConfig::runner --signers 0xCAFE
//# run 0xCAFE::LinterConfig::runner2 --signers 0xCAFE

///////////////////////
// Native function implementation in the same file for test completeness
// Aptos Move does not allow us to implement native functions in Move source code;
// however, for test purposes and to satisfy the compiler, we declare the function
// as native and comment the implementation below:

/*
native fun 0xCAFE::LinterConfig::native_validator_function(): u64 {
    58u64
}
*/

//# run
script {
    use 0xCAFE::LinterConfig;

    fun main(account: &signer) {
        LinterConfig::init(account);
        LinterConfig::enable_linter(account, b"no_unchecked_arithmetic");
        let enabled = LinterConfig::is_enabled(signer::address_of(account), &b"no_unchecked_arithmetic");
        let _ = enabled;
    }
}

// Featurres:
// ec97d2e34e377a9fff9157a5c5e07d6b: Configure the set of expression linters to apply during code analysis.
// cb2d48b351c3c55b97a8fc4ba45e4001: Use different function body types, such as defined or native, with appropriate validation.
// 88246674b0b0aae5441982b302638d41: Declare model attributes that use u64 literal values.
