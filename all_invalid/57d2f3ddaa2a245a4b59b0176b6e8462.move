
//# publish
module 0xCAFE::SpecLoopHOF {

    use std::vector;
    use std::event;

    /// Event type to test emits specification
    struct SpecEvent has copy, drop, store {
        val: u8,
    }

    /// Struct with key to test modifying global state
    struct Counter has key {
        count: u64,
    }

    /// Initialize Counter resource under an address for modifying
    public fun init_counter(addr: address) acquires Counter {
        if (!exists<Counter>(addr)) {
            move_to<Counter>(&signer::borrow_addr(addr), Counter {count: 0});
        };
    }

    /// Increase counter by delta
    public fun incr_counter(addr: address, delta: u64) acquires Counter {
        let counter_ref = borrow_global_mut<Counter>(addr);
        counter_ref.count = counter_ref.count + delta;
    }

    /// Get count value for checking side effects later
    public fun get_count(addr: address): u64 acquires Counter {
        let counter_ref = borrow_global<Counter>(addr);
        counter_ref.count
    }

    /// Function annotated with diverse specification conditions and labeled loops
    public fun spec_loop_functions(addr: address) acquires Counter {
        // Specification: requires count < 100
        spec requires get_count(addr) < 100;

        // Specification: modifies Counter resource under addr
        spec modifies Counter(addr);

        // Specification: emits SpecEvent with val 42
        spec emits SpecEvent;

        // Specification: ensures count is incremented by exactly 5 after this function
        spec ensures get_count(addr) == old(get_count(addr)) + 5;

        // Abort if count is >= 95 with abort code 9000
        if (get_count(addr) >= 95) {
            abort 9000;
        };

        // Emit event
        let e = SpecEvent { val: 42 };
        event::emit_event(&addr, e);

        // Increase the counter by 5
        incr_counter(addr, 5);

        // Labeled loop with decreases clause to ensure termination
        'outer_loop:
        let i = 10u8;
        while (i > 0) decreases i {
            // Inner labeled loop
            'inner_loop:
            let j = i;
            while (j > 0) decreases j {
                if (j == 3) {
                    // Break inner loop labeled 'inner_loop'
                    break 'inner_loop;
                };
                j = j - 1;
            };
            i = i - 1;
        };
    }

    /// Function demonstrating vector::map usage inside a function with specifications and labeled loops
    public fun map_with_spec_and_loops(addr: address): vector<u8> acquires Counter {
        // Spec: requires count < 90
        spec requires get_count(addr) < 90;

        // Spec: aborts with code 9999 if count is 50
        spec aborts_with 9999;

        if (get_count(addr) == 50) {
            abort 9999;
        };

        // Vector of u8 inputs
        let input_vec = vector[1u8, 2u8, 3u8, 4u8, 5u8];

        // Map with lambda that aborts if element is 4
        let mapped_vec = vector::map(input_vec, |x: u8| {
            if (x == 4) {
                abort 8888;
            };
            x * 2
        });

        // Labeled while loop iterating over mapped_vec
        let len = vector::length(&mapped_vec);
        let idx = 0;
        'traverse_loop:
        while (idx < len) decreases (len - idx) {
            let val = *vector::borrow(&mapped_vec, idx);
            // Call spec_loop_functions to test nested calls and modifies
            spec_loop_functions(addr);
            idx = idx + 1;
        };

        mapped_vec
    }

    /// Inline pure function with ensures specification
    public inline fun inline_ensures_fn(x: u8): u8 {
        spec ensures result > x;
        x + 1
    }

    /// Runner function to initialize counter before all tests
    public fun runner_init(addr: address) {
        // Initialize counter to zero for tests
        if (!exists<Counter>(addr)) {
            move_to<Counter>(&signer::borrow_addr(addr), Counter {count: 0});
        };
    }

    /// Runner function to test spec_loop_functions with no arguments (just addr)
    public fun runner_spec_loop(addr: address) acquires Counter {
        spec_loop_functions(addr);
    }

    /// Runner function to test map_with_spec_and_loops and return vector length
    public fun runner_map_and_loops(addr: address): u64 acquires Counter {
        let v = map_with_spec_and_loops(addr);
        vector::length(&v) as u64
    }

}


//# run 0xCAFE::SpecLoopHOF::runner_init --args 0xBEEF


//# run 0xCAFE::SpecLoopHOF::runner_spec_loop --args 0xBEEF acquires Counter


//# run 0xCAFE::SpecLoopHOF::runner_map_and_loops --args 0xBEEF acquires Counter


// Featurres:
// 9b723eefafdc3c44a323bc61b31a9c2c: Attach different specification condition kinds such as assert, assume, decreases, aborts, aborts with, succeeds if, modifies, emits, ensures, and requires to your Move code to specify behavior.
// e45de59d2cedbb47ca64225d119102b0: Use loop labels in your Move code to mark loops for identification.
// afcd1189a468c5f995c62e3ed503c280: Test that the std::vector::map function correctly maps over constant vectors with lambda functions in an entry function.
