//# publish
module 0xCAFE::AccessSpecifiersTest {
    use std::signer;

    // A struct with various access specifiers
    struct Data has copy, drop, store {
        pub_field: u8,
        pub(friend) friend_field: u8,
        pub(script) script_field: u8,
        priv_field: u8,
    }

    // Friend module address for friend access testing
    const FRIEND_ADDR: address = 0xBEEF;

    friend 0xBEEF;

    // Constructor to create Data struct instance
    public fun new_data(): Data {
        let pub_field = 1u8;
        let friend_field = 2u8;
        let script_field = 3u8;
        let priv_field = 4u8;
        let data = Data {
            pub_field,
            friend_field,
            script_field,
            priv_field,
        };
        data
    }

    // Access all fields within module: allowed for all fields
    public fun access_fields(data: &Data): u8 {
        let sum = data.pub_field + data.friend_field + data.script_field + data.priv_field;
        sum
    }

    // Function to demonstrate individual access specifier parsing and negation
    // This function only uses the public field and script field (simulate negation by not using friend/priv)
    public fun access_selected_fields(data: &Data): u8 {
        let part1 = data.pub_field;
        let part2 = data.script_field;
        let sum = part1 + part2;
        sum
    }
}

//# run 0xCAFE::AccessSpecifiersTest::new_data

//# run 0xCAFE::AccessSpecifiersTest::access_fields --args 0xCAFE::AccessSpecifiersTest::new_data()

//# run 0xCAFE::AccessSpecifiersTest::access_selected_fields --args 0xCAFE::AccessSpecifiersTest::new_data()

// Featurres:
// 343df347c63616183bef714434732b09: Create a let-binding for a symbol with a specified expression.
// cdcdafb2e2568672a036eadd1b1179b2: Use address specifier 'Literal' to specify a concrete address directly.
// e7e1b7f3526f987faa22de0e1db0cc94: Parse individual access specifiers within the list, considering negation and constructor parameters.
