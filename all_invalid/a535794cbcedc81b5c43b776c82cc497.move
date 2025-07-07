//# This transactional test covers:
//# 1: Keyset gating via the EXPERIMENTS keyset (only allowed experiment IDs can be declared).
//# 2: Struct constructor expression syntax: `Struct { x: ..., y: ... }`.
//# 3: Named item attributes on Move modules, structs, and functions. (Attributes are ignored at runtime but must parse.)
//# Note: We do not use address aliasing and avoid using `0x1`.

////////////////////////////////////////////////////////////////////////////////////////
//# publish
address 0xCAFE {
    #[doc = b"EXPERIMENTS keyset gate and struct construction experiment"]
    #[experiment]
    module Experiments {
        use std::signer;
        use std::vector;

        /// The EXPERIMENTS keyset. Only IDs in this set can be used.
        const EXPERIMENTS: vector<u8> = b"\x01\x02\x03\x42";

        /// Struct for demonstration, with constructor expression.
        #[my_meta]
        struct Foo {
            x: u8,
            y: u64,
        }

        /// Resource to keep track of experiments declared by an account.
        #[declaration]
        struct Declaration has key {
            declared: vector<u8>,
        }

        /// Helper function: Check if `id` is in `EXPERIMENTS` keyset.
        public fun is_experiment_enabled(id: u8): bool {
            let n = vector::length<&u8>(&EXPERIMENTS);
            let mut i = 0;
            while (i < n) {
                if (*vector::borrow<&u8>(&EXPERIMENTS, i) == id) {
                    return true;
                };
                i = i + 1;
            };
            false
        }

        /// Public: Declare experiment `id` if it's in EXPERIMENTS.
        #[entry]
        public fun declare(signer: &signer, id: u8) acquires Declaration {
            // Only allow experiments present in EXPERIMENTS.
            assert!(Self::is_experiment_enabled(id), 100);

            // Construct Foo using constructor expression syntax (test #2).
            // We'll not use the value otherwise.
            let _foo = Foo { x: id, y: 42 };

            // Add record of experiment declaration.
            if (!exists<Declaration>(signer::address_of(signer))) {
                move_to(signer, Declaration { declared: vector::empty<u8>() });
            };
            let d = borrow_global_mut<Declaration>(signer::address_of(signer));
            vector::push_back<u8>(&mut d.declared, id);
        }

        /// Show declared experiments for the sender.
        public fun show_declared(addr: address): vector<u8> acquires Declaration {
            if (exists<Declaration>(addr)) {
                let d = borrow_global<Declaration>(addr);
                copy d.declared
            } else {
                vector::empty<u8>()
            }
        }

        /// Helper to clear all declarations for sender (so test can run repeatedly).
        public fun clear_all(s: &signer) acquires Declaration {
            if (exists<Declaration>(signer::address_of(s))) {
                move_from<Declaration>(signer::address_of(s));
            }
        }

        /// Runner function for demo: call declare for experiment 0x42 (allowed),
        /// declare for 0xAA (unallowed), and create a Foo struct with explicit values.
        /// Only first declare should succeed.
        public fun run_all(s: &signer) acquires Declaration {
            // First clear.
            Self::clear_all(s);

            // Valid declaration: 0x42 is in EXPERIMENTS.
            Self::declare(s, 0x42);

            // This will abort due to not being in EXPERIMENTS.
            // We'll catch the abort in a script instead to show error.

            // Struct construction syntax (test #2) -- not stored, just for syntax
            let _x = Foo { x: 7, y: 12345 };
        }
    }
}
//# run 0xCAFE::Experiments::run_all --signers 0xBEEF

////////////////////////////////////////////////////////////////////////////////////////
//# run
script {
    use 0xCAFE::Experiments;
    use std::signer;

    fun main(account: signer) {
        // This will succeed (0x03 is present in the keyset).
        Experiments::declare(&account, 0x03);

        // Now try declaring 0x99 (not present). Should abort.
        Experiments::declare(&account, 0x99);

        // If above did not abort, struct construction with literal fields.
        let _s = 0xCAFE::Experiments::Foo { x: 9, y: 2 };

        // Show listed declared experiments and drop.
        let _ids = Experiments::show_declared(signer::address_of(&account));
    }
}

////////////////////////////////////////////////////////////////////////////////////////
//# publish
address 0xDEAD {
    // Test attribute on module and function.
    #[test_module]
    module AttributeDemo {
        /// Annotated struct
        #[some_attribute(foo = b"hello")]
        struct Bar has copy, drop {
            z: u8,
        }

        /// Test inline
        #[another_attr]
        public inline fun make_bar(): Bar {
            Bar { z: 99 }
        }

        #[with_boolean_flag(enabled = true)]
        public fun runner() {
            let _b = Self::make_bar();
        }
    }
}
//# run 0xDEAD::AttributeDemo::runner

// Features:
// 7ff5ffab68f220359ee26d0b51fc1a96: Declare an experiment in the list only if it is present in the `EXPERIMENTS` keyset, ensuring only recognized experiments are used.
// e421a578cb88bf0c82f29b9c99ac86b7: Create struct constructor expressions by following a name with '{' and field expressions (e.g., Foo { x: 1, y: 2 }).
// 16552cf62a22ee17fa86d443b203fabd: Annotate Move items with named attributes.
