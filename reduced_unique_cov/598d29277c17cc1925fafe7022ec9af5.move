
//# publish
module 0xCAFE::NestedCalls {
    public inline fun add_one(x: u8): u8 {
        x + 1
    }

    public fun double_then_add_one(x: u8): u8 {
        let doubled = x + x;
        add_one(doubled)
    }
}



//# publish
module 0xCAFE::LambdaTests {
    public fun test_lambda_add(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun lambda_caller(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| {
            a + 10
        };
        f(x)
    }
}



//# publish
module 0xCAFE::ComplexMatch {
    enum Flag {
        A,
        B,
        C
    }

    public fun match_with_if(f: u8): u8 {
        // Convert the u8 to Flag
        let flag = match (f) {
            1 => Flag::A,
            2 => Flag::B,
            3 => Flag::C,
            _ => abort 1,
        };
        let result = match (flag) {
            Flag::A => 1,
            Flag::B if (true) => 2,
            Flag::B => 3,
            Flag::C => 4,
        };
        result
    }
}



//# publish
module 0xCAFE::LiteralExpressions {
    public fun stand_alone_literals() {
        let _ = 123u8;
        let _ = 456u16;
        let _ = 789u64;
        let _ = 0xCAFEu64;
        let _ = true;
        let _ = false;
    }
}



//# run 0xCAFE::LambdaTests::test_lambda_add --args 4u8 5u8



//# run 0xCAFE::LambdaTests::lambda_caller --args 7u8



//# run 0xCAFE::NestedCalls::double_then_add_one --args 3u8



//# run 0xCAFE::ComplexMatch::match_with_if --args 1u8


//# run 0xCAFE::ComplexMatch::match_with_if --args 2u8


//# run 0xCAFE::ComplexMatch::match_with_if --args 3u8



//# run 0xCAFE::LiteralExpressions::stand_alone_literals
