//# publish
module 0x1::TestAbort {
    /// Function that aborts with a given error code.
    public fun do_abort() {
        abort 42;
    }

    /// Runner function that calls do_abort.
    public fun runner_abort() {
        do_abort();
    }
}
//# run 0x1::TestAbort::runner_abort --signers 0x1

//# publish
module 0x1::TestQuantifiedExpr {
    use std::vector;

    /// Returns true if a given vector contains the element 10,
    /// using a quantified expression with bindings, expression list,
    /// optional expression, and main expression.
    public fun contains_ten(v: vector<u8>): bool {
        // Use a quantified expression to check existence of 10 within v
        // Syntax: exists x in v, x > 5 && x == 10
        exists x in v {
            x > 5u8 && x == 10u8
        }
    }

    /// Runner function that creates a vector and tests contains_ten.
    public fun runner_quantified_expr() {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 1u8);
        vector::push_back(&mut v, 10u8);
        let _found = contains_ten(v);
    }
}
//# run 0x1::TestQuantifiedExpr::runner_quantified_expr

//# publish
module 0x1::TestPragmaAssign {
    /// Pragma properties with assigned literal values.
    ///
    /// Assign literals including:
    /// - at-sign
    /// - boolean
    /// - numeric
    /// - byte string
    ///
    /// Format: `pragma_property = <literal>;`
    pragma at_sign = @0xBEEF;
    pragma is_enabled = true;
    pragma max_count = 100u64;
    pragma bytes_literal = b"aptos";

    /// Runner that does nothing but exists to allow running module.
    public fun runner_pragma() {
        // empty on purpose
    }
}
//# run 0x1::TestPragmaAssign::runner_pragma