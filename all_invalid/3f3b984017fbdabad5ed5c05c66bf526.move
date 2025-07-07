
//# publish
module 0xABCD::DeprecatedMembersTest {
    use std::vector;

    // Deprecated ability or member pattern
    struct OldStruct has copy, drop, store, key {
        val: u64,
    }

    // Function that uses deprecated member by intentionally ignoring warnings
    public fun use_deprecated_member() {
        let s = OldStruct { val: 100 };
        // Supposed deprecated member, but no direct deprecation command in Move, so just usage here
        let _ = s.val;
    }

    // Function that uses uninitialized local variable
    public fun use_uninitialized_local() {
        let x: u64;
        // Using uninitialized variable
        let y = x + 1; // This should produce a warning/error
        // last expression
        y
    }
}

//# publish
module 0xDEAD::AddressTest {
    use std::signer;

    // Function to reference an anonymous address literal
    public fun create_anonymous_address() {
        let addr = @0xAABBCCDD; // An explicit hexadecimal address literal
        // Move value or do some operation with the address
        let _ = addr;
    }
}


//# run 0xABCD::DeprecatedMembersTest::use_deprecated_member --signers 0xBADD --args

//# run 0xABCD::DeprecatedMembersTest::use_uninitialized_local --signers 0xBADD

//# run 0xDEAD::AddressTest::create_anonymous_address


// Featurres:
// 5e550e056a0844180685ceff61211e66: Use deprecated members from modules with warning messages.
// 6c81a04d3e438cd650e1b7363a72f69b: Detect uses of uninitialized local variables in functions.
// 4e6061b3a02c98725eb43873a74a9758: Specify anonymous addresses using hexadecimal address literals in your Move code
