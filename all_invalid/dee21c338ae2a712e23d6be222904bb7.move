// #!syntax-check-only
// #!transactional-test

// We use 0xCAFE as the test address

//# publish
module 0xCAFE::FeatureTest {

    use std::signer;

    // Public function: simple arithmetic to test basic function declaration
    public fun add_u64(a: u64, b: u64): u64 {
        a + b
    }

    // Public module function with mutable reference argument, modifies the value pointed
    public fun increment_mut_ref(value: &mut u64) {
        *value = *value + 1;
    }

    // Public inline function to test inline function declaration
    public inline fun double_u8(x: u8): u8 {
        x * 2
    }

    // Public function which calls increment_mut_ref to test mutable reference freezing in call
    public fun freeze_mut_ref_in_call(value: &mut u64): u64 {
        // Freeze &mut u64 to &u64 temporarily by borrowing immutably
        let r: &u64 = value;  // implicit freeze here
        *r
    }

    // Function returning the sum from immutable ref and mutable ref frozen and used
    public fun sum_frozen_refs(a: &u64, b: &mut u64): u64 {
        let b_imm = b; // freeze mutable ref b to immutable
        *a + *b_imm
    }

    // Function to test freezing in assignments and conditionals
    public fun freeze_refs_conditional(value: &mut u64): u8 {
        let imm_ref = value; // freeze mut to imm
        if *imm_ref > 0 {
            1u8
        } else {
            0u8
        }
    }

    // Function to test nested mutable ref freezing in borrowing
    public fun nested_freeze(value: &mut u64): u64 {
        let imm_ref_outer = value; // freeze first
        let mut inner_val = *value;
        let imm_ref_inner = &inner_val; // &u64 to a local copy
        *imm_ref_outer + *imm_ref_inner
    }

    // Spec declarations - no processing of unbound names inside their contents
    spec module {
        // unbound spec function
        spec fun spec_func(x: u64): u64 {
            x + unbound_var
        }

        // unbound spec variable
        spec const spec_var: u64 = unbound_expr;

        // unbound spec let
        spec let spec_let = some_unbound_spec_function();

        // unbound spec include
        include unbound_include;

        // unbound apply block
        apply unbound_apply_block {}

        // unbound pragma
        pragma unbound_pragma;
    }

    // Runner function to call multiple tests without args or signers
    public fun runner() {
        let mut tmp = 10u64;
        increment_mut_ref(&mut tmp);
        let val_after_inc = freeze_mut_ref_in_call(&mut tmp);
        let doubled = double_u8(5u8);
        let sum = sum_frozen_refs(&5u64, &mut tmp);
        let c = freeze_refs_conditional(&mut tmp);
        let nested = nested_freeze(&mut tmp);
    }
}
// # run 0xCAFE::FeatureTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::FeatureTest;

    fun main(account: signer) {
        // Use a local mutable variable
        let mut x = 42u64;

        // Increment the mutable reference
        FeatureTest::increment_mut_ref(&mut x);

        // Freeze mutable ref to immutable and read
        let imm_ref = &x;
        let v = *imm_ref;

        // Call other public functions
        let sum = FeatureTest::add_u64(v, 8);

        let double_val = FeatureTest::double_u8(6);

        // Use freeze in call
        let frozen = FeatureTest::freeze_mut_ref_in_call(&mut x);

        // Use sum_frozen_refs with a mutable reference to x
        let total = FeatureTest::sum_frozen_refs(&v, &mut x);

        // Test conditional freezing
        let flag = FeatureTest::freeze_refs_conditional(&mut x);

        // Nested freezing test
        let nested_sum = FeatureTest::nested_freeze(&mut x);

        // Variables here are unused, no assertion needed

        // Just return
        return;
    }
}

// Featurres:
// a4b807ac0a99854fe42c1614ea55c58a: Define public or module functions within a module.
// 35a59e1bbe25ea62bc219715c2689c6a: Declare specification functions, variables, lets, includes, applies, and pragmas without processing unbound names in their contents.
// b93d3ab4f27c60d785009cf046f3d8ee: Test that mutable references (`&mut`) can be safely and correctly frozen to immutable references (`&`) in various contexts, including function calls, assignments, conditionals, and borrow operations, ensuring proper Move type and borrow checker behavior.
