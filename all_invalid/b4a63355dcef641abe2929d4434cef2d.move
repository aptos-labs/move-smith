//# publish
module 0xCAFE::ConditionalAndSignerTest {
    use std::signer;

    struct UniqueStruct has copy, drop, store {
        val: u8,
    }

    // Uncommenting below struct with same name would cause compiler error for duplicate struct name.
    // struct UniqueStruct has copy, drop, store {
    //     val2: u8,
    // }

    public fun test_if_else_expr(x: u8, y: bool): u8 {
        if (y) {
            x + 10
        } else {
            x + 20
        };
        let result = if (x > 5) { 1u8 } else { 0u8 };
        result
    }

    public fun test_signer_value(s: signer): address {
        signer::address_of(&s)
    }

    public fun test_address_param(addr: address): u8 {
        if (addr == @0xCAFE) {
            42u8
        } else {
            0u8
        }
    }
}

//# run 0xCAFE::ConditionalAndSignerTest::test_if_else_expr --args 3u8 true

//# run 0xCAFE::ConditionalAndSignerTest::test_if_else_expr --args 7u8 false

//# run 0xCAFE::ConditionalAndSignerTest::test_signer_value --signers 0x42A1

//# run 0xCAFE::ConditionalAndSignerTest::test_address_param --args 0xCAFE

//# run 0xCAFE::ConditionalAndSignerTest::test_address_param --args 0xBEEF

// Featurres:
// 90b0011045b6d2bb1a0407e441a41a35: Use if-else expressions for conditional branching.
// 9ed516af7a96fbc4dc354976e0781049: Prevent duplicate struct definition by enforcing unique struct names within a module.
// 83c06cbebf5e16f55464d356698f5ce6: Use signer, &signer, or address types as parameters in test functions, with address or signer values assigned through test attributes.
