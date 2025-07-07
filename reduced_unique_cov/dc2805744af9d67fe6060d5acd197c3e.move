
//# publish
module 0xCAFE::LambdaAndInline {
    // Use nested inline functions and lambdas and test function return types with signature

    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_lambda(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            // call inline function from this module
            let sum = add_u8(x, y);
            sum
        };
        lambda(5u8, 7u8)
    }

    public inline fun nested_inline_call(x: u8): u8 {
        // call inline function inside inline function
        add_u8(call_lambda(), x)
    }

    // Demonstrate explicit return type signature in nested function call
    public fun runner(): u8 {
        nested_inline_call(3u8)
    }

    public fun unit_value(): unit {
        // Represent Unit value explicitly
    }

    public fun error_code(): u64 {
        // Represent an arbitrary Error code (arbitrary chosen 42)
        42
    }

    public fun break_example(x: u8): u8 {
        let y = 0u8;
        loop {
            y = y + 1;
            if (y == x) {
                break;
            };
        };
        y
    }

    public fun continue_example(): u8 {
        let sum = 0u8;
        let i = 0u8;
        loop {
            i = i + 1;
            if (i % 2 == 0) {
                continue;
            };
            sum = sum + i;
            if (i >= 5) {
                break;
            };
        };
        sum
    }

    // Specification kind: a public function with no-op
    public fun spec_example() {
        // no action, just a placeholder for a specification function
    }
}


//# run 0xCAFE::LambdaAndInline::call_lambda


//# run 0xCAFE::LambdaAndInline::runner


//# run 0xCAFE::LambdaAndInline::unit_value


//# run 0xCAFE::LambdaAndInline::error_code


//# run 0xCAFE::LambdaAndInline::break_example --args 3u8


//# run 0xCAFE::LambdaAndInline::continue_example


//# run 0xCAFE::LambdaAndInline::spec_example


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaAndInline;

    public fun call_nested(): u8 {
        let res = LambdaAndInline::runner();
        res
    }

    public fun call_lambda_direct(): u8 {
        LambdaAndInline::call_lambda()
    }
}


//# run 0xCAFE::CallerModule::call_nested


//# run 0xCAFE::CallerModule::call_lambda_direct


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 012d26d0b9ed7f7b64abe0065f49856b: Declare function return types with clearly specified signature.
// c17a12b242a42c345e3c4c5630cdd985: Organize Move code into packages with named address mappings.
// 3c6f7b128895352b52d552e50b9b1a02: Create value expressions representing Unit, Error, Break, Continue, Specification, or Value types.
