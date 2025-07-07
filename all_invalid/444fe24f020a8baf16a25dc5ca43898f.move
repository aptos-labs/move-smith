//# publish
module 0xCAFE::UnitTest {
    // Helper private data structure for internal state testing
    struct Counter has store, drop {
        count: u64,
    }

    // Internal function to initialize Counter
    fun init_counter(): Counter {
        Counter { count: 0 }
    }

    // Internal function to get current counter value
    fun get_counter(counter: &mut Counter): u64 {
        counter.count
    }

    // Script entry point to test variable scope and control flow with while loops
public entry fun scope_control_flow_test(signer: signer) {
        // Initialize local variables
        let outer_var: u8 = 0;
        // Outer while loop
        while (outer_var < 3) {
            // Shadowed inner variable
            let inner_var: u8 = outer_var + 10;
            // Compute inside loop with inner_var
            let _sum = outer_var + inner_var;
            // Increment outer loop variable
            outer_var = outer_var + 1;
        };
    }

    // Script entry point to test variable shadowing and resetting in nested loops
public entry fun shadowing_in_loops(signer: signer) {
        let i: u8 = 0;
        while (i < 2) {
            // Shadow variable i inside loop
            let i_inner: u8 = 5;
            // Use shadowed variable
            let _temp = i_inner + 1;
            // Increment outer variable to break loop
            i = i + 1;
        };
    }

    // Script entry point to test 'loop' with optional label and infinite looping
public entry fun labeled_loop_test(signer: signer) {
        let sum: u64 = 0;
        'outer_loop: loop {
            let i: u64 = 0;
            loop {
                sum = sum + i;
                if (i >= 3) {
                    break;
                };
                i = i + 1;
            };
            // Break outer loop when sum exceeds threshold
            if (sum >= 10) {
                break 'outer_loop;
            };
            // Reset sum for next iteration
            sum = 0;
        };
    }

    // Recursive specification function to verify transitive dependencies
public fun recursive_spec_specifier(depth: u64): bool {
        // Base case
        if (depth == 0) {
            true
        } else {
            // Recursively call itself decrementing depth
            recursive_spec_specifier(depth - 1)
        }
    }

    // Script entry point to test recursive specification tolerance
public entry fun recursive_spec_tolerance(signer: signer, depth: u64) {
        let _result = recursive_spec_specifier(depth);
    }

    // Entry point to test control flow, variable scope, nested loops, and recursion
public entry fun comprehensive_test(signer: signer) {
        // Call scope control flow test
        scope_control_flow_test(signer);
        // Call shadowing test
        shadowing_in_loops(signer);
        // Call labeled loop test
        labeled_loop_test(signer);
        // Call recursive spec test with a specific depth
        recursive_spec_tolerance(signer, 5);
    }
}
