//# publish
module 0xCAFE::AbortAndSpecTest {
    use std::signer;

    struct Dummy has store {}

    /// This function aborts with code 100 immediately.
    /// Subsequent code after abort should be unreachable.
    public fun abort_immediately() {
        abort 100;
        // unreachable code (should not be executed)
        let _a = 1;
    }

    /// This function uses sequencing expression to abort conditionally.
    /// If input is zero, abort with code 200, else return x + 1.
    public fun abort_conditional(x: u8): u8 {
        // The expression aborts if x == 0, otherwise evaluates to x + 1
        let res = if (x == 0) {
            abort 200;
        } else {
            x + 1
        };
        res
    }

    /// This function demonstrates abort propagation through nested calls.
    /// It calls abort_conditional twice; first with 1 (no abort), then 0 (abort).
    public fun nested_abort(): u8 {
        let a = abort_conditional(1u8);
        let b = abort_conditional(0u8);
        a + b // unreachable because previous abort triggers
    }

    /// This function uses a literal address '@0xBEEF' inside the code to create a dummy resource.
    public fun create_dummy_resource_at_literal_address() {
        let addr = @0xBEEF;
        let dummy = Dummy {};
        move_to<Dummy>(&signer::spec_only_signer(addr), dummy);
    }

    /// Specification block demonstrating use of specifications.
    spec module {
        /// Invariant: abort_immediately always aborts with 100.
        invariant fun abort_immediately_aborts(): bool {
            false // trivial false because function aborts unconditionally.
        }

        /// Lemma that for any x != 0, abort_conditional returns x + 1.
        lemma fun abort_conditional_nonzero(x: u8) {
            spec (x != 0) ensures abort_conditional(x) == x + 1;
        }

        /// Lemma for addr variable inside create_dummy_resource_at_literal_address.
        lemma fun literal_address_is_correct(): address {
            @0xBEEF
        }
    }
}

//# run 0xCAFE::AbortAndSpecTest::abort_immediately

//# run 0xCAFE::AbortAndSpecTest::abort_conditional --args 5u8

//# run 0xCAFE::AbortAndSpecTest::nested_abort

//# run 0xCAFE::AbortAndSpecTest::create_dummy_resource_at_literal_address

// Featurres:
// 0dbce85205ae1679273cb52846e30321: Test that abort propagation and sequencing expressions correctly handle aborts and unreachable code in Move functions.
// d21bddb9b06888597dffcc51e2c51d89: Use literal addresses prefixed by '@' directly in code.
// 7e545afd3c602ca88da9afcee3b4c80c: Use specification blocks to organize code and annotations in Move modules.
