
//# publish
module 0xCAFE::Addition {
    // Provides addition function and lambda tests.

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;

        // Nested block updates sum by adding 1 more
        {
            let local_sum = sum;
            local_sum = local_sum + 1;
            sum = local_sum;
        };

        sum
    }

    public fun test_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = adder(x, y);
        result
    }
}



//# run 0xCAFE::Addition::add_two_values --args 10u8 20u8



//# run 0xCAFE::Addition::test_lambda --args 15u8 25u8




//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::Addition;

    public inline fun inline_adder(a: u8, b: u8): u8 {
        Addition::add_two_values(a, b)
    }

    public fun nested_call(a: u8, b: u8): u8 {
        let sum = inline_adder(a, b);
        sum + 5
    }
}



//# run 0xCAFE::InlineCaller::nested_call --args 3u8 7u8




//# publish
module 0xCAFE::AccessSpecParser {
    use std::option;

    // 🤖 Dummy parser for access specifiers with optional type args and address info.

    struct AccessSpecifier has copy, drop {
        access: vector<u8>,
        ty_arg: option::Option<u8>,
        addr: option::Option<address>,
    }

    public fun parse_access_specifier(raw: vector<u8>): AccessSpecifier {
        let access = raw;

        // dummy: always set ty_arg and addr to some values for testing
        AccessSpecifier { 
            access, 
            ty_arg: option::some(1u8), 
            addr: option::some(@0xCAFE) 
        }
    }

    public fun test_parse(): AccessSpecifier {
        parse_access_specifier(b"public")
    }
}



//# run 0xCAFE::AccessSpecParser::test_parse




//# publish
module 0xCAFE::NestedBlocks {
    // Test nested {} blocks with assignments and references.

    public fun nested_blocks_use(): u8 {
        let a = 0u8;

        {
            let x = 5u8;
            {
                x = x + 10;
                a = x;
            };
        };

        a
    }
}



//# run 0xCAFE::NestedBlocks::nested_blocks_use
