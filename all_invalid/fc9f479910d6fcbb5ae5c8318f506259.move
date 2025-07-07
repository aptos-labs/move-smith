//# publish
module 0x1::PhantomTest {
    struct MyPhantom<T, phantom P> {
        value: u8,
        inner: Inner,
    }

    struct Inner {
        field: u64,
    }

    // runner function, can be called without arguments
    public fun runner(account: &signer) {
        // Make an instance, specifying a concrete type for T and P
        let x = MyPhantom<u8, bool> {
            value: 8,
            inner: Inner { field: 42 },
        };
        let r = test_dotted_and_match(&x);
        // Do nothing with r so compiler cannot optimize it away
        if (r) {
            let _ = 1;
        }
    }

    /// Demonstrate:
    /// - Dotted access to nested field (`mp.inner.field`)
    /// - Phantom parameter (P, unused except as phantom)
    /// - match expression with explicit parentheses (match (*mp).value)
    public fun test_dotted_and_match<T, phantom P>(mp: &MyPhantom<T, P>): bool {
        // Nested struct field access with dotted expression
        let field_val = mp.inner.field;
        let value_check = match (mp.value) {
            8 => true,
            _ => false,
        };
        // Return both checks combined
        value_check && field_val == 42
    }
}

//# run 0x1::PhantomTest::runner --signers 0x1

//# run
script {
    use 0x1::PhantomTest;

    fun main(account: &signer) {
        // Also test dotted expression in scripts and match with parentheses
        let s = PhantomTest::MyPhantom<u64, bool> {
            value: 10,
            inner: PhantomTest::Inner { field: 77 },
        };
        let inner_val = s.inner.field;
        let r = match (s.value) {
            10 => inner_val,
            _ => 0,
        };
        // Do nothing with r except dummy use
        let _ = r;
    }
}