
//# publish
module 0xCAFE::AddAndLambda {
    /// Adds two u8 values and returns u16 result + 100u16 for demonstration.
    public fun add_then_return(x: u8, y: u8): u16 {
        let sum = x + y;
        (sum as u16) + 100u16
    }

    /// Returns a lambda that takes a u8 and returns u8 after adding 42.
    public fun get_add_42_lambda(): |u8| u8 has copy + drop {
        |x: u8| { x + 42 }
    }

    /// Takes a u8 and a lambda, applies lambda to the u8 argument.
    public fun apply_lambda(f: |u8| u8, val: u8): u8 {
        f(val)
    }

    /// Runner function demonstrating lambda usage internally.
    public fun runner_lambda(): u8 {
        let lambda = get_add_42_lambda();
        apply_lambda(lambda, 10u8)
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddAndLambda;

    /// Calls AddAndLambda::add_then_return with 5 and 10, then adds result twice.
    public fun double_add_call(): u32 {
        let r = AddAndLambda::add_then_return(5u8, 10u8);
        let doubled = (r * 2u16) as u32;
        doubled
    }

    /// Calls AddAndLambda::runner_lambda and returns its result.
    public fun call_runner_lambda(): u8 {
        AddAndLambda::runner_lambda()
    }
}


//# run 0xCAFE::AddAndLambda::add_then_return --args 7u8 8u8


//# run 0xCAFE::AddAndLambda::runner_lambda


//# run 0xCAFE::NestedCall::double_add_call


//# run 0xCAFE::NestedCall::call_runner_lambda


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
