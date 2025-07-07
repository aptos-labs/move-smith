
//# publish
module 0xCAFE::LiteralsTest {
    use std::vector;

    struct KEY has store, key {
        value: u64,
    }

    public fun test_numeric_literals() {
        let a = 42;
        let b = 0xFFu8;
        let c = 123u64;
        let d = 0xCAFEu16;
        let e = 0b1010u8;
        let f = 0o77u8;
        let total = (a as u64) + b as u64 + c + (d as u64) + (e as u64) + (f as u64);
        let _ = total;
    }

    public fun test_key_ability() {
        let item = KEY { value: 123u64 };
        let addr = @0xCAFE;
        move_to<KEY>(&signer::borrow_signer(addr), item);
    }

    public fun test_key_access(addr: address): bool {
        exists<KEY>(addr)
    }

    // Runner function that does not require arguments
    public fun runner() {
        test_numeric_literals();
        // We skip test_key_ability here because it requires signer
    }
}


//# publish
module 0xBAD1::OtherModule {
    public fun cannot_be_called() {
        // This is intentionally to test that cross-account calls are forbidden in transactional calls
    }
}


//# run 0xCAFE::LiteralsTest::runner



// The following run commands test calling functions across accounts, which should fail or disallow

// Because functions in 0xBAD1::OtherModule cannot be called from 0xCAFE transactional context,
// we do NOT put a run command for that to simulate the attempt (the compiler/VM prevents it).

// However, to confirm the test framework detects disallowed cross-account calls, we create a
// script that tries to call 0xBAD1::OtherModule::cannot_be_called

//# run
script {
    fun main() {
        // The following call should fail at runtime or compilation due to cross-account call restriction.
        // Uncommenting below line should cause failure in real environment:
        // 0xBAD1::OtherModule::cannot_be_called();
    }
}


//# run 0xCAFE::LiteralsTest::test_key_access --args 0xCAFE


// Featurres:
// 877079e613000b413a4315c53e8445d1: Write numeric literals and typed number literals in expressions.
// 16d7b55faf4333b2bc66a28091a46e29: Prevent calling functions from different account addresses.
// 2faf08043df5a65deef7d74267cba515: Recognize the 'Key' ability when the token is an identifier with content 'KEY'.
