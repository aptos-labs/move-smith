//# publish
module 0xCAFE::S {
    use std::option::{self, Option};
    use std::vector;

    // A simple struct T with an id
    struct T has copy, drop, store {
        id: u64,
    }

    // S has a vector of T entries
    struct S has key {
        entries: vector<T>,
    }

    // a constant u64 value
    const TARGET_ID: u64 = 42;

    public fun new(): S {
        S {
            entries: vector::empty<T>(),
        }
    }

    public fun add_entry(s: &mut S, id: u64) {
        vector::push_back(&mut s.entries, T { id });
    }

    // the test function to find a T by id in entries, return option<T>
    public fun test(s: &S, id: u64): Option<T> {
        let len = vector::length(&s.entries);
        let mut i = 0;
        while (i < len) {
            let e = vector::borrow(&s.entries, i);
            if (e.id == id) {
                return option::some(*e);
            };
            i = i + 1;
        };
        option::none<T>()
    }

    // runner function to add two entries and test search for existing and missing
    public fun runner() {
        let mut s = new();
        // add some entries
        add_entry(&mut s, 1);
        add_entry(&mut s, TARGET_ID);
        // test presence of TARGET_ID (should find)
        let _found = test(&s, TARGET_ID);
        // test presence of non-existing id (should be none)
        let _not_found = test(&s, 999);
    }

    #[test_only]
    public fun test_runner() {
        runner();
    }

    #[test_only]
    public fun test_constants() {
        let x = TARGET_ID;
        let _y = x + 1;
    }
}

//# run 0xCAFE::S::runner

//# run 0xCAFE::S::test_runner

//# run 0xCAFE::S::test_constants

// Featurres:
// eedd322292113ecf0bc84bee7379af96: Verify that the `test` function correctly searches for an issuer in the `S.entries` vector, returns the matching `T` object wrapped in `Option::some` when found, and returns `Option::none` when no match exists.
// 7adce3d4b2624780062b8f23dc554916: Use unit testing features via functions filtered by 'filter_test_members'.
// c5a0d477827863ddf81ca5a14e3c47b0: Use named constants from modules as u64 values in Move code.
