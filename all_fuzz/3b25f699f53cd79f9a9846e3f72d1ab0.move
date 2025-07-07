
//# publish
module 0xCAFE::AdditionModule {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 to test value computation and return
        sum + 1
    }

    fun internal_only_function(x: u8): u8 {
        // internal function, not marked public
        x * 2
    }
}


//# publish
module 0xCAFE::LambdaModule {
    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun test_variable_shadowing(): u8 {
        let outer_x = 5u8; // use let here is forbidden, so we refactor as below
        let outer_x = outer_x;

        // Closure to shadow outer_x name with inner variable and update the outer variable using shadowing
        let update_outer = |new_val: u8| {
            let outer_x = new_val; // shadowing inner variable named outer_x
            outer_x
        };

        let updated_value = update_outer(10u8);
        // Go back to outer scope and update outer_x using let shadowing
        let outer_x = updated_value;

        outer_x
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_from_other_module(a: u8, b: u8): u8 {
        let sum = AdditionModule::add_then_return_sum(a, b);
        let doubled = sum + sum; // simple operation to confirm nested call works
        doubled
    }

    fun invisible_function(x: u8): u8 {
        x + 100
    }
}


//# run 0xCAFE::AdditionModule::add_then_return_sum --args 7u8 8u8


//# run 0xCAFE::LambdaModule::apply_lambda --args 10u8 15u8


//# run 0xCAFE::LambdaModule::test_variable_shadowing


//# run 0xCAFE::NestedCallModule::call_inline_from_other_module --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e53ba031cf98586b83ffbeda13dc757c: Define functions with visibility modifiers, defaulting to internal visibility.
// 118133204bf7d0b6a196821951fddb7c: Test that a variable shadowed within a closure correctly updates an outer variable when the closure is invoked.
