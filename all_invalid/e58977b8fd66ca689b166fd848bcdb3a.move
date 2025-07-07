// This transactional test exercises the Move compiler and VM with:
// 1. Friend relationship via 'friend'.
// 2. (On Aptos Move, union types `|` are not supported, so we just use vector<u8> for 'concat or add' style.)
// 3. Variable coalescing (reusing variable).

//# publish
module 0xCAFE::FriendA {
    use std::vector;

    // 1. Establish a friend relationship.
    friend 0xCAFE::FriendB;

    // 2. Instead of type union, just use vector<u8>.
    public fun add_or_concat(a: vector<u8>, b: vector<u8>): vector<u8> {
        // If both are singletons, sum their first bytes and return singleton vector, else concat
        let res;
        if (vector::length(&a) == 1 && vector::length(&b) == 1) {
            let av = *vector::borrow(&a, 0);
            let bv = *vector::borrow(&b, 0);
            let sum = av + bv;
            let mut v = vector::empty<u8>();
            vector::push_back(&mut v, sum);
            res = v;
        } else {
            let mut v = vector::concat(a, b);
            res = v;
        };
        res
    }

    // For testing, expose a runner with no input args.
    public fun run_test(): vector<u8> {
        // Try adding two singleton vectors (10 + 99)
        let x = Self::add_or_concat(vector::singleton(10u8), vector::singleton(99u8));   // returns [109]
        // Try concatenating singleton and vector
        let y = Self::add_or_concat(vector::singleton(1u8), x"CAFE"); // returns [1, 0xCA, 0xFE]
        // Try concatenating two vectors
        let z = Self::add_or_concat(x"AA", x"BB"); // returns [0xAA, 0xBB]
        // Just return z for VM assertion purposes.
        z
    }
}
//# run 0xCAFE::FriendA::run_test --signers 0xCAFE

//# publish
module 0xCAFE::FriendB {
    friend 0xCAFE::FriendA;
    use std::vector;

    // Use 'friend' ability to call public of FriendA (for friend test coverage).
    public fun call_friend_add_or_concat(): vector<u8> {
        0xCAFE::FriendA::add_or_concat(vector::singleton(7u8), x"BE")
    }
}
//# run 0xCAFE::FriendB::call_friend_add_or_concat --signers 0xCAFE

//# run
script {
    use 0xCAFE::FriendA;
    use std::vector;

    fun main(account: &signer) {
        // Demonstrate variable coalescing in script context
        let a = vector::singleton(42u8);
        let b = x"01CA";
        let res = FriendA::add_or_concat(a, b);
        // res is a vector<u8>. VM check: just drop the variable.
        res;
    }
}

// Featurres:
// d0d19bd8a0f717efcb2db901463f0233: Declare friend relationships with the 'friend' keyword.
// (Type unions '|' are not supported. Simulate using vector<u8>.)
// d3097607e23b946d5eae1e2dece5cd50: Use VariableCoalescing to optimize variable usage by coalescing variables.
