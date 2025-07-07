module 0x1::TestExitStateAnalysis {

    use std::debug;
    use std::signer;

    /// A simple function to add two u64 numbers
    /// Spec includes nested function body for detailed specification
    fun add(a: u64, b: u64): u64 {
        // Implementation
        a + b
    }

    spec add {
        /// Spec for add function:
        /// result = a + b
        post {
            result == a + b;
        }
        // Nested spec block to illustrate nested function body specs
        spec {
            /// Nested function spec: square function
            fun square(x: u64): u64 {
                x * x
            }

            spec {
                post {
                    square(a) == a * a;
                }
            }
        }
    }

    /// Function returning a tuple type with anonymous fields
    /// It returns (u64, bool)
    fun tuple_return(x: u64): (u64, bool) {
        (x, x % 2 == 0)
    }
    
    spec tuple_return {
        post {
            // Postcondition involving anonymous tuple fields '0' and '1'
            result.0 == x;
            result.1 == (x % 2 == 0);
        }
    }

    #[test]
    fun test_exit_state_analysis() {
        // Test that add(2,3) == 5
        let sum = add(2, 3);
        debug::assert(sum == 5, 0);

        // Test nested spec function square inside add spec (not callable at runtime, but for static verification)
        // We'll test square manually here
        let sq = square(4);
        debug::assert(sq == 16, 0);

        // Test the tuple_return function and its tuple fields
        let t = tuple_return(10);
        debug::assert(t.0 == 10, 1);
        debug::assert(t.1 == true, 2);

        let t2 = tuple_return(7);
        debug::assert(t2.0 == 7, 3);
        debug::assert(t2.1 == false, 4);
    }

    /// Since `square` is only in spec, we need to define a runtime equivalent for testing
    fun square(x: u64): u64 {
        x * x
    }

}

// Featurres:
// fba38b4ca80ef898ced04dc8e2b5c071: Use ExitStateAnalysis to analyze function exit states.
// 0b3188b910069a5f4cc923ef2dc33263: Include nested function bodies within spec blocks for detailed specifications.
// 4cf2880fe87afa7d8e339827d2aa4ca1: Declare tuple types with anonymous fields in Move, using the syntax (Type1, Type2, ...), where fields are named '0', '1', etc.
