module 0xCAFE::LogicalOperatorsTest {
    use std::debug;

    // Function to test short-circuit with && (logical AND)
    public fun test_and_short_circuit(x: bool, y: bool): bool {
        // The right side should only evaluate if the left is true
        if (x && {
            // This block only executes if x is true
            // The evaluation of y determines the result
            y
        }) {
            true
        } else {
            false
        };
    }

    // Function to test short-circuit with || (logical OR)
    public fun test_or_short_circuit(x: bool, y: bool): bool {
        // The right side should only evaluate if x is false
        if (x || {
            // This block only executes if x is false
            y
        }) {
            true
        } else {
            false
        };
    }

    // Function to test negation correctly
    public fun test_not(x: bool): bool {
        !x
    }

    // Function to test compound assignment with boolean
    public fun test_compound_assignment(x: bool, y: bool): bool {
        let z = x;
        z = z && y; // z is updated with the conjunction
        z
    }

    // Spec function that will abort if evaluating a certain branch occurs
    public fun abort_if_false(condition: bool): bool {
        if (!condition) {
            abort 999
        };
        true
    }
}