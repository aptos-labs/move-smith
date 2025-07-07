
//# publish
module 0xCAFE::TestAdd {
    // Module to test addition of two u8 values and return a specific value

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun runner() {
        let _ = add_two_values(3u8, 8u8);
        let _ = add_two_values(4u8, 5u8);
    }
}


//# run 0xCAFE::TestAdd::runner



//# publish
module 0xCAFE::TestLambda {
    // Module with functions containing lambda (anonymous function) expressions

    public fun call_with_lambda(x: u8, y: u8): u8 {
        let sum_and_product: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };

        let (sum, product) = sum_and_product(x, y);

        let apply_lambda: |u8|u8 has copy+drop = |v: u8| {
            v * 2
        };

        apply_lambda(sum) + apply_lambda(product)
    }

    public fun runner() {
        let _ = call_with_lambda(2u8, 3u8);
        let _ = call_with_lambda(4u8, 5u8);
    }
}


//# run 0xCAFE::TestLambda::runner



//# publish
module 0xCAFE::TestNestedCall {
    use 0xCAFE::TestAdd;

    // Function that calls the inline function in TestAdd module
    public inline fun inline_add(a: u8, b: u8): u8 {
        TestAdd::add_two_values(a, b)
    }

    public fun nested_call(x: u8, y: u8): u8 {
        let z = inline_add(x, y);
        if (z == 42) {
            1u8
        } else {
            0u8
        }
    }

    public fun runner() {
        let _ = nested_call(6u8, 7u8);
        let _ = nested_call(1u8, 1u8);
    }
}


//# run 0xCAFE::TestNestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
