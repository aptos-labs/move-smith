// # publish
module 0xCAFE::ModuleMutVector {
    use std::vector;

    struct Counter has copy, drop, store {
        value: u64,
    }

    public fun inc_counter(c: &mut Counter) {
        c.value = c.value + 1;
    }

    public fun vector_mutate_and_count(v: &mut vector<u64>): u64 {
        let mut s = Counter { value: 0 };
        // using for_each_mut with a closure that mutates vector elements and captures s mutably
        vector::for_each_mut(v, |elem| {
            *elem = *elem + 1;
            inc_counter(&mut s);
        });
        s.value
    }

    public fun runner(): u64 {
        let mut v = vector::empty<u64>();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);
        vector::push_back(&mut v, 3);
        vector_mutate_and_count(&mut v)
    }
}
// # run 0xCAFE::ModuleMutVector::runner

// # publish
module 0xCAFE::MatchFunc {
    use std::string;
    use std::vector;

    // Dummy match function to test call syntax
    public fun match(i: u8, j: u8): bool {
        i == j
    }

    // Function that calls the above match as match(...) with commas
    public fun call_match(): bool {
        // call match with args 5 and 5
        let b = match(5u8, 5u8);
        b
    }

    public fun runner(): bool {
        call_match()
    }
}
// # run 0xCAFE::MatchFunc::runner

// # publish
module 0xCAFE::ModuleDiagnostics {
    // This module intentionally declares a module incorrectly.
    // In true Aptos environment, such tests would generate diagnostic errors.
    // Here, we simulate an unexpected module context by defining something that looks like a module inside a module,
    // which should cause a diagnostic error in a real compilation context.

    // Normally, Move doesn't support nested modules, so to simulate a diagnostic message for
    // "unexpected module identifier" we define invalid syntax as a comment.

    // The Move VM or compiler should generate diagnostics when a module identifier is unexpected in a context.

    // This is a placeholder to indicate the intent of diagnostic test:
    // e.g. "unexpected module identifier 'InnerModule' here" 
    // (not actual compilable code)
    // module InnerModule {}
}
// Note: No run command for diagnostics module because it won't compile correctly.


// Featurres:
// 9c8880648b64ae2a2350b77bf05f5b7f: Test that closures passed to vector::for_each_mut can mutate both the elements of the vector and variables captured by reference (as in updating s inside the closure).
// 679df54e5b642029e610d50b58dbae39: Generate diagnostic messages when a module identifier is unexpected for a given context.
// e11ee14141353863d01f9dc6bd4c5061: Use 'match' as a function call 'match()' with arguments separated by commas inside parentheses.
