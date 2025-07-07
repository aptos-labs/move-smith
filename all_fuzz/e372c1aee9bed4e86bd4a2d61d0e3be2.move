
//# publish
module 0xCAFE::MathModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            10u8
        } else {
            sum
        }
    }

    public fun lambda_example(): (u8, u8) {
        let add = |x: u8, y: u8| {
            x + y
        };
        let multiply = |x: u8, y: u8| {
            x * y
        };
        (add(3u8, 4u8), multiply(3u8, 4u8))
    }
}



//# run 0xCAFE::MathModule::add_two_values --args 7u8 4u8



//# run 0xCAFE::MathModule::lambda_example



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::MathModule;

    public inline fun inline_increment(x: u16): u16 {
        x + 1u16
    }

    public fun nested_calls(a: u8, b: u8): u8 {
        let base_sum = MathModule::add_two_values(a, b);

        let triple_increment = |x: u8| {
            let x_u16 = x as u16;
            let x1 = inline_increment(x_u16);
            let x2 = inline_increment(x1);
            let x3 = inline_increment(x2);
            x3 as u8
        };

        let incremented = triple_increment(base_sum);
        incremented
    }
}



//# run 0xCAFE::NestedCallModule::nested_calls --args 2u8 5u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
