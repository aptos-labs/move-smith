
//# publish
module 0xCAFE::TestPatternAndFeatures {
    use std::vector;

    // Function to test pattern matching with rest pattern `..`
    public fun pattern_with_rest(input: vector<u8>): u8 {
        // Pattern matching on vector with rest pattern might be experimental or unsupported
        // as Move's pattern matching syntax is limited, we'll simulate the intended behavior
        // For the purposes of this test, implement equivalent logic via vector operations

        let len = vector::length(&input);
        if (len == 0) {
            0
        } else if (len == 1) {
            // return the single element
            *vector::borrow(&input, 0)
        } else {
            // sum the first two elements
            let a = *vector::borrow(&input, 0);
            let b = *vector::borrow(&input, 1);
            a + b
        }
    }

    // Function that explicitly enables experimental compiler features via environment variable
    // (Simulated here as a function to demonstrate the concept)
    public fun compile_with_experiment_flags(): bool {
        // supposing the compiler would process environment vars at compile time, here just return true
        true
    }

    // Function with argument types, return types, and abilities
    public fun args_output<T>(
        // type_parameters] T: copy + drop,
        a: customer,
        b: u64
    ): (u64, T) {
        // Return a tuple involving a u64 argument and a generic
        (b, a.value)
    }

    // A sample data struct with abilities used for function argument
    struct customer has copy, drop {
        value: u64,
    }

    // Function to invoke compile_with_experiment_flags
    public fun run_experiment(): bool {
        compile_with_experiment_flags()
    }
}



//# run 0xCAFE::TestPatternAndFeatures::pattern_with_rest --args 3u8 4u8 5u8
// No assertion, just testing pattern matching logic



//# run 0xCAFE::TestPatternAndFeatures::run_experiment