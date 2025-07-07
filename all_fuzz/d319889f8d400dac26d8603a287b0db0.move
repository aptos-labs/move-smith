
//# publish
module 0xCAFE::MathUtil {
    public inline fun add(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_then_increment(x: u8, y: u8): u8 {
        let sum = add(x, y);
        sum + 1
    }

    public fun apply_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun apply_lambda_then_increment(a: u8, b: u8): u8 {
        let add_val = apply_lambda(a, b);
        add_val + 1
    }
}


//# run 0xCAFE::MathUtil::add_then_increment --args 5u8 7u8


//# run 0xCAFE::MathUtil::apply_lambda --args 10u8 15u8


//# run 0xCAFE::MathUtil::apply_lambda_then_increment --args 11u8 12u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::MathUtil;

    public fun nested_add_and_increment(a: u8, b: u8): u8 {
        // Calls the inline function add from MathUtil
        let sum = MathUtil::add(a, b);
        // Calls function in current module that uses MathUtil::add
        sum + 2
    }

    public fun nested_apply_lambda(a: u8, b: u8): u8 {
        MathUtil::apply_lambda_then_increment(a, b)
    }
}


//# run 0xCAFE::NestedCall::nested_add_and_increment --args 20u8 22u8


//# run 0xCAFE::NestedCall::nested_apply_lambda --args 25u8 30u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
