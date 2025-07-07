
//# publish
module 0xCAFE::AddModule {
    // Test addition of two u8 values and return a specific value
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;

        // Return fixed value 42 if sum matches 10, else return sum
        if (sum == 10) {
            42
        } else {
            sum
        }
    }

    // Function with lambda (anonymous function) that increments a u8 value
    public fun increment_with_lambda(x: u8): u8 {
        let inc: |u8| u8 has copy+drop = |val: u8| { val + 1 };
        inc(x)
    }

    // Inline function returning a tuple of two u8 values
    public inline fun inline_tuple(x: u8): (u8, u8) {
        (x, x + 5)
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 5u8 5u8


//# run 0xCAFE::AddModule::add_and_return_fixed --args 3u8 4u8


//# run 0xCAFE::AddModule::increment_with_lambda --args 9u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    // Call inline function from AddModule and sum the tuple elements
    public fun call_inline_and_sum(x: u8): u8 {
        let (a, b) = AddModule::inline_tuple(x);
        let total = a + b;
        total
    }

    // Use local variable bindings within a code block to bind a u8 value
    public fun local_variable_binding_example(x: u8): u8 {
        {
            let local_var = x + 2;
            local_var
        }
    }

    // Use a lambda inside this module to multiply a u8 value by 3
    public fun triple_with_lambda(x: u8): u8 {
        let triple: |u8| u8 has copy+drop = |v: u8| { v * 3 };
        triple(x)
    }
}


//# run 0xCAFE::CallerModule::call_inline_and_sum --args 7u8


//# run 0xCAFE::CallerModule::local_variable_binding_example --args 10u8


//# run 0xCAFE::CallerModule::triple_with_lambda --args 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// f41d8a3d1188e3abc8d4149f6502b9ff: Declare local variables within code blocks using 'let' bindings
// 5c61c5d0b4b325b7234fc1e563c8324c: Use simple names to reference types, functions, or constants defined in the current context or via aliasing.
