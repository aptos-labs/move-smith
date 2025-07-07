
//# publish
module 0xCAFE::LambdaAndAdd {
    use std::vector;

    // test_only]
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    // test]
    public fun lambda_add_then_return_const(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            add_u8(a, b)
        };
        let _sum = lambda(x, y);
        42u8
    }

    // test]
    public fun call_inline_from_another_module(x: u8, y: u8): u8 {
        let sum = add_u8(x, y);
        sum + 1
    }
}


//# run 0xCAFE::LambdaAndAdd::lambda_add_then_return_const --args 10u8 11u8


//# run 0xCAFE::LambdaAndAdd::call_inline_from_another_module --args 5u8 8u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaAndAdd;

    // test]
    public fun call_add_and_increase(x: u8, y: u8): u8 {
        let sum = LambdaAndAdd::add_u8(x, y);
        sum + 10u8
    }
}


//# run 0xCAFE::InlineCaller::call_add_and_increase --args 1u8 2u8



//# publish
module 0xCAFE::SumDownTest {
    // test]
    public fun test1(): u64 {
        let total: u64 = 0;
        let n: u64 = 10;

        while (n > 1) {
            total = total + n;
            n = n - 1;
        };

        total = total + n; // add 1 to total finally

        total
    }
}


//# run 0xCAFE::SumDownTest::test1


// module]
spec 0xCAFE::SumDownTest {
    // test]
    fun spec_test_sum() {
        let result = SumDownTest::test1();
        assert!(result == 65, 1001);
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// f955db3c0e30dc86debee7ea9003f840: Test that the `test1` function correctly computes the sum of numbers from 10 down to 1 and returns the expected total of 65.
// c416dc1d62155276b1f629b93409bf9d: Declare module-level spec blocks with the 'module' target.
// 041592336dc733cbed8be719548559d4: Annotate functions or members with #[test] or #[test_only] attributes to mark them as test members.
