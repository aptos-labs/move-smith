//# publish
module 0x1::InvariantLoopTest {
    use std::error;
    use std::assert;

    // Test for loop with an explicit invariant, aborts if invariant is violated.
    public fun runner(s: &signer) {
        let mut sum = 0u64;
        let mut i = 0u8;
        // Should abort when sum > 10
        let n = 5u8;
        while (i < n) {
            sum = sum + 3;
            // Invariant: sum must not exceed 10, else abort
            if (sum > 10) {
                abort 100;
            };
            i = i + 1;
        };
    }
}
//# run 0x1::InvariantLoopTest::runner --signers 0x1

//# publish
module 0x2::UninitUseChecker {
    // Function that attempts to use an uninitialized local variable.
    // The Move compiler should catch this (UninitializedUseChecker).
    public fun runner():u8 {
        let x:u8;
        // Uncommenting the next line would produce a "use of possibly uninitialized variable" error
        //return x;
        // To just test the checker, use as an unused variable so compiler checks
        if (false) {
            return x; // Unreachable but should still be checked by UninitializedUseChecker
        }
        42u8
    }
}
//# run 0x2::UninitUseChecker::runner

//# publish
module 0x3::NamingRulesTest {
    // Restricted names: can't start with numbers, can't have spaces, etc.
    // We'll create a checker function.
    public fun is_name_valid(name: &vector<u8>): bool {
        let len = vector::length(name);
        // Disallow empty
        if (len == 0) return false;
        let first = *vector::borrow(name, 0);
        // Must start with a letter or underscore
        if (!((first >= 65 && first <= 90) || (first >= 97 && first <= 122) || (first == 95))) {
            return false;
        };
        // No spaces allowed
        let i = 0;
        while (i < len) {
            let c = *vector::borrow(name, i);
            if (c == 32) {
                return false;
            };
            i = i + 1;
        };
        true
    }

    public fun runner() {
        // test with various names
        let name1 = b"name";
        let name2 = b"1Invalid";
        let name3 = b"valid_name";
        let name4 = b"has space";
        ignore Self::is_name_valid(&name1);
        ignore Self::is_name_valid(&name2);
        ignore Self::is_name_valid(&name3);
        ignore Self::is_name_valid(&name4);
    }
}
//# run 0x3::NamingRulesTest::runner

//# publish
spec module 0x4::MySpecModule {
    // Dummy spec module for testing spec extraction.
    spec fun foo_spec() {
        ensures true;
    }
    spec fun bar_spec {
        aborts_if false;
    }
}
// There is no way to "run" a spec module, but this serves for extraction & processing.

//# publish
module 0x4::SpecExtractionRunner {
    // Dummy runner to simulate packaging/processing of spec modules
    public fun runner() {}
}
//# run 0x4::SpecExtractionRunner::runner
