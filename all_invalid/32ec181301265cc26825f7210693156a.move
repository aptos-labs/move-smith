
//# publish
module 0xCAFE::FriendAndSpec {
    use std::signer;

    friend 0xCAFE::FriendAndSpec;

    struct Counter has store, key {
        value: u64,
    }

    friend fun friend_increment(counter: &mut Counter) {
        counter.value = counter.value + 1;
    }

    // Function not marked friend: cannot be called from friends
    public fun public_increment(counter: &mut Counter) {
        counter.value = counter.value + 10;
    }

    spec module {
        // Spec variable for Counter value
        var counter_value: u64;

        // Initialize specification for Counter at an address
        public spec fun init_counter_spec(addr: address) {
            counter_value = 0;
        }

        // Update specification for incrementing counter_value
        public spec fun increment_spec() {
            update counter_value = counter_value + 1;
        }
    }

    public fun create_counter(s: signer) {
        let counter = Counter { value: 0 };
        move_to<Counter>(&s, counter);
    }

    public fun call_friend_increment(s: signer) {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(&s));
        friend_increment(counter_ref);
    }

    public fun call_public_increment(s: signer) {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(&s));
        public_increment(counter_ref);
    }

    // Function uses explicit variable binding in quantifiers in spec
    public spec fun forall_example() {
        // forall x in 0..10
        forall i in 0..10 {
            assert!(i < 10, 100);
        };
    }
}



//# run 0xCAFE::FriendAndSpec::create_counter --signers 0xBEEF



//# run 0xCAFE::FriendAndSpec::call_public_increment --signers 0xBEEF



//# run 0xCAFE::FriendAndSpec::call_friend_increment --signers 0xBEEF
