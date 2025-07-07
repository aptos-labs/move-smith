// #publish
module 0xCAFE::QuantifiedExpr {
    use std::vector;

    // A helper function to simulate a quantified expression checking forall in a vector<u8>
    public fun forall_vec(v: &vector<u8>, predicate: fun(u8): bool): bool {
        let len = vector::length(v);
        let mut i = 0;
        let mut all_true = true;
        while (i < len) {
            if (!predicate(*vector::borrow(v, i))) {
                all_true = false;
                break;
            };
            i = i + 1;
        };
        all_true
    }

    // Run function to check if all elements in a fixed vector satisfy a condition
    public fun runner(): bool {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 5);
        vector::push_back(&mut v, 10);
        vector::push_back(&mut v, 20);

        // Check predicate: all elements >= 5
        let result = forall_vec(&v, fun(x: u8): bool { x >= 5 });
        result
    }
}
// #run 0xCAFE::QuantifiedExpr::runner

// #publish
module 0xCAFE::NameBindingRangeList {
    // This module demonstrates binding names to unbound variables within a range-list,
    // using a simple function to unpack and bind multiple variables extracted from a tuple.

    public struct Data has copy, drop, store {
        a: u8,
        b: u64,
        c: bool,
    }

    // Function to bind names to the unbound variables from a tuple returned by another function
    public fun bind_names(): bool {
        let (x, y, z) = get_data();
        // x, y, z bound to values a, b, c respectively
        x > 0 && y > 0 && z == true
    }

    // Returns a tuple to be unpacked and bound by bind_names
    public fun get_data(): (u8, u64, bool) {
        (10, 20, true)
    }
}
// #run 0xCAFE::NameBindingRangeList::bind_names


// #publish
module 0xCAFE::ScriptSpecTest {
    use std::signer;

    // A public script spec for the script below
    spec script {
        requires exists<Balance>(@signer);
        ensures exists<Balance>(@signer);
    }

    struct Balance has key, store {
        value: u64
    }

    // Initialize Balance to test specs
    public fun init_balance(account: &signer) {
        let addr = signer::address_of(account);
        if (!exists<Balance>(addr)) {
            move_to(account, Balance { value: 1000 });
        };
    }

    // Runner callable from script with no args
    public fun check_balance(account: &signer) {
        let addr = signer::address_of(account);
        assert!(exists<Balance>(addr), 1);
    }
}
// #run 0xCAFE::ScriptSpecTest::init_balance --signers 0xCAFE
// #run 0xCAFE::ScriptSpecTest::check_balance --signers 0xCAFE

// #run
script {
    use std::signer;
    use 0xCAFE::ScriptSpecTest;

    fun main(account: signer) {
        ScriptSpecTest::init_balance(&account);
        ScriptSpecTest::check_balance(&account);
    }
}

// Featurres:
// 16ead6b2fc7c931637a6d6bc0d5c08b5: Write quantified expressions using 'forall' to assert that all values satisfy a condition.
// 9307d7438b19976eb40b2b26e0dd31d9: Bind names to unbound variables within a range list during move code translation.
// 916e7988631e0eda4f4ef5f6ecc5844b: Attach specifications to a script for additional assertions or requirements.
