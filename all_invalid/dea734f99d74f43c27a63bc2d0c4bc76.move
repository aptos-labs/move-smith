// This transactional test exercises the Move compiler and VM with:
// 1. Friend relationship via 'friend'.
// 2. Use of type union (`|`, `||`) for alternatives.
// 3. Variable coalescing (allocating/reusing variables in single slots).

//# publish
module 0xCAFE::FriendA {
    // 1. Establish a friend relationship.
    friend 0xCAFE::FriendB;

    // 2. Use a type union with '|' and '||'.
    public fun add_or_concat(a: u8 | vector<u8>, b: u8 | vector<u8>): u8 | vector<u8> {
        // Variable coalescing demonstration:
        // The variable `res` is assigned in both branches and will be coalesced.
        let res;
        if (is<u8>(&a) && is<u8>(&b)) {
            let av = as<u8>(a);
            let bv = as<u8>(b);
            res = av + bv;
        } else {
            // At least one is a vector<u8>
            let av: vector<u8> = if (is<u8>(&a)) {
                // Turn single u8 to vector<u8>
                let mut v = vector::empty<u8>();
                vector::push_back(&mut v, as<u8>(a));
                v
            } else {
                as<vector<u8>>(a)
            };
            let bv: vector<u8> = if (is<u8>(&b)) {
                let mut v = vector::empty<u8>();
                vector::push_back(&mut v, as<u8>(b));
                v
            } else {
                as<vector<u8>>(b)
            };
            res = vector::concat(av, bv);
        };
        // Variable coalescing: only `res` is allocated and returned.
        res
    }

    // For testing, expose a runner with no input args.
    public fun run_test(): u8 | vector<u8> {
        // Try adding two u8s
        let x = Self::add_or_concat(10u8, 99u8);   // returns u8
        // Try concatenating u8 and vector<u8>
        let y = Self::add_or_concat(1u8, x"CAFE"); // returns vector<u8>
        // Try concatenating vector<u8>s
        let z = Self::add_or_concat(x"AA", x"BB"); // returns vector<u8>
        // Just return z for VM assertion purposes. All variables get coalesced in optimized build.
        z
    }
}
//# run 0xCAFE::FriendA::run_test --signers 0xCAFE

//# publish
module 0xCAFE::FriendB {
    friend 0xCAFE::FriendA;

    // Use 'friend' ability to call a private of FriendA (not used here directly, just for friend test coverage).
    public fun call_friend_add_or_concat(): u8 | vector<u8> {
        0xCAFE::FriendA::add_or_concat(7u8, x"BE");
    }
}
//# run 0xCAFE::FriendB::call_friend_add_or_concat --signers 0xCAFE

//# run
script {
    use 0xCAFE::FriendA;

    fun main(account: &signer) {
        // Use union type and test variable coalescing in script context
        let a: u8 | vector<u8> = 42u8;
        let b: u8 | vector<u8> = x"01CA";
        let res: u8 | vector<u8> = FriendA::add_or_concat(a, b);
        // res is either u8 or vector<u8>. VM check: just drop the variable.
        res;
    }
}

// Featurres:
// d0d19bd8a0f717efcb2db901463f0233: Declare friend relationships with the 'friend' keyword.
// 1d9154d147857f0fb70908dd2b3e30e5: Use pipe '|' and double pipe '||' syntax to specify alternative types or type unions.
// d3097607e23b946d5eae1e2dece5cd50: Use VariableCoalescing to optimize variable usage by coalescing variables.
