//# publish
module 0xCAFE::TestLintAndDestructuring {
    use std::debug;

    struct Point has store {
        x: u64,
        y: u64,
    }

    /// Function with lint skip annotations to suppress unused variables lint
    #[lint(skip="unused_variables")]
    public fun func_with_lint_skip() {
        let unused_var1: u64 = 42;
        let unused_var2: bool = false;
        // just does nothing
    }

    /// Function testing destructuring &mut mutable reference to struct fields using pattern matching
    public fun destructure_and_mutate_ref(p: &mut Point) {
        // Using pattern matching on &mut reference to change fields
        let &mut Point { x, y } = p;
        *x = *x + 10;
        *y = *y + 20;
    }

    /// Runner function to test destructuring and mutation
    public fun runner(): u64 {
        let mut pt = Point { x: 1, y: 2 };
        destructure_and_mutate_ref(&mut pt);
        // Return sum as an indicator of correct mutation
        pt.x + pt.y
    }
}
//# run 0xCAFE::TestLintAndDestructuring::func_with_lint_skip
//# run 0xCAFE::TestLintAndDestructuring::runner

//# publish
module 0xCAFE::TestNestedLoopsBreak {
    /// A function using nested loops with a break on outer conditional
    public fun nested_loops_break_cond(): u64 {
        let mut count: u64 = 0;
        let mut outer_break: bool = false;

        // Outer loop (manual infinite loop simulation with while true pattern)
        while (true) {
            // Inner loop
            let mut inner_count: u64 = 0;
            while (inner_count < 10) {
                count = count + 1;

                if (count == 5) {
                    // Set flag to break outer loop after inner loop break
                    outer_break = true;
                    break; // break inner loop only
                }
                inner_count = inner_count + 1;
            }

            if (outer_break) {
                break; // break outer loop conditionally
            }
        }
        count
    }
}
//# run 0xCAFE::TestNestedLoopsBreak::nested_loops_break_cond

//# run
script {
    use 0xCAFE::TestNestedLoopsBreak;
    use 0xCAFE::TestLintAndDestructuring;

    fun main() {
        // Call nested loops break test
        let nested_result = TestNestedLoopsBreak::nested_loops_break_cond();
        // Call runner that mutates a struct via destructured &mut reference
        let destructure_result = TestLintAndDestructuring::runner();

        // No asserts per instructions, just return combined result
        // Here simply making some use of these variables to avoid unused warnings
        debug::print(&(nested_result + destructure_result));
    }
}

// Featurres:
// 3c50d21bbb4567ffaa575f96d84c2c36: Use attribute-based lint skip annotations on Move functions to suppress specific lints.
// cc70eb75f3379df461262797ddf37abb: Test the ability to destructure and mutate references to struct fields using pattern matching with &mut in Move functions.
// 12114af09de99c2526fd934eda77cf45: Test that nested loops correctly handle break statements with an outer conditional.
