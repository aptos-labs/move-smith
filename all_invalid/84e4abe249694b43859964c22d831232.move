
//# publish
module 0xCAFE::ClosureShadowing {

    // This module tests variable shadowing and mutation within closures passed as arguments

    public fun call_with_closure<F: copy + drop>(mut_var: &mut u8, f: F) {
        let inner_mut_var = *mut_var;
        // call closure f which is expected to shadow and mutate mut_var
        let shadowed = f(inner_mut_var);
        // assign shadowed value back to mut_var
        *mut_var = shadowed;
    }

    public fun test_shadowing_and_mutation(): u8 {
        let x = 10u8;
        let mut_x = x;
        let mut_x_ref = &mut (copy mut_x);
        // Define a closure that shadows the outer x and mut_x_ref and mutates via argument
        let closure: |u8|u8 has copy + drop = |x: u8| {
            let x = x + 5u8; // shadow parameter x
            x
        };
        call_with_closure(mut_x_ref, closure);
        *mut_x_ref
    }

}



//# run 0xCAFE::ClosureShadowing::test_shadowing_and_mutation



//# publish
module 0xCAFE::IntLiteralSuffixes {
    // This module verifies integer literal suffix usage with various integer types
    // and basic arithmetic correctness.

    public fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_u16(a: u16, b: u16): u16 {
        a + b
    }

    public fun add_u32(a: u32, b: u32): u32 {
        a + b
    }

    public fun add_u64(a: u64, b: u64): u64 {
        a + b
    }

    public fun add_u128(a: u128, b: u128): u128 {
        a + b
    }

    public fun add_u256(a: u256, b: u256): u256 {
        a + b
    }

    public fun test_all_additions(): (u8, u16, u32, u64, u128, u256) {
        let r_u8 = add_u8(1u8, 2u8);
        let r_u16 = add_u16(10u16, 20u16);
        let r_u32 = add_u32(100u32, 200u32);
        let r_u64 = add_u64(1000u64, 2000u64);
        let r_u128 = add_u128(10000u128, 20000u128);
        let r_u256 = add_u256(100000u256, 200000u256);
        (r_u8, r_u16, r_u32, r_u64, r_u128, r_u256)
    }
}


//# run 0xCAFE::IntLiteralSuffixes::test_all_additions




//# publish
module 0xCAFE::ExpectedFailures {
    use std::vector;

    // This module contains functions that intentionally abort with specified failure codes
    // to test expected_failure annotations

    public fun abort_major() {
        abort 0x1000;
    }

    public fun abort_minor() {
        abort 42;
    }

    public fun abort_with_vector_out_of_bounds() {
        let v = vector::empty<u8>();
        // will abort with EINDEX_OUT_OF_BOUNDS minor status = 42
        // to reproduce error we try to borrow index 0
        let _val = *vector::borrow(&v, 0);
    }
}


//# run 0xCAFE::ExpectedFailures::abort_major
// expected_failure(major_status = 0x1000)]


//# run 0xCAFE::ExpectedFailures::abort_minor
// expected_failure(minor_status = 42)]


//# run 0xCAFE::ExpectedFailures::abort_with_vector_out_of_bounds
// expected_failure(minor_status = 42)]


// Featurres:
// 7ae320749aa1a3fa69ec63bdd6cf3ca6: Test that variables from the outer scope can be shadowed and mutated by closures passed to functions, verifying correct variable capture and assignment behavior.
// 3220df2133f8fbcc8780511b273236cf: Use suffixes 'u8', 'u16', 'u32', 'u64', 'u128', or 'u256' to specify the exact numeric type of integer literals in Move code.
// 25e30025baf8e5d0b1d3508c076aba8b: Provide a major or minor status code via #[expected_failure(major_status = ...)] or #[expected_failure(minor_status = ...)] to expect specific failure codes.
