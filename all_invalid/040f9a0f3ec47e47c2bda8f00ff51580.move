// Testing Move features: parameter passing by reference/value, bytecode verification errors, and match on enums with tuple and struct variants.

//# publish
module 0xCAFE::ParamPass {

    use std::signer;

    struct S has copy, drop, store {
        x: u64,
        y: u64,
    }

    public fun modify_by_value(s: S): S {
        // s is passed by value (moved in).
        // Modify and return a new struct.
        S { x: s.x + 1, y: s.y + 1 }
    }

    public fun modify_by_ref(s: &mut S) {
        // s is passed by mutable reference, modify in place.
        s.x = s.x * 2;
        s.y = s.y * 2;
    }

    public fun no_modify(_s: &S) {
        // Passed by shared reference, cannot modify.
        // Do nothing.
    }

    public fun runner_for_param_pass(): u64 {
        // Create struct
        let s = S { x: 10, y: 20 };
        // Pass by value
        let s2 = modify_by_value(s);
        // s is moved, so no access here; use s2
        // Create mutable copy to test by ref
        let mut s3 = S { x: s2.x, y: s2.y };
        modify_by_ref(&mut s3);
        no_modify(&s3);
        s3.x + s3.y
    }
}
//# run 0xCAFE::ParamPass::runner_for_param_pass

// Test bytecode verification error: create an invalid function that tries to move out of shared reference (compile error).
// The compiler should give a detailed error about invalid move out of borrowed content.

//# publish
module 0xCAFE::BadBytecode {

    struct M has store {
        val: u64,
    }

    // ERROR TEST: Move out of shared borrow is forbidden, expect compilation failure with detailed bytecode verification error
    public fun move_out_of_ref(m: &M): u64 {
        // Invalid: trying to move val out of &M (shared ref)
        // This line should trigger a bytecode verification error during compilation
        let val = *m;  // *m attempts to move M out of reference - not allowed
        val.val
    }

    // Correct version for comparison
    public fun borrow_val(m: &M): u64 {
        m.val
    }
}
//# run 0xCAFE::BadBytecode::borrow_val

// Test enum match statements with tuple and struct variants
//# publish
module 0xCAFE::EnumMatch {

    enum E has copy, drop {
        // Tuple variant with one u64 field
        TupleVariant(u64),

        // Struct variant with named fields
        StructVariant { a: u8, b: u16 },
    }

    public fun match_tuple(e: E): u64 {
        // Match on tuple variant extracting value, wildcard handling other variants
        match e {
            E::TupleVariant(x) => x,
            _ => 0,
        }
    }

    public fun match_struct(e: E): u64 {
        match e {
            E::StructVariant { a, b } => (a as u64) + (b as u64),
            _ => 0,
        }
    }

    public fun match_bindings(e: E): u64 {
        match e {
            E::TupleVariant(v) => v + 100,
            E::StructVariant { a: aa, b: bb } => (aa as u64) * 10 + (bb as u64),
        }
    }

    public fun wildcard_match(e: E): u64 {
        match e {
            E::TupleVariant(_) => 1,
            E::StructVariant { .. } => 2,
        }
    }

    public fun runner_enum_match(): u64 {
        let e1 = E::TupleVariant(42);
        let e2 = E::StructVariant { a: 3, b: 50 };
        let r1 = match_tuple(e1);
        let r2 = match_struct(e2);
        let r3 = match_bindings(e1);
        let r4 = wildcard_match(e2);
        // Sum all results for final output
        r1 + r2 + r3 + r4
    }
}
//# run 0xCAFE::EnumMatch::runner_enum_match


//# run
script {
    use 0xCAFE::ParamPass;
    use 0xCAFE::EnumMatch;

    fun main() {
        let p = ParamPass::runner_for_param_pass();
        let e = EnumMatch::runner_enum_match();
        // Just consume results to exercise VM and compiler
        let _ = p + e;
    }
}

// Featurres:
// ae3e0fd97f4a7a5808a654b0685098ad: Pass function parameters by reference or value and determine if parameters are possibly modified by move or borrow operations.
// 070e2e2b6fc53d7fb90fcd8d68dad542: Trigger detailed error messages when bytecode verification fails during compilation
// 75e79eec27f2b7c1341805305b2da456: Test that match statements on enums with both tuple and struct variants correctly support pattern matching with destructuring, wildcards, and binding to extract nested fields.
