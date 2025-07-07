
//# publish
module 0xCAFE::TestAddition {
    // Test 1: function that adds two u8 values and returns an expected result

    public fun add_two_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        let expected = 42u8;
        if (sum == expected) {
            sum
        } else {
            0u8
        };
        sum
    }
}


//# run 0xCAFE::TestAddition::add_two_and_return_sum --args 40u8 2u8


//# publish
module 0xCAFE::TestLambda {
    // Test 2: functions containing lambda expressions

    public fun run_lambda_no_args(): u8 {
        let lam: |u8|u8 has copy + drop = |x: u8| { x + 1 };
        lam(5u8)
    }

    public fun run_lambda_multiple_args(): (u8, u8) {
        let lam: |u8, u8| (u8, u8) has copy + drop = |x: u8, y: u8| {
            let sum = x + y;
            let prod = x * y;
            (sum, prod)
        };
        lam(3u8, 4u8)
    }
}


//# run 0xCAFE::TestLambda::run_lambda_no_args


//# run 0xCAFE::TestLambda::run_lambda_multiple_args


//# publish
module 0xCAFE::TestNestedCall {
    use 0xCAFE::TestLambda;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_inline_and_lambda(x: u8): u8 {
        let tmp = inline_increment(x);
        let lam: |u8|u8 has copy + drop = |v: u8| { TestLambda::run_lambda_no_args() + v };
        lam(tmp)
    }
}


//# run 0xCAFE::TestNestedCall::call_inline_and_lambda --args 10u8


//# publish
module 0xCAFE::TestCopyableType {
    // Test 4: annotate copyable type

    struct CopyableStruct has copy, drop {
        val: u8,
    }

    public fun copy_struct(): CopyableStruct {
        let s = CopyableStruct { val: 17u8 };
        let s2 = copy s;
        s2
    }
}


//# run 0xCAFE::TestCopyableType::copy_struct


//# publish
module 0xCAFE::TestOptionalTypeParameter {
    struct Container<T> has copy, drop {
        inner: T
    }

    public fun make_container_u8(x: u8): Container<u8> {
        Container { inner: x }
    }

    public fun make_container_bool(x: bool): Container<bool> {
        Container { inner: x }
    }
}


//# run 0xCAFE::TestOptionalTypeParameter::make_container_u8 --args 123u8


//# run 0xCAFE::TestOptionalTypeParameter::make_container_bool --args true


//# publish
module 0xCAFE::TestVectorCopyAndControlFlow {
    use std::vector;

    // Test 6: Verify copying vectors after control flows: break, assert, continue, multiple breaks

    public fun loop_with_break_then_copy(): vector<u8> {
        let v = vector::empty<u8>();
        for (i in 0..5) {
            if (i == 3) {
                break;
            };
            vector::push_back(&mut v, i);
        };
        let v2 = copy v;
        v2
    }

    public fun loop_with_assert_then_copy(): vector<u8> {
        let v = vector::empty<u8>();
        for (i in 0..4) {
            assert!(i < 10, 100);
            vector::push_back(&mut v, i);
        };
        let v2 = copy v;
        v2
    }

    public fun loop_with_continue_then_copy(): vector<u8> {
        let v = vector::empty<u8>();
        for (i in 0..5) {
            if (i % 2 == 0) {
                vector::push_back(&mut v, i);
            } else {
                continue;
            };
        };
        let v2 = copy v;
        v2
    }

    public fun loop_with_multiple_breaks_then_copy(): vector<u8> {
        let v = vector::empty<u8>();
        let i = 0;
        loop {
            if (i == 2) {
                break;
            };
            vector::push_back(&mut v, i);
            i = i + 1;
            if (i == 4) {
                break;
            };
        };
        let v2 = copy v;
        v2
    }
}


//# run 0xCAFE::TestVectorCopyAndControlFlow::loop_with_break_then_copy


//# run 0xCAFE::TestVectorCopyAndControlFlow::loop_with_assert_then_copy


//# run 0xCAFE::TestVectorCopyAndControlFlow::loop_with_continue_then_copy


//# run 0xCAFE::TestVectorCopyAndControlFlow::loop_with_multiple_breaks_then_copy


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e0de578d1f3cda2f1f6ff0a35d1d15dc: Annotate types as ': copyable' to indicate copyable types.
// 78104274e6d194cd25af700d1fd46a70: Define optional type parameters in your Move code using angle brackets <>.
// 85312436646f64b720f99bf2fbf145a3: Verify that copying vectors after various control flow operations (break, assert, continue, multiple breaks) does not cause invariant violations or errors.
