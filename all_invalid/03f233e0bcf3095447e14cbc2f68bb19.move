module 0x1::transactional_test {

    use std::signer;
    use std::vector;
    use std::debug;

    /// A struct that stores a #[persistent] function value.
    struct PersistentFnHolder has key {
        #[persistent]
        func: fn(u64) -> u64,
    }

    /// Store the holder under caller's address
    public fun store_fn_holder(account: &signer, f: fn(u64) -> u64) {
        let holder = PersistentFnHolder { func: f };
        move_to(account, holder);
    }

    /// Retrieve the holder, get the function reference, call it via reference
    public fun call_persistent_fn(account: &signer, input: u64): u64 acquires PersistentFnHolder {
        let holder = borrow_global<PersistentFnHolder>(signer::address_of(account));
        // Take an immutable reference to the #[persistent] function value
        let f_ref = &holder.func;
        // Call the function through the reference
        f_ref(input)
    }

    /// A sample function to persist
    public fun sample_double(x: u64): u64 {
        x * 2
    }

    /// Test mutable reference borrowing and dropping across a while loop.
    public fun test_mut_ref_while_loop() {
        let mut x = 0u64;
        let mut i = 0u64;

        // Loop 5 times, incrementing x by i each time
        while (i < 5) {
            {
                // Borrow mutable reference from local variable x
                let x_ref = &mut x;
                // Assign new value via mutable reference
                *x_ref = *x_ref + i;
                // x_ref is dropped at the end of this block
            }
            i = i + 1;
        }

        // After the loop, x should be 0 + 0 + 1 + 2 + 3 + 4 = 10
        assert!(x == 10, 1001);
    }

    #[test_only]
    public fun transactional_test() {
        // Get the test signer
        let signer = @0x1;
        let account = signer::borrow_signer(&signer);

        // 1. Store PersistentFnHolder with sample_double function
        store_fn_holder(account, sample_double);

        // 2. Call the stored function via reference after retrieval
        let result = call_persistent_fn(account, 21);
        assert!(result == 42, 1002);

        // 3. Test mutable reference borrowing and dropping across while loop
        test_mut_ref_while_loop();

        debug::print(&vector::empty<u8>()); // Dummy debug call to make sure debug is used
    }
}

// Featurres:
// 8db12352c42c4ea104290654dfb2da9d: Test that a function value with the #[persistent] attribute can be safely stored inside a struct, persisted on-chain, and successfully called via a reference after retrieval.
// f37fe173f9d4b68fdd3a281e139f9295: Organize module members with proper syntax and attributes.
// 9ca98640006c2bc250d521235dd91ba5: Test that a mutable reference borrowed from a local variable can be used and dropped correctly across a while loop with assignment to the referenced value.
