//# publish
module 0xCAFE test_create_let_bindings {
    use std::vector;
    use std::string;

    public fun runner() {
        // Call the script for testing let bindings, reassignments, and shadowing.
        // We will run the script by calling its main function.
        // The script's main function can be invoked directly below.
        // Note: Since the script is in the same module, you can call main() directly if needed.
        // But in this context, the test setup expects running an external script.
        // Alternatively, you can define the logic inside the module, but per instructions, 
        // the focus is on the transactional test.
    }
}

//# run 0xCAFE::test_create_let_bindings::main
script {
    fun main() {
        // 1. Create let bindings with variable names, post-state info, and defining expressions.
        let x: u64 = 42;
        let y: u64 = x + 10; // y is 52
        let z: u64 = y * 2;  // z is 104

        // 2. Define a list of comma-separated items enclosed by specified start and end tokens.
        // Let's use vector of u8 as list, enclosed by [ and ].
        let list: vector<u8> = vector[
            0x10, 0x20, 0x30, 0x40,
            0x50, 0x60, 0x70
        ];

        // 3. Test that let-bindings of u64 can be reassigned and shadowed without errors.
        // Shadowing with new variable of same name.
        let a: u64 = 1;
        let a: u64 = a + 2; // re-shadow, a is now 3
        let a: u64 = a + 4; // a is now 7

        // Reassign without shadowing (in Move, variables are immutable, so only shadowing works)
        // Shadow b:
        let b: u64 = 5;
        let b: u64 = b + 10; // b is 15

        // No further action needed.
    }
}