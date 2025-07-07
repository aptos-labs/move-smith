// # publish
module 0xCAFE::AliasExample {
    // Original function to be aliased
    public fun original_function(): u64 {
        42
    }

    // Runner function just to be able to call without args
    public fun runner(): u64 {
        original_function()
    }
}
// # run 0xCAFE::AliasExample::runner --signers 0xCAFE

// # publish
module 0xCAFE::LinterControl {
    /// Simulating a linter mechanism with a resource storing excluded linters
    struct ExcludedLinters has key {
        names: vector<vector<u8>>,
    }

    public fun init(account: &signer) {
        move_to(account, ExcludedLinters {
            names: vector::empty<vector<u8>>(),
        });
    }

    public fun exclude_linter(account: &signer, name: vector<u8>) {
        let excluded = borrow_global_mut<ExcludedLinters>(signer::address_of(account));
        vector::push_back(&mut excluded.names, name);
    }

    public fun is_excluded(account: &signer, name: vector<u8>): bool {
        let excluded = borrow_global<ExcludedLinters>(signer::address_of(account));
        let mut i = 0;
        while (i < vector::length(&excluded.names)) {
            if (vector::borrow(&excluded.names, i) == &name) {
                return true;
            }
            i = i + 1;
        }
        false
    }

    // Runner that initializes and excludes a linter named "expensive_lint"
    public fun runner(account: &signer): bool {
        init(account);
        exclude_linter(account, b"expensive_lint");
        is_excluded(account, b"expensive_lint")
    }
}
// # run 0xCAFE::LinterControl::runner --signers 0xCAFE

// # publish
module 0xCAFE::OptimizationTest {
    // A function written in a way that benefits from compiler optimizations (e.g. constant folding)
    public fun sum_constants(): u64 {
        let x = 10u64 + 20u64;
        let y = 30u64 + 40u64;
        x + y  // should be 100u64 after folding
    }

    // A function to test bytecode optimization by repeating a pattern
    public fun loop_sum(): u64 {
        let mut sum = 0u64;
        let mut i = 0u64;
        while (i < 10u64) {
            sum = sum + i;
            i = i + 1;
        }
        sum // 0+1+...+9 = 45u64
    }

    public fun runner(): (u64, u64) {
        let a = sum_constants();
        let b = loop_sum();
        (a, b)
    }
}
// # run 0xCAFE::OptimizationTest::runner --signers 0xCAFE

// # run
script {
    use 0xCAFE::AliasExample as AE;

    fun main() {
        let val = AE::original_function();
        // No assertions needed; run exercises compiler and VM
    }
}

// Featurres:
// 3366b4651af15268a4b0f78792c50b4d: Use the 'as' keyword to create an alias for a name in a 'use' statement.
// 6f0f0cc0f898ebb68a26b83786c2ed94: Exclude specific expression linters from the pipeline based on their names.
// 50be35204c12abb319efdf34d4e63b3d: Take advantage of multiple compiler optimization passes on Move source code and bytecode.
