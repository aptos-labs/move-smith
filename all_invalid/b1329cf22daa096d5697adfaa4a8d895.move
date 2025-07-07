
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::event;
    use std::vector;

    // Resource to hold state for testing variable shadowing and loop behaviors
    struct State has store {
        counter: u64,
        outer_var: u64,
    }

    // Helper function to initialize the resource
    public fun init_state(s: &signer): () {
        move_to(s, State { counter: 0, outer_var: 100 });
    }

    // Internal function with local variables, shadowing, and loops
    fun inner_loop(s: &mut State) {
        let outer_var = s.outer_var;
        let i = 0u64;
        while (i < 3) {
            // Shadowing outer variable
            let outer_var = outer_var + i;
            // Inner loop with variable inside
            let j = 0u64;
            while (j < 2) {
                // Assignments within inner loop
                j = j + 1;
            };
            // Increment outer 'i'
            i = i + 1;
        };
        // After loops, verify outer_var remains unchanged
        assert!(s.outer_var == 100, 1001);
        s.counter = s.counter + 1;
    }

    // Public function to run complex nested loops with variable manipulations
    public fun run_loops(s: &mut State): () {
        inner_loop(s);
        // Shadowing in a different scope
        let outer_var = s.outer_var + s.counter as u64;
        for i in 0..2 {
            // Shadowed variable inside for
            let outer_var = outer_var + i;
            // Using inner variable
            let _ = outer_var + i;
        };
        // Modify State to test persistence
        s.outer_var = s.outer_var + 10;
    }

    // Function with event emission based on condition
    struct ValEvent has store, drop {
        val: u64,
    }

    // Resource to emit events
    struct EventCollector {
        events: vector<ValEvent>,
    }

    public fun init_event_collector(s: &signer): () {
        move_to(s, EventCollector { events: vector::empty<ValEvent>() });
    }

    public fun emit_event(s: &signer, val: u64, emit_if: bool) acquires EventCollector {
        let collector_ref: &mut EventCollector = borrow_global_mut<EventCollector>(signer::address_of(s));
        if (emit_if) {
            let event = ValEvent { val };
            event::emit_event(&mut collector_ref.events, event);
        };
    }

    // Attempt unauthorized access to private function/resource should fail (simulate test)
    // It's just a comment for compilers, actual test relies on compile-time; in code we just do access from outside deliberately failing to compile.

    // Entry point to run the tests
    public fun run_all(s: &signer): () {
        // Initialize resources
        Self::init_state(s);
        Self::init_event_collector(s);
        // Run complex behaviors
        let state = borrow_global_mut<State>(signer::address_of(s));
        Self::run_loops(&mut state);
        // Emit event with condition true
        Self::emit_event(s, 42, true);
        // Emit event with condition false (should not emit)
        Self::emit_event(s, 999, false);
        // Attempt unauthorized access - commented out as it intentionally causes compile error if uncommented
        // let _ = borrow_global::<ValEvent>(signer::address_of(s));
    }
}


//# run 0xCAFE::TestModule::run_all --signers 0xBADD



// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 356006e7c78e87219a2731d66d013afc: End the application statement with a semicolon.
// 38fafb719aeb13b8c89946422b7507a2: Declare 'emits' conditions with optional 'to' and 'if' clauses to specify event emissions and associated conditions.
