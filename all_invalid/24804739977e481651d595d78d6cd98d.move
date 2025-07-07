//# publish
pragma friend, sarus = "syntax tester";

module 0xCAFE::FriendPragmaTest {
    // Define a struct with variant (enum-like) layout
    struct Value has copy, drop, store {
        amount: u64,
    }

    // We define a variant-style enum-like struct using inline variant syntax:
    // Note: this experimental syntax resembles enum variant patterns.
    struct MyEnum has copy, drop, store {
        // variant id: 0 means a None, no fields
        // variant id: 1 means Some with one field
        variant: u8,
        value: OptionValue,
    }

    // to simulate variant payload
    struct OptionValue has copy, drop, store {
        // A union-style field: will be used only if variant == 1
        some_value: u64,
    }

    // Friend function example - friend property is allowed in pragma
    friend fun friend_function(): u64 {
        42
    }

    public fun runner() {
        // Call friend function
        let _ = friend_function();
    }
}

//# run 0xCAFE::FriendPragmaTest::runner


//# publish
pragma friend, experimental = "testing variant";

module 0xCAFE::VariantStructTest {
    // Variant-like enum layout using the 'variant' pragma property
    #[pragma("variant")]
    struct Either has copy, drop, store {
        tag: u8,
        value: [u8; 8],
    }

    public fun create_left(val: u64): Either {
        Either {
            tag: 0,
            value: std::bcs::to_bytes(&val),
        }
    }

    public fun create_right(val: u64): Either {
        Either {
            tag: 1,
            value: std::bcs::to_bytes(&val),
        }
    }

    public fun runner() {
        let left = create_left(100);
        let right = create_right(200);
        let _ = left;
        let _ = right;
    }
}

//# run 0xCAFE::VariantStructTest::runner


//# publish
pragma friend, advanced = "true";

module 0xCAFE::PragmaPropertyTest {
    #[pragma("friend")]
    struct FriendStruct has copy, drop, store {
        x: u8
    }

    #[pragma("sarus")]
    struct SarusStruct has copy, drop, store {
        y: u64
    }

    public fun runner() {
        let a = FriendStruct { x: 5 };
        let b = SarusStruct { y: 20 };
        let _ = a;
        let _ = b;
    }
}

//# run 0xCAFE::PragmaPropertyTest::runner


//# run
script {
    use 0xCAFE::FriendPragmaTest;
    use 0xCAFE::VariantStructTest;
    use 0xCAFE::PragmaPropertyTest;

    fun main() {
        FriendPragmaTest::runner();
        VariantStructTest::runner();
        PragmaPropertyTest::runner();
    }
}

// Featurres:
// 3d4de455fbf6f87677a9c22a23f67039: Use the special 'friend' property in pragmas even though 'friend' is a keyword.
// d0b9ca2312f76c196717e0a06e1559ef: Define structs with variant (enum-like) layouts in your modules
// a0acdd7e316f1a5305cfc4df1f43adfe: Define pragmas with properties in Move code using the 'pragma' syntax.
