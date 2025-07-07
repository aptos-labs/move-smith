//# publish
module 0xDABBAD00::InteractionTest {
    use std::signer;

    // Public entry function; can be called from outside scripts
    public entry fun call_internal_functions(s: signer) {
        internal_only_function();
        internal_shadowing_function(42);
    }

    // Function with internal visibility, only callable within this module
    fun internal_only_function() {
        // Perform some internal logic (no-op)
        assert!(true, 0);
    }

    // Function with internal visibility that takes a parameter
    fun internal_shadowing_function(x: u64) {
        // Simulate some internal processing
        let _ = x + 1;
        assert!(x < 1000, 0);
    }

    // Function with a while loop, variable outside loop
    public fun loop_with_shadowing(init_x: u64): u64 {
        let count: u64 = 0;
        let x = init_x;
        while (x < 5) {
            // Shadowing variable x inside the loop by re-binding with mut
            let x = x + 1;
            count = count + x;
        };
        // After loop, x outside remains unchanged
        count
    }

    // Function with nested variables and shadowing inside loop, returning final states
    public fun complex_shadowing(initial: u64): (u64, u64) {
        let outer_x = initial;
        let outer_y = 0;
        while (outer_x < 3) {
            // Shadow by reassigning in a new variable
            let shadow_x = outer_x + 1;
            outer_y = outer_y + shadow_x;
            outer_x = outer_x + 1; // Increment outer_x
        };
        (outer_x, outer_y)
    }
}


//# run 0xDABBAD00::InteractionTest::call_internal_functions --signers 0xBADA55


//# run 0xDABBAD00::InteractionTest::loop_with_shadowing --args 2u64


//# run 0xDABBAD00::InteractionTest::complex_shadowing --args 0u64
