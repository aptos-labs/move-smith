
//# publish
module 0xCAFE::AdditionWithLambda {
    use std::signer;

    // A resource to require acquisition
    struct Req has key, store {
        value: u8,
    }

    // Function to create the resource at address
    public fun create_resource(s: signer, init_val: u8) {
        let r = Req { value: init_val };
        move_to<Req>(&s, r);
    }

    // Function that takes two u8 values, uses lambda to add them, then returns a fixed u8
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let _sum = adder(x, y);
        42u8
    }

    // Lambda that doubles a u8 and adds a literal pragma value
    public fun lambda_double_plus_pragma(x: u8): u8 {
        let double_then_add: |u8| u8 has copy+drop = |a: u8| {
            a * 2 + 7u8
        };
        double_then_add(x)
    }

    // A function requiring the Req resource acquisition
    public fun requires_resource(s: signer) {
        let r_ref: &Req = borrow_global<Req>(signer::address_of(&s));
        let _val = r_ref.value;
    }
}


//# publish
module 0xCAFE::NestedInline {
    // Inline function that returns a tuple of u8 plus 10 and 20
    public inline fun inline_adds(x: u8): (u8, u8) {
        (x + 10, x + 20)
    }

    // Inline function calling the above and returning sum
    public inline fun inline_sum(x: u8): u8 {
        let (a, b) = inline_adds(x);
        a + b
    }
}


//# publish
module 0xCAFE::ExternalCall {
    use 0xCAFE::NestedInline;

    // Calls the inline_sum from NestedInline and returns its value
    public fun call_inline_sum(x: u8): u8 {
        NestedInline::inline_sum(x)
    }
}


//# run 0xCAFE::AdditionWithLambda::add_and_return_fixed --args 5u8 10u8


//# run 0xCAFE::AdditionWithLambda::lambda_double_plus_pragma --args 8u8


//# run 0xCAFE::AdditionWithLambda::create_resource --signers 0xBEEF --args 100u8


//# run 0xCAFE::AdditionWithLambda::requires_resource --signers 0xBEEF


//# run 0xCAFE::ExternalCall::call_inline_sum --args 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 16f1fa111618657d38811598b03ce406: Use pragma values that are literals in your Move code.
// 37da633f3238847ecfcdf88c3f02c896: Specify resource acquisition requirements for functions.
// 6b96d6915bf62b0b7ab660278c334d1e: Write non-native functions within target modules that will be checked by the compiler.
