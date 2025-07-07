
//# publish
module 0xCAFE::AdditionModule {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_usage(): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(5u8, 7u8)
    }
}


//# run 0xCAFE::AdditionModule::add_then_return_sum --args 10u8 15u8


//# run 0xCAFE::AdditionModule::lambda_usage



//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AdditionModule::add_then_return_sum(a, b)
    }

    public fun call_inline_add(): u8 {
        let x = 20u8;
        let y = 22u8;
        inline_add(x, y)
    }
}


//# run 0xCAFE::InlineCallModule::call_inline_add



//# publish
module 0xCAFE::Diagnostics {
    use std::vector;
    use std::string;

    public fun emit_colored_diag_message(): vector<u8> {
        // simulate colored output as a byte vector, e.g. red text "Error: Something went wrong"
        let red_prefix = x"\x1B[31m";
        let message = b"Error: Something went wrong";
        let reset_suffix = x"\x1B[0m";

        let out = vector::empty<u8>();
        vector::append(&mut out, &red_prefix);
        vector::append(&mut out, &message);
        vector::append(&mut out, &reset_suffix);
        out
    }
}


//# run 0xCAFE::Diagnostics::emit_colored_diag_message



//# publish
module 0xCAFE::TypeParamAbilities<T: copy + drop + store> {
    // Annotating type parameter T with abilities copy, drop, and store

    public fun identity(val: T): T {
        val
    }
}


//# run 0xCAFE::TypeParamAbilities::identity --args 42u8



//# publish
module 0xCAFE::TokenLocation {
    use std::vector;

    // Dummy struct to represent a token with a location span
    struct Token has drop, store {
        start: u64,
        end: u64,
    }

    public fun dummy_token(): Token {
        Token { start: 10, end: 20 }
    }

    public fun get_token_location_span(): (u64, u64) {
        let token = dummy_token();
        (token.start, token.end)
    }
}


//# run 0xCAFE::TokenLocation::get_token_location_span


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 22dc5a71e4f920aae3d8a5ee670ff17e: Generate colored diagnostic output for Move compiler diagnostics
// 2c877806b5aaac93b9a83e2cbd0f5fa0: Annotate each type parameter with its name and a list of abilities that it must satisfy.
// d90691870e0502a5a93f1dc4fe4ecfc9: Retrieve the location span of the consumed token for diagnostic or debugging purposes.
