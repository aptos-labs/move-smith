//# publish
module 0xCAFE::ShadowUnused {
    /// A module to test shadowing and usage of unused variable `_`
    use std::option;
    use std::vector;

    /// Inline function that multiplies input by 2
    #[inline]
    fun double(x: u64): u64 {
        x * 2
    }

    /// Function that demonstrates shadowing of `_` in argument patterns and local bindings
    public fun shadow_args(_x: u64, _: u64, y: u64): u64 {
        // `_x` is named but unused, second argument is unnamed and unused
        // `y` used for calculation to return something
        y + 1
    }

    /// Function to test local variable shadowing of `_`
    public fun shadow_local_var(): u64 {
        let _ = 1u64; // unused local binding
        let _ = 2u64; // shadow previous
        let res = 3u64;
        res
    }

    /// A function that uses pattern matching with ignored elements `_`
    public fun pattern_match(_: u64, p: vector<u64>): u64 {
        let (first, _) = vector::borrow(p, 0);
        *first
    }

    /// A lambda that uses `_` in parameter, plus inline function call
    public fun lambda_usage(): u64 {
        let f = &move |_: u64, x: u64| -> u64 {
            double(x)  // calls inline function
        };
        f(10, 20)
    }

    /// Runner function for no-arg calls that calls above functions
    public fun runner(): u64 {
        let a = shadow_args(5, 100, 7);
        let b = shadow_local_var();
        let v = vector::empty<u64>();
        vector::push_back(&mut v, 42);
        let c = pattern_match(9, v);
        let d = lambda_usage();
        a + b + c + d
    }

    #[spec]
    fun pure_spec_fun(x: u64): u64 {
        // A pure spec function depends only on input
        x + 10
    }

    #[spec(pure)]
    fun pure_spec_fun2(y: u64): u64 {
        y * 3
    }

    spec module {
        // Using FunctionPurenessChecker we mark pure functions:
        // "pure_spec_fun2" specified with pure attribute, "pure_spec_fun" is not pure
    }
}
//# run 0xCAFE::ShadowUnused::runner --signers 0xCAFE

//# run 0xCAFE::ShadowUnused::shadow_args --signers 0xCAFE --args 123u64 456u64 789u64
//# run 0xCAFE::ShadowUnused::shadow_local_var --signers 0xCAFE
//# run 0xCAFE::ShadowUnused::pattern_match --signers 0xCAFE --args 999u64 vector[u64][7u64,8u64,9u64]
//# run 0xCAFE::ShadowUnused::lambda_usage --signers 0xCAFE

// Featurres:
// 795f129e2575e5eb29c3b7b3bc46adc2: Test the handling and shadowing behavior of the unused variable `_` in local binding, function arguments, pattern matching, and lambdas in Move.
// 24df415c35991088eee1994840d9775c: Create inline functions that can be called from within other functions.
// 96b8be613325ac53132116bcedb223cd: Use the FunctionPurenessChecker to verify function purity within specifications.
