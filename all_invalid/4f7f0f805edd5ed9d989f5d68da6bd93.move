
//# publish
module 0xCAFE::AddModule {
    // Module to test addition of two u8 values and returning a specific value
    public fun add_and_return_value(a: u8, b: u8): u8 {
        let sum = a + b; // add two u8
        // return a fixed value 42
        42u8
    }
}


//# run 0xCAFE::AddModule::add_and_return_value --args 20u8 22u8


//# publish
module 0xCAFE::LambdaModule {
    // Module that implements lambdas and tests copy/move semantics

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8|u8 has copy = |x: u8, y: u8| { x + y };
        let result = lambda(10u8, 15u8);
        // Copy the lambda and invoke again
        let lambda2 = copy lambda;
        let _result2 = lambda2(5u8, 5u8);
        result
    }

    public fun run_lambda_move(): u8 {
        let lambda_move: |u8|u8 = |x: u8| {
            let y = x * 2;
            y
        };
        let res = lambda_move(7u8);
        res
    }
}


//# run 0xCAFE::LambdaModule::run_lambda_example


//# run 0xCAFE::LambdaModule::run_lambda_move


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddModule;

    public inline fun inline_addition(a: u8, b: u8): u8 {
        let sum = AddModule::add_and_return_value(a, b);
        sum
    }

    public fun call_inline(): u8 {
        inline_addition(3u8, 4u8)
    }
}


//# run 0xCAFE::InlineCaller::call_inline


//# publish
module 0xCAFE::CopyMoveTest {
    // Test copy and move semantics with variables and expressions

    public fun copy_and_move_test(): u8 {
        let x = 7u8;
        let y = copy x; // copy value
        let z = x; // move value (x invalid hereafter if it were non-copy, but u8 is copy type)
        y + z
    }
}


//# run 0xCAFE::CopyMoveTest::copy_and_move_test


//# publish
module 0xCAFE::CompoundAssign {
    // Test all compound assignment operators for u8 type

    public fun compound_ops(): u8 {
        let x = 10u8;

        x += 5u8;
        x -= 3u8;
        x *= 2u8;
        x /= 4u8;
        x %= 5u8;
        x |= 2u8;
        x &= 6u8;
        x ^= 3u8;
        x <<= 1u8;
        x >>= 1u8;

        x
    }
}


//# run 0xCAFE::CompoundAssign::compound_ops


//# publish
module 0xCAFE::GenericLambda {
    use std::vector;

    // Generic struct with drop ability
    struct Container<T> has drop {
        val: T
    }

    public fun generic_lambda_test(): bool {
        let c = Container<u8> { val: 42u8 };
        let lambda: |Container<u8>| bool has drop = |x: Container<u8>| {
            x.val == c.val
        };
        lambda(c)
    }
}


//# run 0xCAFE::GenericLambda::generic_lambda_test


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// b96217ac07ec5a0c51c55732093eff32: Use the copy and move keywords to control variable semantics in expressions.
// 2f75f3aabce2b59e2781668236d5b818: Use compound assignment operators like "+=", "-=", "*=", "%=", "/=", "|=", "&=", "^=", "<<=", and ">>=" in Move to perform the corresponding binary operation and assignment in a single step
// c0456763eb6fc192c4bd2b7f62e34240: Test that lambdas can capture variables of generic types with the drop ability and use equality (==) inside the lambda body.
