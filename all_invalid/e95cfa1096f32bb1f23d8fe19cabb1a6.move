// Test for: 
// 1. External lint checks using an (imaginary) pragma lint directive.
// 2. Dotted expressions with nested struct fields.
// 3. Using module/signer-based filtering during compilation (address as filter).

//# publish
address 0xDEAD {
    // External lint check: `"lint"` pragma (simulated)
    /// pragma: lint external:SuperLint

    module NestedStructs {
        /// pragma: lint allow:dead_code
        struct Inner {
            value: u64,
        }

        struct Outer {
            inner: Inner,
        }

        public fun make_outer(val: u64): Outer {
            Outer { inner: Inner { value: val } }
        }

        /// Function exercising dotted expressions
        public fun read_inner_field(o: &Outer): u64 {
            // Use dotted field access: o.inner.value
            o.inner.value
        }

        /// Test runner function, to be called by a transaction test
        public fun runner() {
            let outer = Self::make_outer(42);
            let inner_val = Self::read_inner_field(&outer);
            // inner_val should be 42 (ignoring assertions here)
        }
    }
}
//# run 0xDEAD::NestedStructs::runner --signers 0xDEAD

//# publish
address 0xBEEF {
    /// Using a "lint allow" pragma for illustrative purposes
    /// pragma: lint allow:unused_function

    /// This module will not match a compile filter of "0xDEAD"
    module FilteredOut {
        public fun runner() {
            // does nothing
        }
    }
}

//# run 0xBEEF::FilteredOut::runner --signers 0xBEEF

//-- Filtering Simulation Example --
// Imagine using a test harness option to compile only modules under address 0xDEAD or with name matching "NestedStructs".
// This tests ability to filter compilation via test harness.

//# publish
address 0xDEAD {
    module MatchingFilter {
        public fun runner() {
            // simple runner
        }
    }
}
//# run 0xDEAD::MatchingFilter::runner --signers 0xDEAD

//# run
script {
    fun main() {
        let o = 0xDEAD::NestedStructs::make_outer(99);
        let v = 0xDEAD::NestedStructs::read_inner_field(&o);
        // dotted expression with script-local struct
        let s = StructWithNested { inner: InnerForScript { a: 10 } };
        let x = s.inner.a;
    }

    struct InnerForScript { a: u8 }
    struct StructWithNested { inner: InnerForScript }
}