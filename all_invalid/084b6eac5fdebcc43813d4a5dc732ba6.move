
//# publish
module 0xBADD::TestInteraction {
    use std::vector;
    use std::signer;

    // Internal function, should only be accessible within this module
    fun internal_helper(x: u8): u8 {
        x + 10
    }

    // Public function to be called from outside
    public fun call_internal(x: u8): u8 {
        internal_helper(x)
    }

    // Function with variable shadowing and local variable inside and outside loop
    public fun variable_shadowing_and_loops(val: u8): (u8, u8, u8, u8) {
        let a = val;
        let b = 0;
        let c = 0;
        let d = 0;

        // Shadowing outer 'a' with inner 'a'
        let a = a + 1;
        // First loop: update 'b'
        let i = 0;
        while (i < 3) {
            b = b + a;
            i = i + 1;
        };

        // Second loop: update 'c'
        let j = 0;
        while (j < 2) {
            c = c + b;
            j = j + 1;
        };

        // Shadow outer 'a' again inside block
        {
            let a = a * 2;
            d = a + c;
        };

        (a, b, c, d)
    }

    // Function with variable assignments outside and inside while loops
    public fun variable_assignment_with_loops(start: u8): (u8, u8) {
        let count = 0;
        let total = 0;

        // outside loop
        count = start;
        total = 0;

        // inside while loop, updating variables
        while (count < 5) {
            total = total + count;
            count = count + 1;
        };

        (count, total)
    }

    // Function to test address dependency (address scoped)
    public fun address_scoped_module(account: &signer) {
        // Typically, address bound modules are published with address attribute
        // but here just call a function as a placeholder
        let _ = internal_helper(5);
        // Prevent unused variable warning
        let _ = account;
    }

    // Run stackless bytecode pipeline on target function (simulate)
    public fun run_bytecode_pipeline() {
        // As this is a simulation, we invoke a function to simulate bytecode processing
        // In real scenario, this call would trigger bytecode pipeline with specific target
        self::bytecode_pipeline_step()
    }

    fun bytecode_pipeline_step() {
        // Dummy placeholder for bytecode transformation step
        // No operation needed, just a no-op to simulate pipeline step
        // Proper code transformation would happen internally
        0
    }

    // Function to test script filtering and transformation rules (placeholder)
    public fun script_management() {
        // This is a placeholder to simulate script filtering/processing
        // In practice, transformations are handled by tooling, not in code
        // We'll simulate by calling a specific function which represents a script
        self::filtered_script_entry()
    }

    fun filtered_script_entry() {
        // Dummy function to represent a filtered script
        // No actual logic, just a placeholder to confirm script filtering
        ()
    }
}


//# run 0xBADD::TestInteraction::call_internal --args 20u8

//# run 0xBADD::TestInteraction::variable_shadowing_and_loops --args 5u8

//# run 0xBADD::TestInteraction::variable_assignment_with_loops --args 2u8

//# run 0xBADD::TestInteraction::address_scoped_module --signers 0xCAFEBABE

//# run 0xBADD::TestInteraction::run_bytecode_pipeline

//# run 0xBADD::TestInteraction::script_management


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 8e23249af117f0d72f0605b772e868a0: Specify attributes for the 'address' block.
// 339d172e6ed0bbfa226a1c86e0d3ed05: Run a stackless bytecode pipeline on specified function targets.
// 9d772f2dfc9e51f96f4a68dcceb3c7e7: Manage script specifications by filtering and transforming them as needed.
