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



//# run 0xCAFE::TestModule::apply_lambda --args "x: u8" "(x) => { x + 1 }"

//# run 0xCAFE::TestModule::run_lambda --args "x: u16" "(x) => { x * 2 }"

//# run 0xCAFE::TestModule::generic_identity --args "255u8"