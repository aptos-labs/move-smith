
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

    public fun match_with_if(f: Flag): u8 {
        let result = match (f) {
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
        123u8;
        456u16;
        789u64;
        0xCAFE;
        true;
        false;
    }
}


//# run 0xCAFE::LambdaTests::test_lambda_add --args 4u8 5u8


//# run 0xCAFE::LambdaTests::lambda_caller --args 7u8


//# run 0xCAFE::NestedCalls::double_then_add_one --args 3u8


//# run 0xCAFE::ComplexMatch::match_with_if --args 1u8

//# run 0xCAFE::ComplexMatch::match_with_if --args 2u8

//# run 0xCAFE::ComplexMatch::match_with_if --args 3u8


//# run 0xCAFE::LiteralExpressions::stand_alone_literals


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d5a0a8baa349210b30e6d36b0e91eda3: Add an optional 'if' guard expression to a match arm for conditional matching.
// 4cea096011321d0b7ad43823bd714ce1: Use literal values as standalone expressions
