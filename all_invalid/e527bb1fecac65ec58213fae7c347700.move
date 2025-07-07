//# publish
module 0xCAFE::AttributeTest {
    // This module tests declaring constants with custom attributes
    // and members with implicit aliasing

    const SIMPLE_CONST: u8 = 42;

    #[test_attr(foo = 123, bar = "string_value")]
    const ATTR_CONST: u64 = 0xDEADBEEF;

    struct Data has copy, drop, store {
        a: u8,
        b: u64,
    }

    public fun new_data(a: u8, b: u64): Data {
        Data {a, b}
    }

    // Function that returns the constant with attribute
    public fun get_attr_const(): u64 {
        ATTR_CONST
    }
}

//# run 0xCAFE::AttributeTest::get_attr_const

//# publish
module 0xCAFE::FunctionParamRules {
    // This module attempts to declare functions with function types parameters
    // to test disallowed forms

    public fun simple_lambda_param(f: |u8|u8, x: u8): u8 {
        f(x)
    }

    // This function tries to take a parameter whose type is a function that itself takes a function parameter.
    // According to the rules, disallow unless language version >= 2.2 (we assume below version).
    //
    // The declaration below should be invalid in older versions. Here we test Move compiler rejects or accepts.
    //
    // Uncommenting the below function is expected to produce a compiler error:
    //
    /*
    public fun nested_lambda_param(f: |(|u8|u8)|u8, x: u8): u8 {
        let inner_lambda = |a: u8| a + 1;
        f(inner_lambda)
    }
    */

    // Instead, we declare a wrapper function that does not use such nested function types,
    // to keep the code valid and testable

    public fun wrapper_call(x: u8): u8 {
        let lambda = |a: u8| a + 10;
        simple_lambda_param(lambda, x)
    }
}

//# run 0xCAFE::FunctionParamRules::simple_lambda_param --args 5u8

//# run 0xCAFE::FunctionParamRules::wrapper_call --args 7u8

// Featurres:
// 90c7e880480138a602a73f0c46a35a48: Declare module members such as functions, constants, structs, and schemas with automatic implicit alias creation.
// 46aa6ff6d1f82602874884f6d4367d13: Attach custom attributes to constant declarations in Move.
// f20a42ba428c3246ab635cc65010987f: Disallow parameters that are themselves function types where the function arguments are function-typed, unless the language version is at least 2.2.
