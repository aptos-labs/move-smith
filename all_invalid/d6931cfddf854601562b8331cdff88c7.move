//# publish
module 0xCAFE::AttributeTest {
    use std::vector;

    #[test_attribute]
    struct Dummy has copy, drop {}

    public fun checker_include_attributes() {
        let _local: u8 = 10;
        let _v: vector<u8> = b"attribute check";
    }

    public fun checker_skip_attributes() {
        let _local_in_block = {
            let inner_var = 5u8;
            inner_var
        };
    }
}

//# run 0xCAFE::AttributeTest::checker_include_attributes

//# run 0xCAFE::AttributeTest::checker_skip_attributes

//# publish
module 0xCAFE::ParseErrorMessage {
    public fun generate_unexpected_token_error(token: u8): vector<u8> {
        let msg_prefix = b"Unexpected token: ";
        let mut msg = vector::empty<u8>();
        // push prefix bytes
        let i = 0;
        while (i < vector::length(msg_prefix)) {
            vector::push_back(&mut msg, *vector::borrow(&msg_prefix, i));
            i = i + 1;
        };

        // push token as ascii digit (assuming token is single digit from 0 to 9)
        // token + 48 to convert to ascii digit
        vector::push_back(&mut msg, token + 48);

        msg
    }

    public fun test_error() {
        let error_msg = generate_unexpected_token_error(3u8);
    }
}

//# run 0xCAFE::ParseErrorMessage::test_error


//# publish
module 0xCAFE::LetBindingTest {
    public fun let_in_block() {
        {
            let a = 1u8;
            let b = 2u8;
            let c = a + b;
        };
        let z = {
            let x = 5u8;
            let y = 6u8;
            x * y
        };
        // z is last value
        let _ = z;
    }
}

//# run 0xCAFE::LetBindingTest::let_in_block

// Featurres:
// 3a7fd2a13b75c1bab377da5a0250a1fb: Configure the type checker to include or skip attribute checks and known attributes.
// 942fa01aa1f8670c2b216ffa6de0b1da: Use this function to generate an error message when an unexpected token is encountered during parsing.
// f41d8a3d1188e3abc8d4149f6502b9ff: Declare local variables within code blocks using 'let' bindings
