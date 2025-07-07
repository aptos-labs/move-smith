
//# publish
module 0xBADD::IssuerTest {
    use std::vector;
    use std::option::{Option, some, none};

    // Define a simple issuer info structure
    struct IssuerInfo has copy, drop, store {
        issuer_id: u64,
        name: vector<u8>,
    }

    // Define a structure with entries to test issuer search
    struct S has store {
        entries: vector<IssuerInfo>
    }

    // Public function that searches for an issuer by id
    public fun test(s: &S, issuer_id: u64): Option<IssuerInfo> {
        let i = 0;
        let len = vector::length(&s.entries);
        while (i < len) {
            let info_ref: &IssuerInfo = &vector::borrow(&s.entries, i);
            if ((*info_ref).issuer_id == issuer_id) {
                return some(*info_ref);
            }
            i = i + 1;
        };
        none()
    }

    // Function to create a sample issuer list
    public fun create_sample() {
        let issuer1 = IssuerInfo { issuer_id: 42, name: b"IssuerOne".to_owned() };
        let issuer2 = IssuerInfo { issuer_id: 100, name: b"IssuerTwo".to_owned() };
        let entries = vector::empty<IssuerInfo>();
        vector::push_back(&mut entries, issuer1);
        vector::push_back(&mut entries, issuer2);
        // Create the S object
        let s = S { entries };
        // Search for existing and non-existing issuer
        let _found = test(&s, 42);
        let _not_found = test(&s, 999);
    }
}


//# run 0xBADD::IssuerTest::create_sample

// Featurres:
// eedd322292113ecf0bc84bee7379af96: Verify that the `test` function correctly searches for an issuer in the `S.entries` vector, returns the matching `T` object wrapped in `Option::some` when found, and returns `Option::none` when no match exists.
// 08b3b53bc1c560bd97ad1e7a9d7c3e33: Declare named addresses and assign them values when compiling your Move package.
// a01eac4a9de274c6bfd38c12b8d00ebc: Generate stackless bytecode for each public (non-inline) function defined in target modules
