// Test file for Move compiler and VM transactional test

// Using address 0xCAFE as requested

//# publish
module 0xCAFE::ModuleNumberTokens {
    /// Test using number tokens as literals, ensuring no immediate '::' after number.
    /// Define a constant, a function returning a number token, and using number token in expressions.

    const TEN: u64 = 10;

    public fun get_twenty(): u64 {
        20
    }

    public fun add_ten_and_twenty(): u64 {
        // Using number tokens here
        TEN + 20
    }

    /// Function using a reference and a wildcard import (to be called via run command)
    public fun runner(): u64 {
        add_ten_and_twenty()
    }
}
//# run 0xCAFE::ModuleNumberTokens::runner

//# publish
module 0xCAFE::ModuleWildcardUse {
    use 0xCAFE::ModuleNumberTokens::*;

    public fun call_get_twenty(): u64 {
        // Using wildcard import to call get_twenty()
        get_twenty()
    }

    public fun runner(): u64 {
        call_get_twenty()
    }
}
//# run 0xCAFE::ModuleWildcardUse::runner

//# publish
module 0xCAFE::ModuleSpecBlocks {
    struct S has copy, drop, store {
        val: u8,
    }

    spec module {
        // Spec block with target module (this module)
        struct S { val: u8; }
    }

    spec struct S {
        invariant val < 100;
    }

    public fun new_s(v: u8): S {
        S { val: v }
    }

    public fun runner(): u8 {
        let s = new_s(42);
        s.val
    }
}
//# run 0xCAFE::ModuleSpecBlocks::runner

//# run
script {
    use 0xCAFE::ModuleNumberTokens::*;
    use 0xCAFE::ModuleWildcardUse::*;
    use 0xCAFE::ModuleSpecBlocks::*;

    fun main() {
        let n = add_ten_and_twenty();
        let w = call_get_twenty();
        let v = runner();
        // To test running with no args and no signers.
        let _s_val = ModuleSpecBlocks::runner();
        // Do nothing further, just call functions to exercise VM and compiler
    }
}

// Featurres:
// f337d92facf7294054e6ec20f9974118: Use number tokens to specify numeric values, ensuring they are not immediately followed by '::' to be parsed as literals.
// 66a202cdf3fe7cc0865164a92984daaf: Use the wildcard character '*' in your Move code in contexts where it's permitted, as an alternative to a specific identifier.
// 843cbf156cbc53e45050badafe3d2551: Define 'spec' blocks with target schemas or modules, enabling implicit aliasing of their constituent members.
