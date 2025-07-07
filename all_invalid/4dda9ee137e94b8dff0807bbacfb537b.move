module Test::RecursiveAndControlFlowTest {
    use std::debug;
    use std::option;
    use std::vector;

    /// A mutually recursive pair of functions to generate cyclical calls.
    /// Function a calls b if depth > 0, otherwise returns 0.
    /// Function b calls a if depth > 0, otherwise returns 0.
    public fun a(depth: u8): u8 {
        if (depth == 0) {
            0
        } else {
            b(depth - 1)
        }
    }

    public fun b(depth: u8): u8 {
        if (depth == 0) {
            0
        } else {
            a(depth - 1)
        }
    }

    /// A recursive factorial function for additional recursion structure.
    public fun factorial(n: u64): u64 {
        if (n == 0) {
            1
        } else {
            n * factorial(n - 1)
        }
    }

    // This is just a dummy function to simulate "returned set of cyclical paths".
    // Move does not provide introspection/reflection to get the call graph or cyclical paths,
    // but we simulate it by using the mutually recursive calls above.
    public fun cyclical_path_value(depth: u8): u8 {
        // Calls a which calls b which calls a... cycles down to 0
        a(depth)
    }

    /// 2. Test local variable assigned in while loop is still visible & correct after loop completes.
    public fun test_while_loop_local_var(): bool {
        let mut i = 0;
        let mut last_value = 0u64;

        while (i < 5) {
            last_value = i * 10;
            i = i + 1;
        }
        // After the loop, last_value should be 40 (i=4 * 10)
        last_value == 40
    }

    /// 3. Test early return: return early if condition is true, so assertion after never runs.
    public fun test_early_return(cond: bool) {
        if (cond) {
            return;
        }
        // If early return did NOT happen, this will trigger failure (panic)
        debug::assert(false, 1001);
    }

    #[test_only]
    public fun transactional_test() {
        // 1. Test cyclical path call returns expected 0 at depth 10:
        let cyclical_result = cyclical_path_value(10);
        debug::assert(cyclical_result == 0, 1002);

        // 2. Test local variable assigned in while loop
        let while_test_result = test_while_loop_local_var();
        debug::assert(while_test_result, 1003);

        // 3a. Test early return with condition = true (should return early, no assert fail)
        test_early_return(true);

        // 3b. Test early return with condition = false (should panic)
        // This is commented out to avoid test failure. Uncomment to verify panic.
        // test_early_return(false);
    }
}

// Featurres:
// 7a822e252f528a764532c3e7f4858357: Utilize the returned set of cyclical paths to understand the structure of recursive or mutually recursive functions in Move code.
// e6841562ee50111c0389b0465ca3c5c9: Test that the value assigned to a local variable inside a while loop is correctly available after the loop completes.
// c971a0637cbb2005d5f215c962d97fe5: Test that the script returns early when the condition is true, preventing the assertion from executing.
