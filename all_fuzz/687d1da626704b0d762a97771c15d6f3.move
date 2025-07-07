
//# publish
module 0xCAFE::Calc {
    // Module to test addition function, lambdas, and inline function calls

    // Public function to add two u8 values and return the result + 1
    public fun add_plus_one(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Public function containing lambda expressions to add and multiply two u8's, returns sum and product as tuple
    public fun lambda_add_mul(a: u8, b: u8): (u8, u8) {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let mul_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        (add_lambda(a, b), mul_lambda(a, b))
    }

    // Public inline function (with block expression) that multiplies input by 2
    public inline fun double(x: u8): u8 {
        {
            let res = x * 2;
            res
        }
    }

    // Public function that calls the inline function double from this module inside a block
    public fun call_double_plus_one(val: u8): u8 {
        {
            let doubled = double(val);
            doubled + 1
        }
    }
}


//# run 0xCAFE::Calc::add_plus_one --args 15u8 27u8


//# run 0xCAFE::Calc::lambda_add_mul --args 4u8 5u8


//# run 0xCAFE::Calc::call_double_plus_one --args 20u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Calc;

    // Public function that calls Calc::call_double_plus_one and then adds 3 to result
    public fun nested_call(val: u8): u8 {
        {
            let inner_res = Calc::call_double_plus_one(val);
            inner_res + 3
        }
    }
}


//# run 0xCAFE::NestedCall::nested_call --args 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 091505ca23926b0401967a6e6772ead4: Specify public visibility for Move functions or modules with optional sub-modifiers.
// ee6dc628b768379f35b911138f335ffd: Group code using block expressions.
