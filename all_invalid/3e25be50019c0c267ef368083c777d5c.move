
//# publish
module 0xCAFE::AddModule {
    public fun add_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 200) {
            200u8
        } else {
            sum
        }
    }
}


//# run 0xCAFE::AddModule::add_values --args 100u8 90u8


//# publish
module 0xCAFE::LambdaModule {
    // A function that defines and calls a lambda returning u8
    public fun call_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * 2 + b
        };
        lambda(x, y)
    }

    // Function to test a nested lambda using the wildcard *
    public fun nested_lambda_using_wildcard(x: u8): u8 {
        let f: |u8| u8 has copy+drop = |*a: u8| {
            let g: |u8| u8 has copy+drop = |b: u8| {
                a + b
            };
            g(x)
        };
        f(x)
    }
}


//# run 0xCAFE::LambdaModule::call_lambda --args 5u8 7u8


//# run 0xCAFE::LambdaModule::nested_lambda_using_wildcard --args 10u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddModule;

    public inline fun do_inline_call(a: u8, b: u8): u8 {
        AddModule::add_values(a, b)
    }

    public fun runner(): u8 {
        let r1 = AddModule::add_values(20u8, 30u8);
        let r2 = do_inline_call(40u8, 10u8);

        r1 + r2
    }
}


//# run 0xCAFE::InlineCaller::runner


//# publish
module 0xCAFE::ApplyModule {
    public fun apply(f: |u8, u8| u8, x: u8, y: u8): u8 {
        f(x, y)
    }

    public fun double_apply(): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        let r1 = apply(f, 7u8, 8u8);
        let r2 = apply(f, r1, 5u8);

        // nested apply call: apply(f, apply(f, 7, 8), 5)
        r2
    }
}


//# run 0xCAFE::ApplyModule::apply --args 3u8 4u8


//# run 0xCAFE::ApplyModule::double_apply


//# publish
module 0xCAFE::EmptyListModule {
    // Function with empty item lists between delimiters (using vector)
    public fun empty_vector_creation(): vector<u8> {
        vector[]
    }

    // Function to create a vector with some empty vector elements to check allowance
    public fun vector_of_vectors(): vector<vector<u8>> {
        let v1 = vector[1u8, 2u8];
        let v2 = vector[];
        let v3 = vector[3u8];
        vector[v1, v2, v3]
    }
}


//# run 0xCAFE::EmptyListModule::empty_vector_creation


//# run 0xCAFE::EmptyListModule::vector_of_vectors


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a2d395f7cc514b343f4569a28ad36e2a: Test that the `apply` function correctly executes a passed-in lambda function with provided arguments, and verify that nested `apply` calls produce the expected combined result.
// f0b018110a66295be45449caa5ffcaac: Permit empty item lists between supported delimiters by omitting elements entirely.
// 66a202cdf3fe7cc0865164a92984daaf: Use the wildcard character '*' in your Move code in contexts where it's permitted, as an alternative to a specific identifier.
