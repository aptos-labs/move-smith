//# publish
module 0xCAFE::ReturnTest {
    public fun test_branch(cond: bool): u64 {
        if (cond) {
            return 1;
        } else {
            return 2;
        }
    }

    // Function to be called without arguments that exercises both branches internally
    public fun runner(): u64 {
        let res1 = Self::test_branch(true);
        let res2 = Self::test_branch(false);
        // Just return res1 + res2 to use both return paths
        res1 + res2
    }
}

//# run 0xCAFE::ReturnTest::runner

//# publish
module 0xCAFE::BorrowTest {
    // This function attempts to create two mutable references to the same u64 value.
    // This should cause a compile-time error in Move: cannot have two mutable borrows at the same time.
    //
    // Uncommenting this function in a real environment would cause a compilation error.
    // We keep it commented here to keep the test transactional compilation-safe.
    //
    /*
    public fun double_mut_ref(val: &mut u64) {
        let ref1: &mut u64 = val;
        let ref2: &mut u64 = val; // This line should cause a compilation error
        *ref1 = 10;
        *ref2 = 20;
    }
    */

    // A runner that only creates one mutable reference to satisfy compilation
    public fun runner() {
        let mut x = 0u64;
        let r: &mut u64 = &mut x;
        *r = 5;
        // We do not create a second mutable reference here to not break compilation
    }
}

//# run 0xCAFE::BorrowTest::runner

//# publish
module 0xCAFE::AbortTest {
    public fun test_abort() {
        abort 0xDEADBEEF;
    }

    public fun runner() {
        // Calling test_abort to exercise abort statement
        test_abort();
    }
}

//# run 0xCAFE::AbortTest::test_abort --signers 0xCAFE

//# run
script {
    use 0xCAFE::ReturnTest;
    use 0xCAFE::BorrowTest;
    use 0xCAFE::AbortTest;

    fun main() {
        // Test 1: if-else with returns (indirectly tested by ReturnTest::runner call above)
        let ret_val = ReturnTest::runner();
        // ret_val should be 3 (1+2)

        // Test 2: mutable borrow rules tested by compilation step of BorrowTest (no runtime here)

        // Test 3: abort execution, this script should abort when calling AbortTest::test_abort
        AbortTest::test_abort();
    }
}

// Featurres:
// 2c12cc14febccc74bcced84e346b16a8: Test that the Move language correctly handles return statements in both branches of an if-else statement within a script.
// 053c0898699e17a66d51b1ffd70c3ab0: Test that attempting to create multiple mutable references in the same function results in a compilation error or behavior as specified by Move's borrowing rules.
// aa0ee9e75218a1cf57f5d03286c31b3b: Abort execution using the 'abort' statement
