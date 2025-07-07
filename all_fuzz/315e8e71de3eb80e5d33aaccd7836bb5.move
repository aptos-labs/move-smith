
//# publish
module 0xCAFE::AddAndLambda {
    // This module tests addition of two u8 values and usage of lambdas.

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to confirm computation
        sum + 10
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a * b;
        lambda(x, y)
    }

    public fun runner(): u8 {
        let v = add_two_values(5u8, 6u8);
        let w = apply_lambda(3u8, 4u8);
        v + w  // 5+6+10 + 3*4 = 21 + 12 = 33
    }
}



//# run 0xCAFE::AddAndLambda::runner




//# publish
module 0xCAFE::LexerAdvance {
    // This module simulates lexer advancing token when current token matches expected token.

    struct Token has copy, drop, store {
        value: u8,
    }

    // Advances token if current token matches expected, returns new token with value = current + 1
    // Otherwise returns existing token unchanged.
    public fun advance_if_match(curr: Token, expected: u8): Token {
        if (curr.value == expected) {
            let new_value = curr.value + 1;
            Token { value: new_value }
        } else {
            curr
        }
    }

    public fun runner(): u8 {
        let t = Token { value: 5u8 };
        let t2 = advance_if_match(t, 5u8);
        let t3 = advance_if_match(t2, 6u8);
        t3.value
    }
}



//# run 0xCAFE::LexerAdvance::runner



//# publish
module 0xCAFE::PackageInfoWithNamedAddress {
    // This module simulates usage of package info and named address mappings.

    // NamedAddress mapping simulated by constants
    const NAMED_ADDR1: address = @0xDEAD;
    const NAMED_ADDR2: address = @0xBEEF;

    public fun get_named_addr1(): address {
        NAMED_ADDR1
    }

    public fun get_named_addr2(): address {
        NAMED_ADDR2
    }

    struct Info has copy, drop, store {
        id: u8,
        addr: address,
    }

    public fun make_info(id: u8, use_first: bool): Info {
        let addr = if (use_first) {
            NAMED_ADDR1
        } else {
            NAMED_ADDR2
        };
        Info { id, addr }
    }

    public fun runner(): u8 {
        let info1 = make_info(10u8, true);
        let info2 = make_info(20u8, false);
        // sum id fields to confirm function runs correctly
        info1.id + info2.id
    }
}



//# run 0xCAFE::PackageInfoWithNamedAddress::runner




//# run 0xCAFE::AddAndLambda::add_two_values --args 5u8 9u8



//# run 0xCAFE::AddAndLambda::apply_lambda --args 7u8 8u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 42efa3d947de9596936229598f2f727b: Allow modules and scripts to have associated package information and named address mappings.
// 20dcbca416ed119346072c5c3b8dcdb9: Advance the lexer to the next token if the current token matches the specified token.
