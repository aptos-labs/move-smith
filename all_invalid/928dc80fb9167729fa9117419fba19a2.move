
//# publish
module 0xCAFE::AliasAndSpecTest {
    use std::signer as signer_alias;
    use std::vector as v; // alias importing vector module

    // A resource with a stored value
    struct Counter has store, key {
        count: u64
    }

    // Spec variable for record
    spec module {
        static mut counter_value: u64;

        // A spec to ensure counter_value is updated accordingly
        update counter_value {
            Counter::count
        }
    }

    // Initialize Counter resource for the signer
    public fun init(s: signer_alias::Signer) {
        let c = Counter { count: 0 };
        move_to<Counter>(&s, c);
    }

    public fun increment(s: signer_alias::Signer) {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer_alias::address_of(&s));
        counter_ref.count = counter_ref.count + 1;
    }

    public fun try_reassign_let() {
        let x = 10u8;
        // The next line is commented out because it would cause compile error:
        // x = 20u8;
        // So instead, we just declare a new variable with same name:
        let x = 20u8;

        // Using the aliased vector module
        let v1 = v::empty<u8>();
        // v::push_back(&mut v1, 1);  // This is invalid because v1 is immutable
        // So create mutable variable:
        let v2 = v::empty<u8>();
        v::push_back(&mut v2, 2);
    }

    public fun test_update_spec_var(s: signer_alias::Signer) {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer_alias::address_of(&s));
        counter_ref.count = counter_ref.count + 5u64;
    }
}


//# run 0xCAFE::AliasAndSpecTest::init --signers 0xBEEF


//# run 0xCAFE::AliasAndSpecTest::increment --signers 0xBEEF


//# run 0xCAFE::AliasAndSpecTest::try_reassign_let


//# run 0xCAFE::AliasAndSpecTest::test_update_spec_var --signers 0xBEEF


// Featurres:
// 09b9bc10bb6d43a50cfa42ba4980c25c: Specify an alias for imported modules or members using 'as' in use statements
// fb5ef64b88094984e06ff5d08f6ec515: Update specification variables inside spec blocks using the 'update' keyword.
// 955a753a4d41d31a15930b40c9a7bea8: Test that variables declared with `let` are immutable and cannot be reassigned after initialization.
