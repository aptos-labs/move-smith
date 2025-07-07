//# publish
module 0xCAFE::TestLoop {
    struct Counter has copy, drop, store {
        value: u64,
    }

    public fun new_counter(): Counter {
        Counter { value: 0 }
    }

    // Function that returns u64
    public fun get_value(c: &Counter): u64 {
        c.value
    }

    // A helper inline function that increments the counter by 1
    #[inline(always)]
    fun increment(c: &mut Counter): () {
        c.value = c.value + 1;
    }

    // The main loop function with a while loop that modifies the struct inside an inline block
    public fun run_loop(): u64 {
        let mut c = new_counter();
        let mut i = 0u64;
        while (i < 10) {
            { // inline block
                increment(&mut c);
            }
            i = i + 1;
        };
        get_value(&c)
    }
}

//# run 0xCAFE::TestLoop::run_loop

//-----------------------------

//# publish
module 0xCAFE::TestInlineAcc {
    // private inline helper function
    #[inline(always)]
    fun add_two(x: u64): u64 {
        x + 2
    }

    // public function returning u64 that calls the inline function
    public fun call_add_two(x: u64): u64 {
        add_two(x)
    }

    // runner no args, returns u64
    public fun runner(): u64 {
        call_add_two(5)
    }
}

//# run 0xCAFE::TestInlineAcc::runner

//-----------------------------


//# publish
module 0xCAFE::TestReturnTypes {
    // Returns u8 explicitly
    public fun ret_u8(): u8 {
        42u8
    }

    // Returns bool explicitly
    public fun ret_bool(): bool {
        true
    }

    // Returns a vector<u64> explicitly
    public fun ret_vec(): vector<u64> {
        vector::empty<u64>()
    }

    // runner to call all and produce u8 + bool as u8 (casting bool to u8: 1)
    public fun runner(): u8 {
        let v = ret_u8();
        let b = ret_bool();
        let _vec = ret_vec();
        // just use v + (b as u8)
        v + (if b { 1 } else { 0 })
    }
}

//# run 0xCAFE::TestReturnTypes::runner

// Featurres:
// beba1f5415671ca9544da1e91fa5f84a: Test that a while loop with mutable reference modification inside an inline block correctly updates the struct’s field and maintains valid bytecode without verifier errors.
// e686c6b39c3ff01b4561dc22c4ae0e51: Validate that functions involving inline functions have proper accessibility, especially when inlining is pending.
// 9a746c69b3deda200132aaa80170a57f: Specify return types for functions
