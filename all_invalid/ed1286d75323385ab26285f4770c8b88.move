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
        let vec = vector::empty<u64>();
        vector::push_back(&mut vec, cmp as u64);
        vector::push_back(&mut vec, sum);

        // Return the comparison result natively which is false here
        cmp
    }
}

//# run 0xCAFE::DiscoverAndInline::runner

// Featurres:
// 3e3de3263e77fb7d25b9d181e8de3f4d: Automatically discover Move source files within specified package directories, ensuring deterministic ordering for consistent error detection.
// ed5d77428056c6b1791d052d844e01f1: Perform access and use checks before inlining functions.
// af7bbb5f7946867a5ab8d7fd684188fa: Allow rewriting of comparison operations in Move 2.2 and above when enabled
