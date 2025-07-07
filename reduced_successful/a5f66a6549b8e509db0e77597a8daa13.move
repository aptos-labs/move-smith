// Fixed Move code with proper import statements and unified dependency order

// #publish
//# publish
module 0xCAFE::TestAddLambda {
    use std::signer;

    struct Data has store, key {
        val: u8,
    }

    public fun add_and_return(a: u8, b: u8): u8 {
        let c = a + b;
        // Return fixed value 42 irrespective of sum c
        42u8
    }

    public fun create_data(s: signer, v: u8) {
        let data = Data { val: v };
        move_to<Data>(&s, data);
    }

    public fun use_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let prod = a * b;
            (sum, prod)
        };
        lambda(x, y)
    }

    public fun check_and_remove(s: signer) {
        let addr = signer::address_of(&s);
        assert!(exists<Data>(addr), 100);
        let data_ref: &Data = borrow_global<Data>(addr);
        assert!(data_ref.val == 99u8, 101);
        let data = move_from<Data>(addr);
        let Data { val: _val } = data;
    }
}

// #publish
//# publish
module 0xCAFE::TestNestedInline {
    use 0xCAFE::TestAddLambda;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun nested_call(x: u8, y: u8): u8 {
        let inner = inline_add(x, y);
        let result = TestAddLambda::add_and_return(inner, 0u8);
        result
    }
}

// #publish
//# publish
module 0xCAFE::TokenVerifier {
    use std::signer;

    public fun verify_token_id(s: signer, expected: vector<u8>) {
        let _addr = signer::address_of(&s);
        let actual = vector<u8>[0x54, 0x4F, 0x4B, 0x45, 0x4E]; // "TOKEN"
        assert!(actual == expected, 1234);
    }
}

// #run 0xCAFE::TestAddLambda::add_and_return --args 5u8 7u8

// #run 0xCAFE::TestAddLambda::use_lambda --args 3u8 4u8

// #run 0xCAFE::TestNestedInline::nested_call --args 6u8 8u8

// #run 0xCAFE::TestAddLambda::create_data --signers 0xF00D --args 99u8

// #run 0xCAFE::TestAddLambda::check_and_remove --signers 0xF00D

// #run 0xCAFE::TokenVerifier::verify_token_id --signers 0xDEAD --args b"TOKEN"
