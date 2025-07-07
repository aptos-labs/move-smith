//# publish
module 0xDEAD::test_destructuring_abort {
    struct MyStruct has copy, drop {
        value: u64
    }

    public fun test_abort_and_destructure() {
        let s = MyStruct { value: 42 };
        abort 999; // Aborting after creation
        let MyStruct { value } = s; // Destructuring should never execute
    }
}

//# run 0xDEAD::test_destructuring_abort::test_abort_and_destructure

//# publish
module 0xBADD::callback_resource {
    use 0xBADD::callback_resource;

    // A resource that tracks a counter
    struct Tracker has key {
        count: u64
    }

    // Function to initialize the resource
    public fun init(signer: &signer): () {
        move_to(signer, Tracker { count: 0 });
    }

    // Function that calls a callback which reads the resource
    public fun call_callback(r: &mut Tracker, callback: |&mut Tracker|) {
        callback(r);
    }

    // A callback that modifies the resource
    public fun modify_callback(r: &mut Tracker) {
        r.count += 10;
    }

    // Function to test reentrant callback access
    public fun test_callback_access() {
        let addr = @0xBADD;
        let res: &mut Tracker;
        // Borrow the resource
        res = borrow_global_mut<Tracker>(addr);
        // Call callback that modifies resource
        call_callback(res, |r| modify_callback(r));
        // After callback, resource should be updated
        assert!(res.count == 10);
    }
}

//# run 0xBADD::callback_resource::init --signers 0xBADD
//# run 0xBADD::callback_resource::test_callback_access

//# publish
module 0xC0FFEE::mutable_local_update {
    public fun multiple_increments() : u128 {
        let mut counter: u128 = 0;
        // Increment multiple times within the same function
        counter = inc(&mut counter);
        counter = inc(&mut counter);
        counter = inc(&mut counter);
        counter
    }

    fun inc(x: &mut u128): u128 {
        *x = *x + 1;
        *x
    }
}

//# run 0xC0FFEE::mutable_local_update::multiple_increments