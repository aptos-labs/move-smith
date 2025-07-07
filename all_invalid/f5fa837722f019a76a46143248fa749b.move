//# publish
module 0xCAFE::TestUnused {
    // Function with unused parameter
    public fun unused_param(_x: u64) {
        let y = 10;
        // unused variable y
    }

    // Function with used and unused variables
    public fun mixed_vars() {
        let used_var = 1;
        let _unused_var = 2;
        let _ = used_var + 5;
    }

    // Runner function to be called without arguments
    public fun runner() {
        unused_param(42);
        mixed_vars();
    }
}
//# run 0xCAFE::TestUnused::runner


//# publish
module 0xCAFE::TestByteString {
    use std::string;
    use std::vector;

    // Function that uses byte string literals in expressions
    public fun byte_string_demo() {
        let b1: vector<u8> = b"hello";
        let b2: vector<u8> = b"world";
        // concat byte vectors
        let _concat: vector<u8> = vector::concat(b1, b2);
    }

    public fun runner() {
        byte_string_demo();
    }
}
//# run 0xCAFE::TestByteString::runner


//# publish
module 0xCAFE::TestLanguageItem {
    use std::signer;

    // Use a language item requiring minimum version (e.g. std::signer::address_of)
    public fun get_address_of_signer(s: &signer) {
        let _addr = signer::address_of(s);
    }

    // Runner function needs signer
    public fun runner(s: &signer) {
        get_address_of_signer(s);
    }
}
//# run 0xCAFE::TestLanguageItem::runner --signers 0xCAFE


//# run
script {
    // Simple script using byte string literal directly
    let b: vector<u8> = b"transaction_script";
    let _ = vector::length(&b);
}

// Featurres:
// 5909ed0cbb657584f606bc62ef533156: Check for unused variables and parameters.
// 70157089c4643f61f1ebe6fd55c023c9: Use byte string literals in expressions.
// 1b6e69660f14edaa90ec85de5c9a4c02: Use language items that require a minimum specified language version in your Move code.
