//# publish
module 0xabcde::test_module {
    fun add(a: u64, b: u64): u64 {
        a + b
    }

    public fun perform_addition(p: u64): u64 {
        // Call add with p and p + 2 to test multiple reassignments
        let temp: u64 = p;
        let result = add(temp, { temp = temp + 2; temp });
        result
    }

    fun type_assertions_and_reassignments(): bool {
        // Declare u32 variable and increment
        let mut _x: u32 = 10;
        _x = _x + 1;

        // Declare u64 variable and increment
        let mut y: u64 = 20;
        y = y + 2;

        // Verify values
        // _x should be 11, y should be 22
        _x == 11 && y == 22
    }

    public fun main() {
        // Verify the addition
        assert!(perform_addition(7) == 9, 0);
        // Verify type assertions and reassignments
        assert!(type_assertions_and_reassignments(), 0);
    }

    // Optional: expose perform_addition as a runner function
    public fun run_perform_addition(p: u64): u64 {
        perform_addition(p)
    }
}

//# run 0xabcde::test_module::main