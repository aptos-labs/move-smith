
//# publish
module 0xCAFE::UnpackingAndMembers {
    use std::signer;

    struct Container has copy, drop, store {
        a: u8,
        b: u16,
    }

    struct EmptyStruct has copy, drop, store {}

    // Demonstrate binding a struct entirely with empty unpacking pattern
    public fun bind_full_with_empty_unpacking() {
        let c = Container { a: 1u8, b: 2u16 };

        // Bind full to variable _c using empty unpack pattern
        let c2 = Container {};

        // To make use of empty unpack pattern, we do:
        let Container {} = c;

        // And with empty struct
        let e = EmptyStruct {};
        let EmptyStruct {} = e;
    }

    // Demonstrate detailed error message by asserting false with code including location encoded
    public fun error_with_location() {
        // Compose an error code with location: 0xCAFE module error 1001
        // Normally, an error code is 64-bit. Just pick 1001 here.
        let error_code: u64 = 1001;
        assert!(false, error_code);
    }
}

// Import selected members with aliasing from 0xCAFE::UnpackingAndMembers
// This is a pseudo-import behaviour demonstration since Move does not allow explicit 'members' declarations in code
// But we simulate the effect by declaring a module that re-exports members with aliasing


//# publish
module 0xCAFE::ImportedMembersAlias {
    // Re-export bind_full_with_empty_unpacking from UnpackingAndMembers as unpack_bind
    public fun unpack_bind() {
        0xCAFE::UnpackingAndMembers::bind_full_with_empty_unpacking();
    }

    // Re-export error_with_location as err_loc
    public fun err_loc() {
        0xCAFE::UnpackingAndMembers::error_with_location();
    }
}


//# run 0xCAFE::UnpackingAndMembers::bind_full_with_empty_unpacking


//# run 0xCAFE::UnpackingAndMembers::error_with_location


//# run 0xCAFE::ImportedMembersAlias::unpack_bind


//# run 0xCAFE::ImportedMembersAlias::err_loc


// Featurres:
// 4b9b9b63a27bc5bc5ac5d711e8b686bf: Bind the complete value to a variable using an empty unpacking pattern (i.e., `Name {}` or `Name ()`)
// 4ebd003b016e539a91b7c9e4c96572c2: Use 'members' declarations to import specific members of a module with optional aliasing.
// 5096a1acafda75408ede7e73f6a2359f: Provide Detailed Error Messages Including Error Status and Location
