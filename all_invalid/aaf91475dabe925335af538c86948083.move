// #publish
module 0xCAFE::Math {
    /// Returns the sum of two u64 values
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    /// Returns the difference of two u64 values
    public fun sub(a: u64, b: u64): u64 {
        a - b
    }

    /// Returns the product of two u64 values
    public fun mul(a: u64, b: u64): u64 {
        a * b
    }

    /// Returns the quotient of two u64 values
    public fun div(a: u64, b: u64): u64 {
        a / b
    }
}

// #publish
module 0xCAFE::Inliner {
    use 0xCAFE::Math;

    /// An inlined add which just calls Math::add
    #[inline]
    public fun inline_add(a: u64, b: u64): u64 {
        Math::add(a, b)
    }

    /// An inlined mul which calls Math::mul
    #[inline]
    public fun inline_mul(a: u64, b: u64): u64 {
        Math::mul(a, b)
    }

    /// Calls inline_add and inline_mul and sums their results
    public fun compose_ops(a: u64, b: u64): u64 {
        let sum = inline_add(a, b);
        let product = inline_mul(a, b);
        sum + product
    }

    /// Runner function with no arguments for #run command to test inlining
    public fun runner(): u64 {
        // Use numeric literals with underscores here too
        compose_ops(12_345_678u64, 9_876_543u64)
    }
}
// #run 0xCAFE::Inliner::runner

// #run
script {
    use 0xCAFE::Math;
    use 0xCAFE::Inliner;

    fun main() {
        let a: u64 = 1_000_000_000u64;
        let b: u64 = 2_000_000u64;

        // Test binary operators directly
        let sum = a + b;              // 1,002,000,000
        let diff = a - b;             // 998,000,000
        let product = a * b;          // 2,000,000,000,000,000
        let quotient = a / b;         // 500

        // Test calling module functions for binary ops
        let sum2 = Math::add(a, b);
        let diff2 = Math::sub(a, b);
        let product2 = Math::mul(a, b);
        let quotient2 = Math::div(a, b);

        // Test inlined functions compose correctly
        let composed = Inliner::compose_ops(a, b);

        // Dummy usage so compiler doesn't optimize away
        let _ = (sum, diff, product, quotient, sum2, diff2, product2, quotient2, composed);
    }
}

// Featurres:
// c6e96d7bf91d8c8b134eca57e52c7e79: Write binary operations (e.g., +, -, *, /) between two expressions.
// 3f5c63826c1b1169c8804295ff1fe53f: Test that inlined public functions can be called through multiple module boundaries and properly compose their inlining and execution results.
// b60113de45fdd90b8bb0fedae446cf1f: Write decimal integer literals using digits and underscores as separators
