// #publish
module 0xCAFE::InliningTest {
    /// An inline function; calls to this will be inlined in the caller
    #[inline]
    public fun add_inline(a: u64, b: u64): u64 {
        a + b
    }

    /// A regular function which uses the inline function
    public fun use_inline(x: u64, y: u64): u64 {
        // The call to add_inline should be inlined here in compilation
        add_inline(x, y)
    }

    /// Runner function to test inlining usage, no args needed
    public fun runner() {
        let _res = use_inline(10, 32);
        // No asserts needed
    }
}
// # run 0xCAFE::InliningTest::runner --signers 0xCAFE

// #publish
module 0xCAFE::LintAndSpecTest {
    /// Function with intentionally complex body to be linted and checked
    public fun linty_fn(n: u8): u8 acquires Account {
        let mut i = 0;
        let mut sum = 0;
        while (i < n) {
            if (i % 2 == 0) {
                sum = sum + i;
            } else {
                sum = sum + (2 * i);
            };
            i = i + 1;
        };
        sum
    }

    /// Function with specification using quantifiers and binds
    spec linty_fn {
        // forall i: u8 :: (i < n && i % 2 == 0) ==> (exists j: u8 :: j == i && 0 <= j)
        ensures forall i: u8; i < n && i % 2 == 0 ==> (result >= i);
        ensures forall i: u8; i < n && i % 2 != 0 ==> (result >= 2 * i);
        // Bind variable example
        let x = n;
        ensures result >= x;
    }

    /// Runner function to call linty_fn
    public fun runner() {
        let _val = linty_fn(5);
    }
}
// # run 0xCAFE::LintAndSpecTest::runner --signers 0xCAFE

// #publish
module 0xCAFE::QuantifierTest {
    use std::vector;

    /// Function that checks if all elements are positive using quantifiers in specs
    public fun all_positive(v: vector<u64>): bool acquires Account {
        let len = vector::length(&v);
        let mut i = 0;
        while (i < len) {
            if (vector::borrow(&v, i) <= &0) {
                return false;
            };
            i = i + 1;
        };
        true
    }

    /// Specification uses forall quantifier over vector indices
    spec all_positive {
        // for all i in range [0, vector_length(v)), v[i] > 0
        ensures result == (forall i: u64; i < vector::length(&v) ==> *vector::borrow(&v, i) > 0);
    }

    /// Runner function exercises the all_positive function
    public fun runner() {
        let v1 = vector::empty<u64>();
        vector::push_back(&mut v1, 1);
        vector::push_back(&mut v1, 2);
        vector::push_back(&mut v1, 5);
        let _res1 = all_positive(v1);

        let mut v2 = vector::empty<u64>();
        vector::push_back(&mut v2, 0);
        vector::push_back(&mut v2, 2);
        let _res2 = all_positive(v2);
    }
}
// # run 0xCAFE::QuantifierTest::runner --signers 0xCAFE


// #run
script {
    use 0xCAFE::InliningTest;
    use 0xCAFE::LintAndSpecTest;
    use 0xCAFE::QuantifierTest;

    fun main() {
        // Call runners from modules to exercise compiler and VM
        InliningTest::runner();
        LintAndSpecTest::runner();
        QuantifierTest::runner();
    }
}

// Featurres:
// 4625b3aabf3f1e50655d70fe22b574f2: Use the inlining process to optimize code by replacing calls to inline functions with their bodies.
// 59c54d46170e9b9dac4684b0ec0a59d0: Allow function bodies to be checked by a variety of lint passes for code quality or correctness.
// 4ef7f031a62e72900b731fc82e1d6ca3: Use quantifiers over ranges and bind variables for them in specifications or logic expressions.
