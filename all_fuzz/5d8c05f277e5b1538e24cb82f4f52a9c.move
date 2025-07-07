
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
    }

    public fun lambda_add(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        add_lambda(x, y)
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 40u8 50u8


//# run 0xCAFE::AddAndReturn::lambda_add --args 12u8 15u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndReturn;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AddAndReturn::add_and_return(a, b)
    }

    public fun call_inline_from_here(x: u8, y: u8): u8 {
        let result = inline_add(x, y);
        result
    }
}


//# run 0xCAFE::NestedCalls::call_inline_from_here --args 20u8 30u8


//# publish
module 0xCAFE::TokenParsingTest {
    public fun tokens_test() {
        let a = 5u8;
        let b = a * (3u8 + 2u8);
        let c = b / 2u8;
        let d = (c - 1u8) % 3u8;
        let _x = d;
    }
}


//# run 0xCAFE::TokenParsingTest::tokens_test


//# publish
module 0xCAFE::BlockExpression {
    public fun block_update_and_access(): u8 {
        let local: u8 = 0;
        let res = {
            local = local + 3;
            local = local + 7;
            local
        };
        res
    }
}


//# run 0xCAFE::BlockExpression::block_update_and_access


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 31c59413fbf6825ea085af5daa314568: Write Move code using tokens that can be recognized and matched during parsing.
// c074aa354e9f190e8e202281e65c259f: Test that blocks used as expressions can update and access local variables within a single expression statement.
