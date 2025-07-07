//# publish
module 0x1::PhantomTest {
    // Feature 1: Phantom type parameter
    struct Container<T, phantom U> has key {
        value: T,
    }

    // Feature 2: Known and unknown attributes
    #[test_only] // Known built-in attribute
    #[random_attr] // Unknown attribute, should be ignored by compiler
    fun make_container(val: u64): Container<u64, bool> {
        Container { value: val }
    }

    // Will be called from below
    public fun runner(account: &signer) {
        let c = make_container(42);
        // Just to exercise more execution, let's move Container to the account resource table (to test layout)
        move_to<Container<u64, bool>>(account, c);
    }
}

//# run 0x1::PhantomTest::runner --signers 0xA

//# publish
module 0x1::MatchParenTest {
    // Sample enum to match on
    enum Num {
        One,
        Other(u64),
    }

    public fun match_num(n: Num): u64 {
        // Feature 3: Parentheses around match expression
        match (n) {
            Num::One => 1,
            Num::Other(x) => x,
        }
    }

    public fun runner(_account: &signer) {
        let ans = match_num(Num::One);
        let ans2 = match_num(Num::Other(99));
        // No asserts needed, just run different match branches
    }
}

//# run 0x1::MatchParenTest::runner --signers 0xB

//# run 0x1::PhantomTest::make_container --signers 0xC --args 77u64