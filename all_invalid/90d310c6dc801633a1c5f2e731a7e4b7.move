//# publish
module 0xCAFE::TestAssignments {

    /// Inline function that assigns a new value to its parameter.
    public inline fun inline_assign(mut x: u64) {
        x = 999;
    }

    /// Function that calls inline_assign and returns the original argument to verify it was not changed.
    public fun test_assignment_original_arg(): u64 {
        let value = 123;
        inline_assign(value);
        // value should remain 123 because assignment inside inline function should not affect caller binding
        value
    }

    /// Spec function with explicitly specified return type
    spec fun spec_function_with_return_type(): u64 {
        42
    }

    /// Spec function that uses if_else expression with then and else branches
    spec fun spec_if_else(value: u64): u64 {
        if_else(value > 0, 1, 0)
    }

    /// Spec function that uses if_else expression with then branch only
    spec fun spec_if_then_only(value: bool): bool {
        if_else(value, true, false)
    }

    /// Runner function to check the behavior of inline assignment from Move perspective.
    public fun runner(): u64 {
        test_assignment_original_arg()
    }
}
//# run 0xCAFE::TestAssignments::runner --signers 0xCAFE

// Featurres:
// 00905dd3d71fdef5877e9eb8e033622f: Test that assignments to a function parameter inside an inline function do not affect the original argument in the caller's scope.
// ba65b0a21cd5b5515b25dcf742939b68: Specify the return type of a spec function after a colon.
// 817f78ceb6c33c6b4c3aab22d5889843: Write conditional branches using the `if_else` expression with then and optional else branches.
