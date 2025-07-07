
//# publish
module 0xCAFE::PhantomDropStruct {
    // Struct with a phantom type parameter and drop ability
    struct DropStruct<phantom T: copy + drop> has drop {
        value: u64,
        phantom: Phantom<T>,
    }

    // Function to instantiate and drop the struct
    public fun create_and_drop(): () {
        let s = DropStruct<unit> { value: 42, phantom: Phantom };
        // s will be dropped automatically at the end of this function
    }
}



//# publish
module 0xCAFE::InvariantLoop {
    // Struct to hold invariant property
    struct Counter {
        count: u64,
        max: u64,
    }

    // Function with a for loop that violates an invariant
    public fun loop_with_invariant(): () {
        let c = Counter { count: 0, max: 5 };
        let i = 0;
        while (i < c.max) {
            // Increment count
            // But intentionally violate the invariant when count exceeds max
            if (i == 3) {
                // Set count to max + 1 to trigger abort
                // We need to simulate violation: forcibly abort
                abort 42;
            }
            i = i + 1;
        }
    }
}



//# run 0xCAFE::PhantomDropStruct::create_and_drop --signers 0xCAFE


//# run 0xCAFE::InvariantLoop::loop_with_invariant --signers 0xCAFE