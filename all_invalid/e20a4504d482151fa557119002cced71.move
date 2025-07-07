//# publish
module 0xCAFE::ConstAndRecursion {
    use std::vector;
    use std::assert;

    // Only numeric constants of type u64 are allowed as restrict attributes
    const RESTRICT_CONST1: u64 = 123;
    const RESTRICT_CONST2: u64 = 456;

    // A generic struct that holds a vector with a type parameter
    struct GenericVectorHolder<T> has copy, drop {
        values: vector<T>
    }

    public fun new_generic_vector_holder<T>(values: vector<T>): GenericVectorHolder<T> {
        GenericVectorHolder<T> { values }
    }

    // Recursive functions: odd and even

    public fun odd(n: u64): bool {
        if (n == 0) {
            false
        } else {
            even(n - 1)
        };
    }

    public fun even(n: u64): bool {
        if (n == 0) {
            true
        } else {
            odd(n - 1)
        };
    }

    // Assert expected parity for 5 and 4

    public fun recursion_check() {
        // 5 is odd
        assert!(odd(5), 1001);
        assert!(!even(5), 1002);

        // 4 is even
        assert!(even(4), 1003);
        assert!(!odd(4), 1004);
    }
}

//# run 0xCAFE::ConstAndRecursion::recursion_check

// Featurres:
// 364ac54df3b9f6ae57e35e7dc9088e18: Restrict attribute constants to numeric values of type u64.
// 1df1c75b7c273f1fbf3eb764932c6eec: Use type parameters properly within vector types.
// 10546924630b0d63e2ad2e5573508ba2: Test that the recursive functions `odd` and `even` correctly determine the parity of a number and that `recursion_check` asserts their expected outcomes for input 5 and 4.
