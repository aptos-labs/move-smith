
//# publish
module 0xCAFE::TestFeatures {
    use std::vector;

    // Define a struct Pair instead of using tuple (u8, u8)
    struct Pair has copy, drop, store {
        first: u8,
        second: u8,
    }

    // minimal version constant to test version dependent features
    const MIN_VERSION: u64 = 10;

    // Simple add function to test addition and return fixed u8 value (Feature 1)
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed number 42 independent of sum
        42u8
    }

    // Lambda function (anonymous) usage (Feature 2)
    // We pass two u8 arguments, return their sum
    public fun lambda_sum(a: u8, b: u8): u8 {
        let f: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        f(a, b)
    }

    // Inline function that returns tuple (Feature 3, called across modules)
    public inline fun inline_tuple(x: u8): (u8, u8) {
        (x + 1, x + 2)
    }

    // Function that calls the inline function from this module, returns sum of results (Feature 3)
    public fun call_inline_and_sum(x: u8): u8 {
        let (a, b) = inline_tuple(x);
        a + b
    }

    // Access multiple lvalues in a range-based for - produce vector of Pairs (Feature 4)
    // Here we iterate over two ranges simultaneously by using indices
    public fun multiple_lvalues_in_for(): vector<Pair> {
        let result = vector::empty<Pair>();
        // We cannot use .. syntax. Use a loop with counter instead.
        let i = 0u8;
        while (i < 5) {
            let v1 = i;
            let v2 = i + 5;
            vector::push_back(&mut result, Pair { first: v1, second: v2 });
            i = i + 1;
        };
        result
    }

    // Function that accepts vector of u8 and returns length (Feature 5)
    // NOTE: Move currently does not have an Option type usable here. The provided code assumed optional vector,
    // but the function signature has just vector<u8>.
    public fun optional_vec_length(v: vector<u8>): u64 {
        vector::length(&v) as u64
    }

    // Minimal code that requires a certain language version feature (simulate with constant) (Feature 6)
    public fun check_min_version(): bool {
        // This is only symbolic for version-dependent code.
        // Usually you use `// version(10)]` attribute, but here simulate by const
        if (MIN_VERSION >= 10) {
            true
        } else {
            false
        }
    }
}




//# run 0xCAFE::TestFeatures::add_and_return_fixed --args 10u8 20u8




//# run 0xCAFE::TestFeatures::lambda_sum --args 15u8 25u8




//# run 0xCAFE::TestFeatures::call_inline_and_sum --args 3u8




//# run 0xCAFE::TestFeatures::multiple_lvalues_in_for




//# run 0xCAFE::TestFeatures::optional_vec_length --args vector[1u8,2u8,3u8]




//# run 0xCAFE::TestFeatures::check_min_version
