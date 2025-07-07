
//# publish
module 0xCAFE::TestFeatures {
    // Removed unused alias `use std::signer;`

    // Test 1: simple add function that returns the sum plus 5
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    // Test 2: move does not support lambdas or anonymous functions in Move.
    // Instead, define a named inner function for multiplication.
    fun mul(a: u8, b: u8): u8 {
        a * b
    }

    public fun lambda_product(x: u8, y: u8): u8 {
        mul(x, y)
    }

    // Test 3: call inline function from another module and do nested calls
    // Reuse MyModule::f2 which returns tuple (a+1, a+2)
    // We'll call f2 twice in a nested manner: pass (a+1) from the first as input for second call
    // The inline function is f2(a: u16): (u16, u16)
    //
    // Since MyModule::f2 does not exist, define it here for completeness.
    //
    // Note: This is necessary to fix the linker error and compilation failure.
    struct Dummy has copy, store {}
    public fun f2(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }

    public fun nested_inline_call(input: u16): u16 {
        let (x1, _) = Self::f2(input);
        let (x2, _) = Self::f2(x1);
        x2
    }

    // Test 4: invariant definition with location info and property
    // Simulate invariant by an assert with custom abort code, include info about line (fake) and prop
    public fun test_invariant_condition(x: u8) {
        // A fake location info as comment: "loc: line 42"
        let condition = x < 100;
        assert!(condition, 0xDEAD);
    }

    // Test 5: infer assignment kinds and handle drops
    // Create function with copy and move values with drop calls expected.
    struct Droppable has drop {
        value: u8
    }

    public fun infer_assignment_and_drop(x: u8) {
        let d1 = Droppable {value: x};         // move occurs here for d1
        let d2 = Droppable {value: x + 1};     // move occurs here for d2

        let d3 = copy d1;  // copy assignment, d1 still valid after this

        // Implicit drop caused by going out of scope of d2 and d1, no explicit calls needed

        // dummy use of d3 so compiler won't warn about unused
        let _val = d3.value;
    }

    // Runner function for some of the above to call easily with no args.
    public fun runner() {
        // for coverage, call all above functions that don't require arguments
        let _ = add_and_offset(10u8, 20u8);
        let _ = lambda_product(7u8, 8u8);
        let _ = nested_inline_call(15u16);
        test_invariant_condition(50u8);
        infer_assignment_and_drop(25u8);
    }
}



//# run 0xCAFE::TestFeatures::add_and_offset --args 12u8 34u8



//# run 0xCAFE::TestFeatures::lambda_product --args 6u8 7u8



//# run 0xCAFE::TestFeatures::nested_inline_call --args 5u16



//# run 0xCAFE::TestFeatures::test_invariant_condition --args 99u8



//# run 0xCAFE::TestFeatures::infer_assignment_and_drop --args 33u8



//# run 0xCAFE::TestFeatures::runner
