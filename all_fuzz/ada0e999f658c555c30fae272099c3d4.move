
//# publish
module 0xCAFE::TestFeatures {
    use std::vector;

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            let _ignore = 1;
        } else {
            let _ignore = 2;
        };
        sum
    }

    public fun test_lambda_usage(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let add = a + b;
            let mult = a * b;
            (add, mult)
        };
        lambda(x, y)
    }

    public inline fun inline_increment(a: u16): u16 {
        a + 1
    }
}


//# publish
module 0xCAFE::TestNestedCall {
    use 0xCAFE::TestFeatures;

    public fun nested_call(a: u16): u16 {
        let inc = TestFeatures::inline_increment(a);
        let (inc2, inc3) = (inc + 1, inc + 2);
        inc3
    }
}


//# publish
module 0xCAFE::TestEvaluationOrder {
    use std::vector;

    // This function has side effect of pushing to vector, returning pushed value
    // We use it to test evaluation order of arguments
    public fun push_and_return(v: &mut vector<u8>, val: u8): u8 {
        vector::push_back(v, val);
        val
    }

    public fun test_order(): vector<u8> {
        let v = vector::empty<u8>();

        let r = add_and_mul(
            push_and_return(&mut v, 1),
            push_and_return(&mut v, 2)
        );
        // r is unused, we only want to test evaluation order

        v
    }

    fun add_and_mul(a: u8, b: u8): u8 {
        a + b * 2
    }
}


//# run 0xCAFE::TestFeatures::add_and_return_sum --args 4u8 6u8


//# run 0xCAFE::TestFeatures::test_lambda_usage --args 3u8 5u8


//# run 0xCAFE::TestNestedCall::nested_call --args 10u16


//# run 0xCAFE::TestEvaluationOrder::test_order


//# publish
module 0xCAFE::TestSequence {

    public fun sequence_1(): u8 {
        let a = 1;
        let b = 3;
        let c = a + b;

        let res = if (c > 3) {
            let d = c + 4;
            d
        } else {
            let d = c - 1;
            d
        };

        res
    }

    public fun block_sequence(): u8 {
        let x = 0;

        {
            let a = 1;
            let b = 2;
            let c = a + b;
            x = c;
        };

        let res = x + 2;
        res
    }
}


//# run 0xCAFE::TestSequence::sequence_1


//# run 0xCAFE::TestSequence::block_sequence


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 28ec4e78c25eb370b5326ebc673bad3b: Test evaluation order of function arguments to ensure that expressions with side effects are executed left-to-right.
// 334af8b93b6806c10fbc9f479f2cef89: Write sequences of statements inside functions or blocks
