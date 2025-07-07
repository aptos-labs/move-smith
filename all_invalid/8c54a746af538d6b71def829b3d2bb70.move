//# publish
module 0xCAFE test_create_let_bindings {
    use std::vector;
    use std::string;

    public fun runner() {
        // This function will call the script to test let bindings, reassignments, and shadowing.
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
        let a: u64 = a + 2; // reassign via shadowing, a is now 3
        let a: u64 = a + 4; // a is now 7

        // Reassign without shadowing (in Move, variables are immutable, so using shadowing only)
        // So, to simulate reassignment, we can re-declare with different name or use shadowing.
        // But in Move, variables are immutable, so reassignments require shadowing.

        // To clarify, shadowing the variable:
        let b: u64 = 5;
        // Shadow b:
        let b: u64 = b + 10; // b is 15

        // Final assertions or outputs (if needed), but per instructions, only code shown.

        // No return - just to test the bindings and list.
    }
}

// Featurres:
// b705033fbf3cb73d4bd53229d6f09878: Create let bindings with variable names, post-state information, and defining expressions.
// dacd6f23f98e36acfc305f197f7d43e0: Define a list of comma-separated items enclosed by specified start and end tokens.
// d86183d03ea910e2ca6c118b6e9b2411: Test that let-bindings of u64 values can be reassigned and shadowed without errors in a Move function.
