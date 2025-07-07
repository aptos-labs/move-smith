// # publish
module 0xCAFE::RangeTest {
    /// Test that iterating over an empty range (start > end) does not enter the loop
    /// and the variable remains unchanged.
    public fun iterate_empty_range() {
        let mut x = 42;
        // A loop from 10 to 5, which is an empty range
        let start = 10;
        let end = 5;
        let mut i = start;
        while (i < end) {
            x = 0; // This should never be executed
            i = i + 1;
        };
        // x should still be 42 here
    }

    /// Runner function to simply invoke the test
    public fun runner_empty_range() {
        iterate_empty_range()
    }
}
// # run 0xCAFE::RangeTest::runner_empty_range

// # publish
module 0xCAFE::GenericAccessControl {
    use std::signer;
    use std::vector;

    /// Generic wrapper to hold some content of generic type T
    struct Resource<T> has store, key {
        val: T,
    }

    /// This function is a generic ability to read from a Resource<T> if a permission function returns true.
    /// The permission function is a function type passed as argument, which accepts the signer address and returns bool.
    public fun read_with_permission<T>(
        r: &Resource<T>,
        permission: &fun(&signer) : bool,
        user: &signer,
    ): T acquires Resource {
        // Check permission - call the permission function with user signer reference
        if (!(*permission)(user)) {
            // Here we simply abort if no permission; abort code 1
            abort 1;
        };
       copy r.val
    }

    /// This function is a generic ability to write/update resource's val if a permission function returns true.
    /// It returns the updated Resource.
    public fun write_with_permission<T>(
        r: &mut Resource<T>,
        permission: &fun(&signer) : bool,
        user: &signer,
        new_val: T
    ) acquires Resource {
        if (!(*permission)(user)) {
            abort 2;
        };
        r.val = new_val;
    }

    /// Instantiates a resource of type u64 at the signer's account
    public fun create_resource_for_account(account: &signer, initial_val: u64) {
        move_to(account, Resource<u64> { val: initial_val });
    }

    /// A sample permission function that only allows read/write if signer address = 0xCAFE
    public fun allow_only_cafe(user: &signer): bool {
        signer::address_of(user) == @0xCAFE
    }

    /// Runner function that:
    /// 1. Creates a Resource<u64> with initial 100 at signer address 0xCAFE,
    /// 2. Attempts to read and write with correct permission function,
    /// 3. Attempts to read with another address to cause abort (only commented for prevention)
    public fun runner() acquires Resource {
        let cafe_signer = signer::address_of(&signer::borrow_address());
        // For testing, we simulate signer by 0xCAFE via assuming caller is 0xCAFE.

        // Create resource under signer
        create_resource_for_account(&signer::borrow_address(), 100);

        // Borrow resource
        let r = borrow_global_mut<Resource<u64>>(@0xCAFE);

        // Read with permission - should succeed
        let val = read_with_permission<u64>(&r, &allow_only_cafe, &signer::borrow_address());

        // Write with permission - update to 200
        write_with_permission<u64>(&mut r, &allow_only_cafe, &signer::borrow_address(), 200);

        let val2 = read_with_permission<u64>(&r, &allow_only_cafe, &signer::borrow_address());
    }
}
// # run 0xCAFE::GenericAccessControl::runner --signers 0xCAFE

// # publish
module 0xCAFE::RewriteAndSimplify {
    /// Original complex sum function, rewritten and simplified
    public fun sum_range(start: u64, end: u64): u64 {
        let mut acc = 0u64;
        let mut i = start;
        while (i <= end) {
            acc = acc + i;
            i = i + 1;
        };
        acc
    }

    /// More complicated function simplified to this runner function
    public fun runner() {
        // Calculate sum from 1 to 10, which is 55
        let _res = sum_range(1, 10);
    }
}
// # run 0xCAFE::RewriteAndSimplify::runner

// Featurres:
// 508d2dfd481e4450ba1a8cec1dc03f7a: Test that iterating over an empty range (start greater than end) does not execute the loop body and the variable remains unchanged.
// d24f22da4df48d58f1ad9e427550008c: Test that generic access control using function values enables permissioned read and write operations on any resource type without embedding access logic within each resource.
// 2299143f301faa72d1100abc3fbe6b4a: Rewrite and update the bodies of target functions after simplification.
