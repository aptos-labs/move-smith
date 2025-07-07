//# publish
module 0xCAFE::DiscoverAndInline {
    use std::vector;

    struct Data has copy, drop, store {
        value: u64,
    }

    /// A simple function to test inlining and comparison rewriting
    public fun is_greater_or_equal(a: u64, b: u64): bool {
        // This will test rewriting of comparison >=
        a >= b
    }

    /// Function with access and use checks to be inlined
    public inline fun compute_sum(a: u64, b: u64): u64 {
        a + b
    }

    /// Runner function to use inlining and comparison
    public fun runner(): bool {
        let v1 = Data {value: 10};
        let v2 = Data {value: 20};

        let cmp = is_greater_or_equal(v1.value, v2.value);

        let sum = compute_sum(v1.value, v2.value);

        // Use vector to exercise package discovery determinism
        let mut vec = vector::empty<u64>();
        // Explicit bool to u64 conversion - in Move we cannot use `as` cast for bool to integer,
        // instead convert bool to u64 as 1 or 0
        let cmp_u64 = if cmp { 1 } else { 0 };
        vector::push_back(&mut vec, cmp_u64);
        vector::push_back(&mut vec, sum);

        // Return the comparison result natively which is false here
        cmp
    }
}

//# run 0xCAFE::DiscoverAndInline::runner