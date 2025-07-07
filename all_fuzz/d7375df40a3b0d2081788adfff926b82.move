
//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
    }

    public fun test_lambda(): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(10u8, 20u8)
    }
}



//# run 0xCAFE::AdditionTest::add_and_return_sum --args 40u8 39u8



//# run 0xCAFE::AdditionTest::test_lambda



//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::AdditionTest;

    public inline fun inline_double_add(a: u8, b: u8): u8 {
        let subtotal = AdditionTest::add_and_return_sum(a, b);
        AdditionTest::add_and_return_sum(subtotal, 5)
    }

    public fun runner(): u8 {
        inline_double_add(20u8, 25u8)
    }
}



//# run 0xCAFE::NestedCallTest::runner


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
