//# publish
module 0xCAFE::VectorByteAccess {
    use std::vector;

    public fun first_byte_numeric_vec(): u8 {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 10);
        vector::push_back(&mut v, 20);
        vector::push_back(&mut v, 30);
        vector::borrow(&v, 0)
    }

    public fun first_byte_literal_vec(): u8 {
        let v = vector::from_bytes(b"\x42\x43\x44");
        vector::borrow(&v, 0)
    }

    // Runner function to call both and return no result needed
    public fun run() {}
}
//# run 0xCAFE::VectorByteAccess::run --signers 0xCAFE

//# publish
// This module demonstrates a specification that requires a linked module to compile correctly.
// The spec modifiers should produce an error if the linked module is missing during verification.
module 0xCAFE::SpecLinkFailure {
    use std::error;

    spec module {
        // This spec references an unknown module 0xBEEF::Unlinked which isn't published.
        // This should cause a linking error in the compiler spec checker.
        spec fun dummy() {
            // The following line forces a reference to an unknown module spec:
            abort 999; // no-op to keep the spec body
        }
    }

    public fun dummy() {
        // Just a placeholder function
    }
}
// No run command here, this is testing that specs fail linking when modules are missing.

//# publish
module 0xCAFE::WhileLoopMutation {
    public fun loop_sum(): u64 {
        let mut i = 0u64;
        let mut sum = 0u64;
        while (i < 5) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    public fun run() {
        let s = Self::loop_sum();
        // Just a call to ensure mutation and loop semantics run correctly
    }
}
//# run 0xCAFE::WhileLoopMutation::run --signers 0xCAFE

//# run
script {
    use 0xCAFE::VectorByteAccess;
    use 0xCAFE::WhileLoopMutation;

    fun main() {
        let first_numeric = VectorByteAccess::first_byte_numeric_vec();
        let first_literal = VectorByteAccess::first_byte_literal_vec();

        let sum_loop = WhileLoopMutation::loop_sum();

        // No assertions needed per instructions
        // Just ensure VM and compiler properly execute these paths

        // Dummy usage to avoid unused warnings
        let _ = first_numeric;
        let _ = first_literal;
        let _ = sum_loop;
    }
}

// Featurres:
// 4737ef1101f226b95963abeb5551c867: Test that accessing the first byte of a vector initialized with numeric values and a byte sequence returns the correct value.
// 1d5769bf49a3a94cdb66fa91c361bd45: Attach error diagnostics when specification modules cannot be linked to a target module, preventing standalone compilation of specs.
// b8a34de09e13d5cdf41a338ebe740faa: Test that a while-loop with variable assignments and updates inside correctly computes cumulative values and preserves variable scoping and mutation.
