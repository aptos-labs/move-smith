
//# publish
module 0xCAFE::LambdaModule {
    const CONST_VALUE: u8 = 42;

    struct Record has copy, drop, store {
        AField: u8,
        BField: u8,
        CField: u8,
    }

    // Top-level function for lambda lifting
    public fun add_two_u8_values(a: u8, b: u8): u8 {
        a + b
    }

    public fun make_struct_with_computation(x: u8, y: u8): Record {
        let a = x;
        let b = y;

        a = a + 1;
        b = b + 2;

        // Initialize struct fields using code block and local vars
        let record = Record {
            AField: a,
            BField: {
                let temp = b;
                temp = temp * 2;
                temp
            },
            CField: CONST_VALUE
        };
        record
    }

    public fun call_lambda_as_function(x: u8, y: u8): u8 {
        // Using the lifted lambda function
        add_two_u8_values(x, y)
    }

    public fun return_lambda(): |u8, u8|u8 {
        let lambda: |u8, u8|u8 has copy+drop = add_two_u8_values;
        lambda
    }
}


//# publish
module 0xCAFE::CallInlineModule {
    use 0xCAFE::LambdaModule;

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        let add_result = LambdaModule::add_two_u8_values(x, y);
        let inline_result = inline_increment(add_result);
        inline_result
    }
}


//# run 0xCAFE::LambdaModule::call_lambda_as_function --args 10u8 15u8


//# run 0xCAFE::LambdaModule::make_struct_with_computation --args 3u8 4u8


//# run 0xCAFE::LambdaModule::return_lambda


//# run 0xCAFE::CallInlineModule::call_inline_and_lambda --args 5u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 23bf4dac0b49aa979852f3fbacf7cb8b: Use lambda lifting to transform lambda expressions into top-level functions.
// e0625019b1a4d12e7166f2a441c05c98: Define constant, struct, and schema names that start with an uppercase letter ('A'..'Z').
// bacae93352e03ee2942d74366e12fca6: Test that struct fields can be initialized using code blocks that mutate local variables, and that the final struct contains the correct computed values.
