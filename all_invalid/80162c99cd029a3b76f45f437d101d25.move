//# publish
module 0xCAFE::ClosureShadowing {

    // We can't define actual closures as Move doesn't support them natively.
    // But we can simulate the behavior via inline "inner" functions that shadow variables
    // and update outer variables.

    /// Holds a value which we will update using shadowing in a nested function
    struct Holder has copy, drop, store, key {
        val: u64,
    }

    public fun new_holder(): Holder {
        Holder { val: 0 }
    }

    fun inner(val_ref: &mut u64) {
        let val = 500u64; // shadow
        *val_ref = val;
    }

    public fun test_shadowing(holder: &mut Holder) {
        let val = &mut holder.val;

        // Outer variable val points to holder.val
        // Now shadow val inside the "closure"
        let val = 100u64;
        // This shadows val but doesn't update the original val

        // We now call an inner function to simulate a closure that updates val
        inner(val);

        // By Move semantics, the outer val which is a ref to holder.val is not updated.
        // To fix that, should have passed &mut *val_ref in inner.
        // But we want to test that shadowing inside inner doesn't affect outer val
        // and the value in holder.val is not changed.
    }

    // Runner function that creates holder and runs test
    public fun runner() {
        let mut holder = new_holder();
        test_shadowing(&mut holder);
        // After test_shadowing, holder.val should still be 0 (unchanged)
    }
}

///# run 0xCAFE::ClosureShadowing::runner



//# publish
module 0xCAFE::LoopReturnTest {

    public fun runner(): u64 {
        let mut x: u64 = 0u64;
        loop {
            x = x + 1;
            if (x > 5) {
                // Loop-return exits the function immediately with value 999
                loop return 999u64;
            }
        };
        // Unreachable code but required because function must return u64
        0u64
    }
}

///# run 0xCAFE::LoopReturnTest::runner



//# publish
module 0xCAFE::ModuleA {
    public fun get_val(): u64 {
        1234u64
    }
}

///# publish
module 0xCAFE::ModuleB {
    use 0xCAFE::ModuleA as A;

    public fun runner(): u64 {
        A::get_val()
    }
}

///# run 0xCAFE::ModuleB::runner