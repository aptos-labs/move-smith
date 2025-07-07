//# publish
module 0xCAFE::TestParameters {
    use std::debug;

    spec fun add2(x: u64): u64 {
        x + 2
    }

    spec fun add3(x: u64): u64 {
        x + 3
    }

    spec fun test(n: u64): u64 {
        let a = add2(n);
        // Overriding add3 with another entry (simulate by calling original add3):
        add3(a)
    }
}

//# run 0xCAFE::TestParameters::test --args 10u64

// Featurres:
// 2e4ebf04c2d86df71fbc6d8bdd0249a8: Declare parameter lists for spec functions using standard Move syntax.
// ddec74699b6b377bdc840c7840ed3584: Use multiple entries for the same experiment to override previous settings, with later entries taking precedence.
// 08effa9a0e3decf7768175d3490652a8: Test that the `test` function correctly calls `add3` with local variables updated by `add2` and returns the expected sum.
