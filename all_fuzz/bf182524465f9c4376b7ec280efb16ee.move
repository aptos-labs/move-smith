
//# publish
module 0xCAFE::AdditionModule {
    // Demonstrate a simple function that adds two u8 numbers and returns an incremented result
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Demonstrate lambdas: store, call, and copy a lambda function
    public fun demonstrate_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8,u8) has copy + drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        let (c, d) = lambda(x, y);
        let another_lambda = copy lambda;
        another_lambda(c, d)
    }

    // Inline function returns a tuple
    public inline fun inline_add(a: u8, b: u8): (u8, u8) {
        (a + b, a * b)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    // Calling inline function inline_add from AdditionModule and returning sum part
    public fun call_inline_add(a: u8, b: u8): u8 {
        let (sum, product) = AdditionModule::inline_add(a, b);
        sum
    }

    // A function calling add_and_increment from AdditionModule demonstrating nested function call
    public fun nested_add(a: u8, b: u8): u8 {
        AdditionModule::add_and_increment(a, b)
    }
}


//# publish
module 0xCAFE::NativeStructModule {
    native struct NativeCounter has store, key;
}

// Spec function for lambda expressions lifted
//# publish
module 0xCAFE::SpecLiftedLambda {
    spec fun lifted_add_lambda(a: u8, b: u8): (u8, u8) {
        (a + b, a * b)
    }
}


//# run 0xCAFE::AdditionModule::add_and_increment --args 3u8 5u8


//# run 0xCAFE::AdditionModule::demonstrate_lambda --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_inline_add --args 5u8 7u8


//# run 0xCAFE::CallerModule::nested_add --args 6u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 278bf66aab27186e0dd2501b23f30df9: Declare native structs by marking them as native and ending the declaration with a semicolon.
// c64bd580441fba4897c77db508eac3a4: Create corresponding spec functions for lifted lambda expressions to facilitate specification.
// 801f5e65a832c1b9dc3e1897e51f3fc4: Avoid using sequence expressions (;) inside binary operations (binops) for versions below 2.0 when the check is enabled
