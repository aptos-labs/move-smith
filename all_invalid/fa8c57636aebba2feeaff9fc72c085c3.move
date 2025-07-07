
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // A simple constant declaration inside the module (to test const declaration in module context)
    const TEST_CONST: u32 = 42;

    // A helper function to test lambda lifting and execution
    public fun apply_lambda<U: copy + drop>(f: |U|U, x: U): U {
        f(x)
    }

    // Function that accepts a function (lambda) and an argument, applies the lambda
    public fun run_lambda<U: copy + drop>(f: |U|U, value: U): U {
        apply_lambda<U>(f, value)
    }

    // Function with an optional type parameter and a name to test generic function definition
    public fun generic_identity<T: copy + drop>(x: T): T {
        x
    }
}


//# run 0xCAFE::TestModule::apply_lambda --args |(x: u8) => { x + 1 }| 5u8

//# run 0xCAFE::TestModule::run_lambda --args |(x: u16) => { x * 2 }| 7u16

//# run 0xCAFE::TestModule::generic_identity --args 255u8


// Featurres:
// 0d6365c3d97425026c7c36a335942a3b: Include constant declarations using 'const' inside your script.
// fde3067b4279feb6bf0ad115fc730ec6: Use lambda-style expressions in specifications, which will be lifted into new functions for later specification rewriting and processing.
// a0056ab4bdc4a5e262f9b3fda402ab12: Define functions with a name and optional type parameters.
