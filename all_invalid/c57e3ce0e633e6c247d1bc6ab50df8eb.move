// This transactional test targets:
// 1. Generating a human-readable interface (API surface) from compiled binary form
// 2. Nested loops with multiple break and continue statements, variable updates,
//    and correct control flow.
// 3. Functions with multiple return values and their usage.

//# publish
module 0xCAFE::InterfaceTest {
    use std::vector;

    // This struct represents a dummy resource to test store/key
    struct Dummy has key, store, drop {
        val: u64,
    }

    /// A public function intended to be part of the interface surface
    public fun get_value(): u64 {
        42u64
    }

    /// Function that returns multiple values (tuple)
    public fun multiple_returns(): (u64, bool) {
        (123u64, true)
    }

    /// Runner function to test multiple returns unpacking and usage
    public fun runner() {
        let (num, flag) = multiple_returns();
        // dummy usage of values to avoid unused var warning
        if (flag) {
            let _ = num + 1;
        } else {
            let _ = num - 1;
        }
    }

    /// Function with nested loops, multiple breaks and continues and variable updates.
    public fun complex_loop_runner(): u64 {
        let mut outer_acc = 0u64;
        let mut i = 0u64;

        while (i < 5) {
            let mut j = 0u64;
            while (j < 5) {
                if (i + j == 5) {
                    // break inner loop when sum is 5
                    break;
                }
                if (j % 2 == 0) {
                    j = j + 1;
                    // continue inner loop on even j
                    continue;
                }
                outer_acc = outer_acc + i * j;
                j = j + 1;
            }
            if (outer_acc > 15) {
                // break outer loop early if accumulator too large
                break;
            }
            i = i + 1;
        }

        outer_acc
    }
}
//# run 0xCAFE::InterfaceTest::runner
//# run 0xCAFE::InterfaceTest::complex_loop_runner

//# run
script {
    use 0xCAFE::InterfaceTest;

    fun main() {
        // Call get_value to test interface surface extraction works for them
        let val = InterfaceTest::get_value();
        let (num, flag) = InterfaceTest::multiple_returns();

        // Use returned values in some trivial operations
        if (flag) {
            let _ = val + num;
        } else {
            let _ = val - num;
        }

        // Call runner - tests multiple returns unpacking and branching
        InterfaceTest::runner();

        // Call complex_loop_runner and ignore result
        let _ = InterfaceTest::complex_loop_runner();
    }
}