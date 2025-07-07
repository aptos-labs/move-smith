
//# publish
module 0xCAFE::ExpressionTest {
    // Function to be called by function expression
    public fun add_one(x: u8): u8 {
        x + 1
    }

    // run a function expression call
    public fun call_with_function_expression(x: u8): u8 {
        let f: |u8|u8 = add_one;
        f(x)
    }

    // Function with phantom type parameter
    struct PhantomHolder<phantom T> has copy, drop {}

    // Function instantiating PhantomHolder
    public fun create_phantom_holder<phantom T>(): PhantomHolder<T> {
        PhantomHolder<T> {}
    }
}

///// run commands for ExpressionTest


//# run 0xCAFE::ExpressionTest::call_with_function_expression --args 5u8


//# run 0xCAFE::ExpressionTest::create_phantom_holder --args u8


// Explicit sender address module with type param and phantom annotation

//# publish
module 0xBEEF::ExplicitSenderModule {
    struct PhantomStruct<phantom T> has copy, drop, store {}

    public fun instantiate_phantom<phantom T>(): PhantomStruct<T> {
        PhantomStruct<T> {}
    }

    public fun double_value(x: u64): u64 {
        x * 2
    }
}


//# run 0xBEEF::ExplicitSenderModule::instantiate_phantom --args u64


//# run 0xBEEF::ExplicitSenderModule::double_value --args 42u64


// Featurres:
// de5d1ef455050329b653e3f4db5966aa: Create expressions calling functions directly with function expressions and argument list.
// dbc61010b56c6e17fc7d45d9a6cfbc23: Define type parameters with optional 'phantom' annotations
// a5766060eb9e75a79b062a6b7c84bbd4: Declare a module with an explicit sender address using 'module <address>::ModuleName'.
