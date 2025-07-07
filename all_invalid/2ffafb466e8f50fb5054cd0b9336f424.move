//# publish
module 0xcafe::TypeParamFormatter {
    use std::string;
    use std::vector;

    // Create a struct to represent a single type parameter with an optional constraint.
    public struct TypeParameter has copy, drop, store {
        name: string::String,
        constraint: option::Option<string::String>,
    }

    // Formats a vector of type parameters into a string for codegen, e.g. "<T: drop, U>"
    public fun format_type_parameters(params: &vector<TypeParameter>): string::String {
        let out = string::utf8(b"<");
        let len = vector::length(params);
        let i = 0;
        while (i < len) {
            let param = vector::borrow(params, i);
            out = string::concat(&out, &param.name);
            // if there is a constraint, add ": constraint"
            if (option::is_some(&param.constraint)) {
                out = string::concat(&out, &string::utf8(b": "));
                out = string::concat(&out, &*option::borrow(&param.constraint));
            };
            if (i != len - 1) {
                out = string::concat(&out, &string::utf8(b", "));
            };
            i = i + 1;
        };
        out = string::concat(&out, &string::utf8(b">"));
        out
    }

    /// Public entry to run all tests
    public entry fun runner(account: &signer) {
        // Compose a vector of type parameters. Test both cases: with and without constraint.
        let mut params = vector::empty<TypeParameter>();
        vector::push_back(&mut params, TypeParameter {
            name: string::utf8(b"T"),
            constraint: option::some(string::utf8(b"copy")),
        });
        vector::push_back(&mut params, TypeParameter {
            name: string::utf8(b"U"),
            constraint: option::none<string::String>(),
        });
        let result = format_type_parameters(&params);
        // Just drop the string - we're not asserting anything
        result;
    }
}
//# run 0xcafe::TypeParamFormatter::runner --signers 0xbeef

//# publish
module 0xcafe::AccessControl {
    // This struct is private to the module
    struct PrivateStruct has store {}

    // This struct is public (module friends can use it)
    public struct FriendStruct has copy, drop, store {}

    // This struct is public everywhere
    public entry struct PublicStruct has key, store {}

    // 'public' function: visible to any module
    public fun pub_fn(x: u8): u8 {
        if (x > 100) {
            42
        } else {
            123
        }
    }

    // 'public(friend)' function: only visible to friends
    public(friend) fun friend_fn(x: u8): u8 {
        if (x < 10) 1 else 9
    }

    // 'public(entry)' entry function: can be invoked by transactions
    public entry fun entry_fn(_signer: &signer) {
        let _x = pub_fn(43);
        let _y = friend_fn(5); // valid inside module
    }

    // runner for test
    public entry fun runner(_s: &signer) {
        entry_fn(_s);
        pub_fn(200);
        // friend_fn(200); // Valid here but not from outside.
    }
}
//# run 0xcafe::AccessControl::runner --signers 0xbeef

//# run
script {
    use 0xcafe::AccessControl;

    fun main(account: &signer) {
        // Exercise conditional 'if' with no else, and with else
        let a = 7u8;
        let b = 150u8;
        let r1 = if (a > 10) 99u8;            // No else (should become unit)
        let r2 = if (b > 100) 1u8 else 2u8;   // With else
        let _x = AccessControl::pub_fn(b);    // Should return 42 since b > 100
        let _y = AccessControl::pub_fn(a);    // Should return 123 since a <= 100
        // Can't call friend_fn - access control test
        r1; r2; _x; _y;
    }
}