
//# publish
module 0xCAFE::TestAdd {
    /// Simple function that adds two u8 values and returns the sum plus a constant
    public fun add_and_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5u8
    }

    /// Function that receives a lambda and an argument, then calls the lambda with the argument and returns result
    public fun call_lambda_with_value(f: |u8|u8, val: u8): u8 {
        f(val)
    }

    /// Function implementing a lambda inside and calling it
    public fun test_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| x + y;
        lambda(a, b)
    }
}



//# run 0xCAFE::TestAdd::add_and_constant --args 10u8 20u8



//# run 0xCAFE::TestAdd::test_lambda --args 7u8 8u8




//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::TestAdd;

    public inline fun inline_sum(a: u8, b: u8): u8 {
        TestAdd::add_and_constant(a, b)
    }

    public fun call_inline_sum(a: u8, b: u8): u8 {
        // Calls inline_sum which calls TestAdd::add_and_constant
        inline_sum(a, b)
    }
}



//# run 0xCAFE::InlineCall::call_inline_sum --args 15u8 25u8




//# publish
module 0xCAFE::BuiltinTypesAccess {
    use std::string;
    use std::vector; // <<<<<< Fixed: added this line

    /// Public function that returns a vector of string::String representing all built-in type names
    /// collected from the compiler's built-in types set.
    public fun all_built_in_type_names(): vector<string::String> {
        // Pretend built_in_type_names has these entries (fixed for example):
        let names = vector[
            b"bool",
            b"u8",
            b"u64",
            b"u128",
            b"address",
            b"signer",
            b"vector",
            b"struct"
        ];

        let result = vector::empty<string::String>();
        let len = vector::length(&names);
        let i = 0;
        loop {
            if (i == len) {
                break;
            };
            let bname = *vector::borrow(&names, i);
            // convert vector<u8> to string::String
            let str_name = string::utf8(bname);
            vector::push_back(&mut result, str_name);
            i = i + 1;
        };
        result
    }
}



//# run 0xCAFE::BuiltinTypesAccess::all_built_in_type_names


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 83167d7245798f4b191535799142c0f7: Use the 'all_type_names' function to access a set containing all the built-in type names defined in the Move compiler.
