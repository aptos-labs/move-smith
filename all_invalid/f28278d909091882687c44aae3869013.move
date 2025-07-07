module 0x1::transactional_test {

    use std::assert;
    use std::vector;

    /// A generic function that takes a binary function `F` and two inputs `x` and `y`,
    /// applies `F` to them, and returns the result.
    public fun apply<F: copy + drop>(
        f: &fun(u64, u64): u64,
        x: u64,
        y: u64
    ): u64 {
        f(x, y)
    }

    /// Some simple binary functions for testing
    public fun add(x: u64, y: u64): u64 {
        x + y
    }

    public fun mul(x: u64, y: u64): u64 {
        x * y
    }

    /// Test function annotated with conditions using square brackets and properties
    #[test]
    public fun transactional_apply_test() {
        // Leaf expressions and pure calls only (no side effects)
        let a = 2u64;
        let b = 3u64;
        let c = 5u64;

        // First-level apply: add(a, b) = 5
        let res1 = apply(&add, a, b);
        // Second-level apply: mul(res1, c) = 5 * 5 = 25
        let res2 = apply(&mul, res1, c);

        // Conditions annotated with [property] syntax

        // Check that first 'apply' call returns 5 (2 + 3)
        assert::assert_with_attr(res1 == 5, [reason = "apply_call_correctness", level = "critical"]);

        // Check that nested 'apply' correctly computed 25 (5 * 5)
        assert::assert_with_attr(res2 == 25, [reason = "nested_apply_correctness", level = "critical"]);

        // Demonstrate multiple properties in annotation
        assert::assert_with_attr(
            res2 > res1 && res1 > a,
            [reason = "monotonic_increase", tested = "apply_function", severity = "info"]
        );
    }
}

// Featurres:
// 6a92a012959641e21785876cf7955ab5: Annotate conditions with one or more properties using square brackets
// e0857c203b7fb353aa193912b35ecaf7: Write Move expressions that are guaranteed to be free of side effects by using only leaf expressions or pure calls.
// 435fb7fba4dab8a288cac18225732b04: Test that the `apply` function correctly executes a provided binary function on given inputs and returns the combined result, demonstrating nested function applications.
