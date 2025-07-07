
//# publish
module 0xCAFE::DeprecatedModule {
    /// This module is marked as deprecated to trigger warnings when used.
    // deprecated]
    public fun deprecated_func(): u64 {
        42u64
    }
}


//# publish
module 0xCAFE::LoopInvariantModule {
    /// This module tests loops with verification of invariants.

    /// A function that sums numbers from 0 to n (exclusive) using a while loop.
    /// It uses an invariant that `sum = ((i * (i - 1))/2)` and `i <= n`.
    public fun sum_to_n(n: u64): u64 {
        let i = 0u64;
        let sum = 0u64;
        while (i < n) {
            invariant {
                sum == (i * (i - 1)) / 2,
                i <= n
            };
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    /// A runner function that calls sum_to_n with 10
    public fun runner(): u64 {
        sum_to_n(10u64)
    }
}


//# publish
module 0xCAFE::IntegrationModule {
    use 0xCAFE::DeprecatedModule;

    /// A function that calls deprecated func to trigger warning
    public fun call_deprecated(): u64 {
        DeprecatedModule::deprecated_func()
    }
}


//# run 0xCAFE::LoopInvariantModule::runner


//# run 0xCAFE::IntegrationModule::call_deprecated
