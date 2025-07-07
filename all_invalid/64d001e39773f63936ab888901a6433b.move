//# publish
module 0x1::TestModule {
    use std::debug;
    
    // Error function to test short-circuit behavior
    fun error() {
        // In real tests, this could panic or abort
        debug::print("Error function called!");
        // For testing purposes, simulate an error
        abort 1;
    }

    // The main function that computes the sum and asserts correctness
    #[test(value = 42)]
    public fun main(): bool {
        let a = 10;
        let b = 20;
        let c = 12;
        let sum = a + b + c;
        // Assert that sum equals 42 for the test
        assert!(sum == 42, 1);
        true
    }

    // Function to demonstrate pattern matching with '..' pattern (range)
    fun match_range(value: u64): bool {
        match value {
            0..=99 => {
                // Within range
                true
            },
            ... /* match other cases if needed */
            _ => false,
        }
    }

    // Function to demonstrate let destructuring with '..' pattern
    fun destructure_tuple(t: (u64, u64, u64)): bool {
        let (x, .., z) = t;
        // Do something with x and z
        x < z
    }

    // Function to test short-circuit OR and AND behavior
    #[test(value = true)]
    public fun short_circuit_test(): bool {
        // OR short-circuit: error() should not be called if first operand is true
        let or_result = true || error();
        // AND short-circuit: error() should not be called if first operand is false
        let and_result = false && error();

        assert!(or_result == true, 2);
        assert!(and_result == false, 3);
        true
    }

    // Runner function to run all tests
    public fun run_all_tests(): bool {
        main() && short_circuit_test()
    }
}

//# run 0x1::TestModule::run_all_tests --signers 0x1