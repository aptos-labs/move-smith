//# publish
module 0xCAFE::VectorMapTest {
    use std::vector;

    public fun map_identities() {
        let v: vector<u64> = vector::from_bytes(b"\x01\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00");
        // map identity: adding 0 to each element
        let result = vector::map<u64, u64>(&v, |x: u64| x);
        // use result to prevent optimizer drops
        vector::length(&result);
    }

    public fun map_vector_of_vectors() {
        let v1 = vector::from_bytes(b"\x01\x00\x00\x00\x00\x00\x00\x00");
        let v2 = vector::from_bytes(b"\x02\x00\x00\x00\x00\x00\x00\x00");
        let vv: vector<vector<u64>> = vector::empty();
        let vv = vector::push_back(vv, v1);
        let vv = vector::push_back(vv, v2);

        let vv_mapped = vector::map<vector<u64>, u64>(&vv, |inner| {
            // sum all elements in inner vector
            let mut sum = 0u64;
            let len = vector::length(&inner);
            let mut i = 0;
            while (i < len) {
                sum = sum + *vector::borrow(&inner, i);
                i = i + 1;
            };
            sum
        });
        vector::length(&vv_mapped);
    }

    public fun runner() {
        // Run both test functions
        map_identities();
        map_vector_of_vectors();
    }
}


//# run 0xCAFE::VectorMapTest::runner


//# publish
module 0xCAFE::IdentityMath {
    public fun identity(x: u64): u64 {
        x
    }

    public fun call_identity_multiple_times_and_add(): u64 {
        let a = identity(10);
        let b = identity(a);
        let c = identity(b);
        a + b + c
    }

    public fun runner(): u64 {
        call_identity_multiple_times_and_add()
    }
}

//# run 0xCAFE::IdentityMath::runner


//# publish
module 0xCAFE::CompilerDiagnosticTrigger {
    // This function triggers a compiler exit on diagnostic with severity higher than Warning.
    // It tries to use a non-existent type to cause a compiler-error.
    public fun trigger_error() {
        // Using a type that does not exist to trigger a compile error.
        // Normally this should cause a compiler error and exit.
        // But for transactional tests, this is runtime impossible.
        // So instead, try to call a function that does not exist.
        // This will cause a compiler error on higher severity diagnostic.
        // The line below is purposely invalid:
        let _x: NoSuchType;
    }
}
//# run 0xCAFE::CompilerDiagnosticTrigger::trigger_error

// Featurres:
// 635fb0525118946a50130cecf3ee6bc4: Test that the std::vector::map function works correctly for both vectors of primitive types and vectors of vectors, including closure capturing and element mapping.
// 1fa9545d47ec92a7acf7cd4f5fce8ee8: Test that a Move module can define and invoke a simple identity function multiple times, then perform an arithmetic operation on its result.
// f48f01c31a1fbec319be6b03a383a9bf: Trigger compiler exit on diagnostics with severity higher than Warning.
