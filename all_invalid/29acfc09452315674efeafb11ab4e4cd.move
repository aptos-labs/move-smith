//# publish
module 0xCAFE::TypePatterns {
    // 1,4: Bind variables and define generic types
    struct Container<T> {
        inner: T,
    }

    // 2: Optional type parameters in patterns (in spec, where allowed)
    spec Container<T> {
        // Specifying optional type params in patterns for spec
        ensures forall<_b: T> b in vec<_b: T>(Self) ==> true;
    }

    public fun new_container<T>(val: T): Container<T> {
        Container { inner: val }
    }

    public fun get_inner<T>(c: &Container<T>): &T {
        &c.inner
    }

    // 5: Nested loops with break
    public fun test_nested_loops_with_break(): u64 {
        let count = 0u64;
        let outer = 0u64;
        let inner = 0u64;
        // Outer loop
        while (outer < 3u64) {
            inner = 0u64;
            // Inner loop
            while (inner < 3u64) {
                if (inner == 1u64) {
                    break;
                };
                inner = inner + 1;
            };
            // Only increments if the break was hit
            count = count + inner;
            outer = outer + 1;
        };
        count // Should be 3, as inner always breaks at 1
    }

    // 6: Struct field privacy
    struct PrivateStruct { v: u64 }

    public fun make_private(): PrivateStruct {
        PrivateStruct { v: 100 }
    }

    public fun get_private(ps: &PrivateStruct): u64 {
        ps.v
    }

    public fun runner() {
        let c = Self::new_container<u64>(42);
        let val_ref = Self::get_inner<u64>(&c);
        let _val = *val_ref;
        let _break_count = Self::test_nested_loops_with_break();
        let priv = Self::make_private();
        let _priv_val = Self::get_private(&priv);
    }
}
//# run 0xCAFE::TypePatterns::runner --signers 0xCAFE

//# publish
module 0xBEEF::ForeignAccess {
    use 0xCAFE::TypePatterns;

    // 6: Attempt to access fields of TypePatterns::PrivateStruct (should fail if uncommented)
    /*  // Uncommenting this should fail, demonstrating private field access protection
    public fun fail_get(ps: &TypePatterns::PrivateStruct): u64 {
        ps.v
    }
    */
    public fun test_foreign_usage() {
        let foo = TypePatterns::make_private();
        // Can't get ps.v directly here!
        // let val = foo.v; // Illegal!
    }
}
//# run 0xBEEF::ForeignAccess::test_foreign_usage --signers 0xBEEF

//# run
script {
    use 0xCAFE::TypePatterns;

    fun main() {
        // 3: No lambda lifting in scripts
        // This is fine. The below is NOT a lambda; just a normal block.
        let c = TypePatterns::new_container<u8>(10);
        let val_ref = TypePatterns::get_inner<u8>(&c);
        let _val = *val_ref;

        let _breaks = TypePatterns::test_nested_loops_with_break();

        // Can't use private struct fields here; must call exported getters.
        let ps = TypePatterns::make_private();
        let _ps_val = TypePatterns::get_private(&ps);
    }
}