// #publish
address 0xCAFE {
    module NumericSuffixes {
        // A struct holding various numeric types
        struct Numbers {
            a: u8,
            b: u16,
            c: u32,
            d: u64,
            e: u128,
            f: u256,
        }

        // Initialize Numbers with all suffix styles
        public fun init_numbers(): Numbers {
            let a = 123u8;
            let b = 4567u16;
            let c = 123456u32;
            let d = 123456789u64;
            let e = 123456789123456789u128;
            let f = 123456789123456789123456789u256;
            Numbers { a, b, c, d, e, f }
        }

        // Run function to exercise numeric suffix creation
        public fun runner() {
            let nums = Self::init_numbers();
            // We won't use nums further, just creating to test compiler
        }

    }
}
// #run 0xCAFE::NumericSuffixes::runner


// #publish
address 0xCAFE {
    module DerefAndField {

        struct S has copy, drop, store {
            x: u64,
            y: bool,
        }

        public fun make_s(): S {
            S { x: 42u64, y: true }
        }

        // Function returns reference to S
        public fun borrow_s(): &S {
            let s = make_s();
            &s
        }

        // Function demonstrating dereference of reference
        public fun test_deref_ref(): bool {
            let s_ref = &make_s();
            let s_val = *s_ref;
            // Access fields using s_val.x and s_val.y
            s_val.y
        }

        // Function demonstrating accessing struct fields via reference
        public fun test_field_access_ref(): u64 {
            let s_ref = &make_s();
            // Access field via reference with (*r).field or r.field (both allowed)
            (*s_ref).x
        }

        // Function demonstrating module item access by name
        public fun use_module_item(): u64 {
            // Call make_s by explicit module name
            let s = 0xCAFE::DereFAndField::make_s();
            s.x
        }

        // runner function calls all of the above
        public fun runner() {
            let _ = Self::test_deref_ref();
            let _ = Self::test_field_access_ref();
            let _ = Self::use_module_item();
        }
    }
}
// #run 0xCAFE::DereFAndField::runner


// #publish
address 0xCAFE {
    module GenericFieldRef<T> has copy, drop, store {
        struct Wrapper {
            val: T,
        }

        public fun new(v: T): Wrapper {
            Wrapper { val: v }
        }

        public fun get_ref(wrapper: &Wrapper): &T {
            &wrapper.val
        }

        public fun dup_and_check(wrapper: Wrapper): bool {
            let val_ref = &wrapper.val;
            let val_copy = *val_ref;
            val_copy == val_copy
        }

        // runner function uses u64 as type parameter
        public fun runner() {
            let w = Self::new(100u64);
            let r = Self::get_ref(&w);
            let _ = *r;
            let _ = Self::dup_and_check(w);
        }
    }
}
// #run 0xCAFE::GenericFieldRef::runner

// Featurres:
// 3220df2133f8fbcc8780511b273236cf: Use suffixes 'u8', 'u16', 'u32', 'u64', 'u128', or 'u256' to specify the exact numeric type of integer literals in Move code.
// ecccc2e2a01c37f38c182d3f93af3d85: Dereference references via the unary `*` operator.
// 56e58f9f7702e43904de062182125520: Refer to field or module items by name, possibly with type arguments.
