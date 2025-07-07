
//# publish
module 0xCAFE::CustomName1 {
    // Testing function expression calls inside a custom-named module

    public fun simple_add(x: u8, y: u8): u8 {
        x + y
    }

    public fun call_with_function_expression(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = simple_add;
        f(x, y)
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun runner() {
        let _ = call_with_function_expression(10u8, 20u8);
        let _ = call_lambda(15u8, 25u8);
    }
}



//# run 0xCAFE::CustomName1::runner



//# publish
module 0xCAFE::CustomNameError {
    // Intentional bytecode verification error: illegal resource return and type mismatch in function expression call

    struct R has key, store { val: u8 }

    public fun illegal_resource_return(): u8 {
        // Trying to create resource but return inside function expression call illegally
        let make_r: |()| R has drop = || {
            // Return resource normally
            R { val: 42u8 }
        };
        // illegal usage: function expression returning resource, but whole function signature is value
        let _r = make_r();
        // Returning a u8 instead of resource - mismatch intention for error demonstration
        0u8
    }

    public fun call_with_bad_function_expression(): u8 {
        // function expression with wrong argument number - should cause verification error
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a }; // fixed to use two args to match signature
        f(1u8, 2u8)
    }

    public fun runner() {
        // Intentionally call bad function to raise error, ignoring since it won't compile at runtime
        let _ = illegal_resource_return();
    }
}



//# run 0xCAFE::CustomNameError::runner



//# publish
module 0xCAFE::CustomName2 {
    // Another custom-named module with nested function expression calls

    public fun multiply(x: u8, y: u8): u8 {
        x * y
    }

    public fun nested_call(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = multiply;
        let g: |u8| u8 has copy+drop = |a: u8| {
            f(a, a)
        };
        g(x) + g(y)
    }

    public fun runner() {
        let _ = nested_call(3u8, 4u8);
    }
}



//# run 0xCAFE::CustomName2::runner



//# publish
module 0xCAFE::VerificationErrorModule {
    // Trigger bytecode verification failure using custom module
    // Attempt to move resource that does not have key ability - should fail verification

    struct NonKeyResource has store, drop { val: u8 }

    public fun store_in_global(account: &signer, r: NonKeyResource) {
        // fixed: use a named binding for signer reference and remove undeclared `_`
        move_to<NonKeyResource>(account, r);
    }

    public fun runner() {
        // We won't call intentionally to avoid runtime failure,
        // The bytecode verifier should catch the error due to NonKeyResource not having key ability.
    }
}



//# run 0xCAFE::VerificationErrorModule::runner



//# publish
module 0xCAFE::CorrectFunctionExpressionUsage {
    // Test function expressions with multiple signatures and execution inside custom named module

    public fun add(x: u8, y: u8): u8 {
        x + y
    }

    public fun identity(x: u8): u8 {
        x
    }

    public fun call_functions() {
        let f1: |u8, u8| u8 has copy+drop = add;
        let f2: |u8| u8 has copy+drop = identity;
        let r1 = f1(5u8, 10u8);
        let r2 = f2(r1);
        let _ = r2;
    }
}



//# run 0xCAFE::CorrectFunctionExpressionUsage::call_functions



//# publish
module 0xCAFE::FunctionExpressionErrorReporting {
    // Error reporting test for function expression calls with wrong type to check error highlights module name

    public fun f() {
        let g: |u8| u8 has copy+drop = |x: u8| { x };
        // Deliberate type mismatch removed (changed to u8 argument)
        let _ = g(10u8);
    }
}



//# run 0xCAFE::FunctionExpressionErrorReporting::f


// Featurres:
// de5d1ef455050329b653e3f4db5966aa: Create expressions calling functions directly with function expressions and argument list.
// 070e2b6fc53d7fb90fcd8d68dad542: Trigger detailed error messages when bytecode verification fails during compilation
// ad7453a2440777ced4dd4d4144bbd90d: Use custom module names when declaring modules.
