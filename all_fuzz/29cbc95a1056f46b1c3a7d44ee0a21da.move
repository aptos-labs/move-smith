
//# publish
module 0xCAFE::ResourceAcquire {
    use std::signer;

    struct R has key, store {
        value: u64
    }

    // Function acquires a resource at the signer's address
    public fun acquire(s: signer, v: u64) {
        let r = R { value: v };
        move_to<R>(&s, r);
    }

    // Inline function calls the function that acquires a resource
    public inline fun call_acquire(s: signer, val: u64) {
        Self::acquire(s, val);
    }
}


//# run 0xCAFE::ResourceAcquire::call_acquire --signers 0xC0DE --args 999u64


//# publish
module 0xCAFE::Quantifiers {
    // Example of forall and exists expressions over bindings and ranges
    public fun test_forall_exists() {
        // forall x in 0..10, x < 100 should be true
        assert!((forall x in 0..10: x < 100), 1001);

        // exists y in 0..10, y == 5 should be true
        assert!((exists y in 0..10: y == 5), 1002);

        // forall z in 0..5, z*2 < 20
        assert!((forall z in 0..5: z * 2 < 20), 1003);

        // There exists a w in 10..20 with condition w%3 == 0
        assert!((exists w in 10..20: w % 3 == 0), 1004);

        // using witness expression with condition
        let e = 7;
        assert!((forall a in 0..e: a < 10), 1005);
        assert!((exists b in 0..e: b == 3), 1006);

        // nested quantifiers
        assert!((forall i in 0..3, j in 0..3: i + j < 10), 1007);
    }
}


//# run 0xCAFE::Quantifiers::test_forall_exists


//# run
script {
    // Infinite loop script to test out-of-gas error
    loop {
        // no break, infinite loop
    };
    // This assert must never be reached
    assert!(false, 9999);
}


//# publish
module 0xCAFE::ConflictingAbilitiesBefore {
    // Conflicting abilities declared BEFORE variant list (e.g. has store and key but not copy)
    // This is valid as long as we do not also declare abilities after variants
    // Declared only before variant list here
    enum Variant has store, key {
        A,
        B(u8)
    }

    public fun dummy() {}
}


//# run 0xCAFE::ConflictingAbilitiesBefore::dummy


//# publish
module 0xCAFE::ConflictingAbilitiesAfter {
    // Conflicting abilities declared AFTER variant list only
    enum Variant {
        A has store, key,
        B(u8)
    }

    public fun dummy() {}
}


//# run 0xCAFE::ConflictingAbilitiesAfter::dummy


// Featurres:
// 57baad3637737b510be50aeb101099d1: Test that an inline function can call a function that acquires a resource, and the acquisition is properly propagated.
// 8c62fe7656b5a212416706b16db90891: Write quantified expressions (forall/exists) over variable bindings and ranges, optionally using witness/condition expressions.
// cec20a1c722c30352f8dbd8a196a7ccc: Test that an infinite loop in a script results in an out-of-gas error before reaching any assertions.
// c919a1cd2026b69b6a3d9484a5406c6f: Declare conflicting abilities either before or after the variant list, but not both, to avoid syntax errors.
