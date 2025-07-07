
//# publish
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
        }
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
        }
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
        }
        true
    }
}


//# run 0xCAFE::LogicalOperatorsTest::test_and_short_circuit --args true false


//# run 0xCAFE::LogicalOperatorsTest::test_and_short_circuit --args false false


//# run 0xCAFE::LogicalOperatorsTest::test_or_short_circuit --args false true


//# run 0xCAFE::LogicalOperatorsTest::test_or_short_circuit --args true false


//# run 0xCAFE::LogicalOperatorsTest::test_not --args true


//# run 0xCAFE::LogicalOperatorsTest::test_not --args false


//# run 0xCAFE::LogicalOperatorsTest::test_compound_assignment --args true true


//# run 0xCAFE::LogicalOperatorsTest::test_compound_assignment --args true false

// Additionally, testing short-circuit behaviors with aborts

//# run 0xCAFE::LogicalOperatorsTest::abort_if_false --args true

//# run 0xCAFE::LogicalOperatorsTest::abort_if_false --args false

// Featurres:
// 40dd5f2d2d0593977243d4dde78a926d: Choose between native spec functions (no body) and defined spec functions (with a statement sequence body).
// 9a83ea05bde3f7af9a00be9002f601c0: Test that logical operators (&& and ||) properly short-circuit and only evaluate the right-hand side when necessary, so aborts only occur when evaluation is required.
// 5cee685862c557c647152db0d4254887: Test the behavior of the logical negation and compound assignment within the function to ensure it correctly evaluates the boolean expressions based on different input values.
