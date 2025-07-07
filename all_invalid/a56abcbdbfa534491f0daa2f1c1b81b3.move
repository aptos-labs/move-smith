// This transactional test exercises:
// 1. Invariant checks in a for loop.
// 2. Uninitialized variable checker (should abort/compile error).
// 3. Name restriction checker.

//# publish
module 0x1::LoopInvariantTest {
    use std::error;

    const EC_INVARIANT: u64 = 9001;

    /// Increments the input vector and checks that no element ever exceeds the threshold.
    public fun check_and_increment_all(vec: &mut vector<u64>, threshold: u64) {
        let len = vector::length(vec);
        let i = 0;
        while (i < len) {
            let val_ref = vector::borrow_mut(vec, i);
            *val_ref = *val_ref + 1;
            // Invariant: All elements must stay below 'threshold'
            if (*val_ref >= threshold) {
                abort EC_INVARIANT;
            };
            i = i + 1;
        }
    }

    /// Runner to violate the invariant (should abort with EC_INVARIANT)
    public fun runner() {
        let v = vector::empty<u64>();
        vector::push_back(&mut v, 5);
        vector::push_back(&mut v, 6);
        vector::push_back(&mut v, 7);
        // If threshold is 8, third element will reach it after increment (becomes 8), triggers abort.
        Self::check_and_increment_all(&mut v, 8);
    }
}
//# run 0x1::LoopInvariantTest::runner --signers 0x1

// -------------------------------------------------------
//# publish
module 0x1::UninitializedVarTest {
    use std::vector;

    /// Illustrates the UninitializedUseChecker (compile error expected)
    public fun runner() {
        let x: u64;
        let y = x + 1; // x is uninitialized, should be flagged by UninitializedUseChecker
        // Suppress unused variable warning
        let _ = y;
    }
}
//# run 0x1::UninitializedVarTest::runner --signers 0x1
// This script/function is expected to fail compile due to use of uninitialized variable.

// -------------------------------------------------------
//# publish
module 0x1::NameRestrictionTest {
    /// Returns true iff the given string only contains ASCII alphabetic characters or underscores.
    public fun is_valid_name(s: &vector<u8>): bool {
        let i = 0;
        let len = vector::length(s);
        while (i < len) {
            let c = *vector::borrow(s, i);
            if (!( (c >= 65 && c <= 90) || (c >= 97 && c <= 122) || c == 95 )) {
                return false;
            };
            i = i + 1;
        };
        true
    }

    public fun runner() {
        // Valid names
        let name1 = b"MoveModule";
        let name2 = b"move_module";
        let name3 = b"MOVE_MODULE";
        assert!(Self::is_valid_name(&name1));
        assert!(Self::is_valid_name(&name2));
        assert!(Self::is_valid_name(&name3));

        // Invalid names
        let name4 = b"move123";
        let name5 = b"move-module";
        let name6 = b"move.module";
        let name7 = b"";
        assert!(!Self::is_valid_name(&name4));
        assert!(!Self::is_valid_name(&name5));
        assert!(!Self::is_valid_name(&name6));
        assert!(Self::is_valid_name(&name7)); // Empty name is valid (contains no invalid chars)
    }
}
//# run 0x1::NameRestrictionTest::runner --signers 0x1