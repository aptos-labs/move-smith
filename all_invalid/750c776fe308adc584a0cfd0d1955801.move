
//# publish
module 0xCAFE::UnpackingAndMembers {
    // Removed unused import signer

    struct Container has copy, drop, store {
        a: u8,
        b: u16,
    }

    struct EmptyStruct has copy, drop, store {}

    // Demonstrate binding a struct entirely with empty unpacking pattern
    public fun bind_full_with_empty_unpacking() {
        let c = Container { a: 1u8, b: 2u16 };

        // We cannot create Container {} because fields are missing, so remove this line:
        // let c2 = Container {};

        // Bind full to variable _c using empty unpack pattern (unpack all fields; since fields exist, must list them)
        // Instead of empty {}, destructure all fields explicitly or bind entire struct:
        let Container { a: _a, b: _b } = c;

        // Or to bind the entire struct (bind the whole value to a variable), just do:
        let _c = c;

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
