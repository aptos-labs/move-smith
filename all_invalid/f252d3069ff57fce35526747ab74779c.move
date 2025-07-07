
//# publish
module 0xCAFE::TestPatternAndFeatures {
    use std::vector;

    // Function to test pattern matching with rest pattern `..`
    public fun pattern_with_rest(input: vector<u8>): u8 {
        // Pattern matching on vector with rest pattern might be theoretical here
        // assume pattern matching syntax similar to the language, e.g. [a, b, ..rest]
        let result = match (input) {
            [a, b, ..rest] => {
                // sum the first two elements and ignore the rest
                a + b
            },
            [] => {
                0
            },
            [single] => {
                single
            }
        };
        result
    }

    // Function that explicitly enables experimental compiler features via environment variable
    // (Simulated here as a function to demonstrate the concept)
    public fun compile_with_experiment_flags(): bool {
        // supposing the compiler would process environment vars at compile time, here just return true
        true
    }

    // Function with argument types, return types, and abilities
    public fun args_output(
        // type_parameters] T: copy + drop,
        a: customer,
        b: u64
    ): (u64, T) {
        // Return a tuple involving a u64 argument and a generic, maybe just clone or copy
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
// No assertion, just testing pattern matching syntax


//# run 0xCAFE::TestPatternAndFeatures::run_experiment


// Featurres:
// 171c22c0369c26a126b96ee734d1fedb: Write patterns with `..` (dot-dot) syntax to denote a wildcard or rest pattern in pattern matching
// 0d8ec7631103f529e4bcd291dfa33ff7: Enable experimental compiler features by specifying them as a comma-separated list in the MVC_EXP or MOVE_COMPILER_EXP environment variables.
// d0ea86b49fa82ca49eeacce4ffa95cfc: Define functions with argument types, return types, and abilities.
