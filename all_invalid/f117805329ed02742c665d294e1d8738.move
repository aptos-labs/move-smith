//# publish
address 0xCAFE {
module LintTest {
    #[skip_lint(unused_assignments)]
    fun ignored_unused_assignments() {
        let x = 10;
        // No usage of x, but the lint should be suppressed.
    }

    // function intentionally ignoring unused variable, suppressing the warning.
    #[skip_lint(unused_variables)]
    public fun suppressed_unused_var() {
        let y = 100;
        // y is never read
    }

    // No skip_lint here; assigning but not reading should trigger the warning
    public fun normal_unused_assignment() {
        let z = 1234;
    }

    /// Entry with variables bound in tuple pat
    #[skip_lint(unused_variables)]
    public fun tuple_binding_and_pattern() {
        let (a, b) = (1, 2);
        // Both variables used, no errors.
        let (c, d) = (3, 4);
        let _ = a + b + c + d;
    }

    // Only defined in this module, cannot perform outside
    fun restricted_operation(x: u64): u64 {
        x * x
    }

    // Expose a runner to demonstrate restricted operation (allowed internally)
    public fun demonstrate_restricted_op(): u64 {
        let x = 7;
        restricted_operation(x)
    }
}
//# run 0xCAFE::LintTest::suppressed_unused_var
//# run 0xCAFE::LintTest::tuple_binding_and_pattern
//# run 0xCAFE::LintTest::demonstrate_restricted_op

module RestrictTest {
    struct Restricted has copy, drop {}

    // This function cannot be called outside, only this module
    fun only_internal_use() {
        let foo = Restricted {};
        consume(foo);
    }

    fun consume(r: Restricted) {
        // pattern match on struct to consume
        let Restricted {} = r;
    }

    // A runner for demo, only calls internal use (valid since both here)
    public fun runner() {
        only_internal_use();
    }
}
//# run 0xCAFE::RestrictTest::runner

}

//# run
script {
    use 0xCAFE::LintTest;
    fun main() {
        // Call a function that returns a value for tuple binding
        let result = LintTest::demonstrate_restricted_op();
        let (x, y) = (result, 5 * 2);
        let _ = x + y;
    }
}

// Featurres:
// c51ebde49c90521f1723c9fbec3f0d8a: Suppress specific lint warnings by annotating your function or module with the attribute #[skip_lint(<checker_name>)]
// bf54b9235fae757d7e57dbcdc5b32977: Restrict specific operations so they can only be performed within the module that defines them.
// 8f4708a36983a0afc6df966ceee90e50: Bind variables to identifiers in patterns
