
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