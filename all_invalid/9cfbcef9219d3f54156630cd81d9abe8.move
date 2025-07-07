// This transactional test case exercises:
// 1. Use of peephole optimizations (inc/dec, move_ref optimizations).
// 2. Triggers move_compiler deprecated warnings (with diagnostic codes).
// 3. Empty struct variants.

//# publish
module 0x1::EmptyVariants {
    // ---------------  3. Empty struct variants with no fields --------------
    struct EmptyA has copy, drop {}
    struct EmptyB has key, store {}

    public fun make_empty_a(): EmptyA {
        EmptyA {}
    }

    public fun make_empty_b(): EmptyB {
        EmptyB {}
    }

    // For running: creates both empty variants to exercise VM and type system.
    public fun runner() {
        let _a = make_empty_a();
        let _b = make_empty_b();
        // No assertion or output needed per instructions.
    }
}
//# run 0x1::EmptyVariants::runner --signers 0x1

//# publish
module 0x1::OptimizedOps {
    // ---------------  1. Test peephole-optimizable bytecode sequences --------------

    // This should optimize: let mut x=0; x=x+1; x=x-1; etc.
    public fun inc_dec_peephole() {
        let mut x = 0u64;
        x = x + 1;   // Peephole: inc
        x = x - 1;   // Peephole: dec
        x = x + 2;
        x = x - 1;
        if (x == 1) {
            x = x + 1; // Trivial branch for optimizer
        }
    }

    // Also, test move_ref and borrow_peephole optimization
    public fun move_ref_peephole() {
        let mut y = 10u64;
        let y_ref = &mut y;
        *y_ref = *y_ref + 32;
    }

    // ---------------  3. Use empty struct variant as value -----------------

    use 0x1::EmptyVariants;

    public fun runner() {
        inc_dec_peephole();
        move_ref_peephole();
        let _ = EmptyVariants::make_empty_a();
    }
}
//# run 0x1::OptimizedOps::runner --signers 0x1

//# publish
address 0x42 {
module DeprecatedTest {
    // ---------------  2. Use deprecated items and trigger warnings -----------------
    // Move Framework: No built-in deprecated attribute, simulate by using deprecated syntax and features.
    // Use vector::empty, which is deprecated in Aptos (use vector::new instead)
    public fun use_deprecated_vec_empty() {
        let v = vector::empty<u8>();
        let _ = v;
    }

    // Use an old-style acquires syntax, which emits a warning in some compilers (for exercise, does not fail)
    struct S has key {}

    public fun acquire_deprecated_s(account: &signer) acquires S {
        // Fake acquires usage.
    }

    // Runner to hit both code paths
    public fun runner(account: &signer) {
        use_deprecated_vec_empty();
        acquire_deprecated_s(account);
    }
}
}
//# run 0x42::DeprecatedTest::runner --signers 0x42