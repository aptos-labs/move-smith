
//# publish
module 0xCAFE::TestModule {
    use std::vector;
    use std::string;

    // Resource R for do() test
    struct R has store, key {
        value: u64,
    }

    // Internal function, should only be accessible within this module
    fun internal_helper(x: u64): u64 {
        x + 42
    }

    // Public function that uses internal helper
    public fun use_internal(x: u64): u64 {
        internal_helper(x)
    }

    // Function that initializes R resource at a given address
    public fun init_r(addr: address, val: u64) {
        move_to<R>(&addr, R { value: val });
    }

    // Function to modify R resource
    public fun modify_r(addr: address, delta: u64) {
        let r_ref: &mut R = borrow_global_mut<R>(addr);
        r_ref.value = r_ref.value + delta;
    }

    // Function that executes do() logic
    public fun do_func(v: u64): bool {
        if (v == 0) {
            false
        } else {
            let addr = @0xBADA;
            if (!exists<R>(addr)) {
                move_to<R>(&addr, R { value: v });
                true
            } else {
                let r_ref: &mut R = borrow_global_mut<R>(addr);
                r_ref.value = r_ref.value + v;
                true
            }
        }
    }
}


//# run 0xCAFE::TestModule::use_internal --args 100u64


//# run 0xCAFE::TestModule::init_r --signers 0xDEAD --args 123u64


//# run 0xCAFE::TestModule::modify_r --signers 0xDEAD --args 10u64


//# run 0xCAFE::TestModule::do_func --args 0u64


//# run 0xCAFE::TestModule::do_func --args 5u64


//# run 0xCAFE::TestModule::do_func --args 10u64


//# run 0xCAFE::TestModule::do_func --args 20u64


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 1a658f6f9dabec2e3b18caae10e6fe91: Test that repeatedly popping bytes from a vector and summing their values correctly results in the expected total (10).
// 1cf57ddf4a49dd6d8ef62268c1145c63: Add a character to a byte buffer by converting it to its ASCII byte representation.
// 20140ea00ed341fcafba319fd50572d4: Verify that the do() function correctly modifies or interacts with the R resource based on the value of v.
