
//# publish
module 0xCAFE::LintSuppressionModule {

    #[skip_lint(unused_variable)]
    public inline fun foo<T, R>(g: witness function(T): R, arg: T): R {
        g(arg)
    }

    #[skip_lint(dead_code)]
    public fun test(): bool {
        let lambda = |x: u64| -> u64 {
            x + 10
        };
        let result = foo(&lambda, 32);
        result == 42
    }
}


//# run 0xCAFE::LintSuppressionModule::test --signers 0xCAFE

// Featurres:
// a21f70c31d56c0c8862aaa45671c6d95: Test that the inline function `foo` correctly calls the provided lambda `g` with the given arguments and returns its result in the `test` function.
// 04655542e1b7366c9fa9bd2314371092: Create names and identifiers composed of letters, digits, and underscores.
// c51ebde49c90521f1723c9fbec3f0d8a: Suppress specific lint warnings by annotating your function or module with the attribute #[skip_lint(<checker_name>)]
