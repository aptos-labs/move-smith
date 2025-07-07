
//# publish
module 0xCAFE::Calculator {
    public fun add_then_return_fixed(x: u8, y: u8, fixed: u8): u8 {
        let sum = x + y;
        fixed
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| {
            a + b
        };
        add(x, y)
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Calculator;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun nested_call(x: u8, y: u8, fixed: u8): u8 {
        let val = Calculator::add_then_return_fixed(x, y, fixed);
        let incremented = inline_increment(val);
        incremented
    }
}


//# publish
module 0xCAFE::FlattenAttributes {
    // a1, a2, a3, b1, b2, c1]
    struct AttrStruct has copy, drop, store {
        x: u8
    }

    public fun do_nothing() {}
}


//# run
script {
    use 0xCAFE::Calculator;
    use 0xCAFE::NestedCalls;

    fun main() {
        let fixed_return = 42;
        let r1 = Calculator::add_then_return_fixed(10u8, 20u8, fixed_return);
        let r2 = Calculator::lambda_example(17u8, 25u8);
        let r3 = NestedCalls::nested_call(5u8, 6u8, fixed_return);

        // Note: No assert, just call to exercise compiler & VM.
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 070c1100f7e02cc1cacd103bd588767b: Flatten nested attribute collections into a single attribute list.
