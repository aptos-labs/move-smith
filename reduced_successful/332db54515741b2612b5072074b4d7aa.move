
//# publish
module 0xCAFE::LambdaTest {
    public fun with_lambda(x: u8, y: u8): u8 {
        let add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = add(x, y);
        result
    }

    public fun with_closer_lambda(x: u8): u8 {
        let add_x: |u8|u8 has copy+drop = |y: u8| {
            x + y
        };
        add_x(10)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun inline_add_one(a: u8): u8 {
        a + 1
    }

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        let res1 = inline_add_one(x);
        let res2 = LambdaTest::with_lambda(res1, y);
        res2
    }
}


//# publish
module 0xCAFE::LogicTest {
    public fun test(): bool {
        let a = 2;
        let b = 3;
        let inlined = (a + 1) < b;
        let and_result = inlined && (b > a);
        and_result
    }
}


//# run 0xCAFE::LambdaTest::with_lambda --args 20u8 22u8


//# run 0xCAFE::LambdaTest::with_closer_lambda --args 5u8


//# run 0xCAFE::InlineCaller::call_inline_and_lambda --args 5u8 7u8


//# run 0xCAFE::LogicTest::test


// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 909ed64a2802f78d59fde8bba92d29f7: Test that the `test` function correctly evaluates logical AND with inlined expressions involving variable assignments and comparisons.
