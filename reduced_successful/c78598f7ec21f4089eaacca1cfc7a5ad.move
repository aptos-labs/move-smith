
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }
}


//# run 0xCAFE::TestAddition::add_and_return_sum --args 5u8 7u8


//# publish
module 0xCAFE::TestLambda {
    public fun apply_and_double(x: u8): u8 {
        let multiplier: |u8|u8 has copy + drop = |a: u8| {
            a * 2u8
        };
        multiplier(x)
    }

    public fun run_lambda_with_capture(): u8 {
        let captured = 10u8;
        let add_captured: |u8|u8 has copy + drop = |a: u8| {
            a + captured
        };
        add_captured(5u8)
    }
}


//# run 0xCAFE::TestLambda::apply_and_double --args 6u8


//# run 0xCAFE::TestLambda::run_lambda_with_capture


//# publish
module 0xCAFE::TestNestedCalls {
    use 0xCAFE::TestAddition;

    public inline fun inline_add(a: u8, b: u8): u8 {
        TestAddition::add_and_return_sum(a, b)
    }

    public fun nested_call(): u8 {
        inline_add(2u8, 8u8)
    }
}


//# run 0xCAFE::TestNestedCalls::nested_call


//# publish
module 0xCAFE::TestBinaryOps {
    public fun binary_ops(x: u8, y: u8): u8 {
        let result = ((x + y) * 2u8) / 3u8;
        result - 1u8
    }
}


//# run 0xCAFE::TestBinaryOps::binary_ops --args 3u8 6u8


//# publish
module 0xCAFE::TestLoopControl {
    public fun loop_modify_value(): u8 {
        let val = 0u8;

        for (i in 0..10) {
            if (i % 2 == 0) {
                val += 1u8;
                continue;
            };
            if (val > 4) {
                break;
            };
            val += 2u8;
        };

        val
    }
}


//# run 0xCAFE::TestLoopControl::loop_modify_value


//# publish
module 0xCAFE::TestUnitTypes {
    struct UnitStruct has copy, drop, store {}

    public fun return_unit(): () {
        ()
    }

    public fun unit_value(): UnitStruct {
        UnitStruct {}
    }
}


//# run 0xCAFE::TestUnitTypes::return_unit


//# run 0xCAFE::TestUnitTypes::unit_value


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 67f3c99431dcc7ed5f47fde8005c65a8: Write regular binary operator expressions in code.
// cdd89ec6201f63d1f00c83114f52bb19: Test that the Move script correctly handles the combination of for-loop iteration, break, continue, and conditional modifications to a variable, resulting in the expected final value.
// 1d057386bcda39af1f6c64e60c26b1f8: Define unit types using empty parentheses '()'.
