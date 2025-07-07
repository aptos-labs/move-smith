//# publish
module 0xCAFE::TestPrimitives {

    use std::signer;

    /// Function that takes various primitive types as parameters.
    public fun primitives(
        b: bool,
        v8: u8,
        v16: u16,
        v32: u32,
        v64: u64,
        v128: u128,
        v256: u256,
        addr: address,
        _s: &signer
    ) {
        // No operation needed, just accept parameters
    }

    /// Function that just accepts Unit type (empty tuple)
    public fun unit_type(_u: ()) {}

    /// Function that triggers or returns an error that is unresolved.
    /// This is a placeholder to test UnresolvedError handling.
    public fun unresolved_error() {
        // Try to abort with an error code that is not declared anywhere
        abort 99999;
    }

    /// Runner function that calls primitives with sample parameters, requires signer.
    public fun runner(s: &signer) {
        primitives(
            true,
            1u8,
            2u16,
            3u32,
            4u64,
            5u128,
            6u256,
            signer::address_of(s),
            s
        );
        unit_type(());
    }
}

//# run 0xCAFE::TestPrimitives::runner --signers 0xCAFE

//# run 0xCAFE::TestPrimitives::unresolved_error --signers 0xCAFE

// Featurres:
// 34633e7a6f3a32fd23964181ccc9833c: Assign argument values to parameters in test functions using the #[test(...)] attribute's parameter assignment.
// 4bfbbf08ad658deb16b065c3aaa0ba1f: Define function signatures with various primitive types like bool, u8, u16, u32, u64, u128, u256, address, and signer.
// fe4621ae0d61f411fef5c1f6ecd21071: Recognize and handle special types like Unit or UnresolvedError for error management.
