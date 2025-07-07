//# publish
module 0x1::TestAbort {
    /// Function that always aborts with the given code.
    public fun abort_with_code(): u64 {
        abort 42;
    }

    /// Runner function without arguments that calls abort_with_code to test abort.
    public fun run_abort() {
        abort_with_code();
    }
}
//# run 0x1::TestAbort::run_abort --signers 0x1

//# publish
module 0x1::TestQuantified {
    /// A dummy struct to use in quantified expressions.
    struct Dummy has copy, drop, store {}

    /// Function demonstrating a quantified expression with bindings, an expression list, optional expression, and main expression.
    public fun quant_expr_demo(): bool {
        // Move's quantified expressions syntax (e.g., 'exists', 'forall') example:
        // exists x in [1, 2, 3] where x > 2
        exists x in [1, 2, 3] where x > 2
    }

    /// Runner function without arguments that returns the result of quantified expression.
    public fun run_quantified(): bool {
        quant_expr_demo()
    }
}
//# run 0x1::TestQuantified::run_quantified

//# publish
module 0x1::TestPragmas {
    pragma my_pragma = @0xA0B0C0;        // at-sign literal
    pragma bool_pragma = true;          // boolean literal
    pragma num_pragma = 123_456_789u64; // numeric literal
    pragma bytes_pragma = b"MoveTest";  // byte string literal

    // Dummy public function to make module non-empty and runnable.
    public fun run_pragmas() {
        // No runtime logic needed, just compiling pragmas.
    }
}
//# run 0x1::TestPragmas::run_pragmas