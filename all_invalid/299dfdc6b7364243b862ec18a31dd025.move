
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = if (sum > 10) { 42u8 } else { 24u8 };
        result
    }

    public fun lambda_example(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| { a + 5u8 };
        f(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddAndReturn;

    public fun nested_inline_call(x: u8, y: u8): u8 {
        AddAndReturn::inline_add(x, y) + 1u8
    }
}


//# publish
module 0xCAFE::ReferenceSafety {
    struct R has key, store {
        value: u8
    }

    public fun create_and_borrow(s: &signer) {
        let r = R { value: 100u8 };
        move_to<R>(s, r);

        let addr = signer::address_of(s);
        let r_ref: &R = borrow_global<R>(addr);
        // value is readonly here, accessing field
        let _v = r_ref.value;

        let r_mut_ref: &mut R = borrow_global_mut<R>(addr);
        r_mut_ref.value = 101u8;

        // Clean up
        let _moved_r = move_from<R>(addr);
    }
}


//# publish
module 0xCAFE::VectorExamples {
    public fun create_vectors(): (vector<u8>, vector<bool>, vector<u128>) {
        let v_u8 = vector[1u8, 2u8, 3u8];
        let v_bool = vector[true, false, true];
        let v_u128 = vector[5u128, 6u128];
        (v_u8, v_bool, v_u128)
    }
}


//# publish
module 0xCAFE::ParameterAndVarUsage {
    public fun use_params_and_vars(a: u8, b: u8): u8 {
        let x = a * 2u8;
        let y = b + 2u8;
        let z = x + y;
        z
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 2u8 3u8


//# run 0xCAFE::AddAndReturn::lambda_example --args 7u8


//# run 0xCAFE::NestedCall::nested_inline_call --args 4u8 5u8


//# run 0xCAFE::ReferenceSafety::create_and_borrow --signers 0xBEEF


//# run 0xCAFE::VectorExamples::create_vectors


//# run 0xCAFE::ParameterAndVarUsage::use_params_and_vars --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d909a2208f147d4c283476498aa0ead5: Perform reference safety checks based on features or legacy rules.
// 86c5be919ecd3ad56cff3fa4fd669dbf: Create vector expressions with specified type arguments and element list.
// e593becc494160d3fd18b0080fc9061e: Analyze the usage of function parameters and variables during compilation.
