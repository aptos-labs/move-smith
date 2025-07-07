
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42
        } else {
            0
        }
    }

    // Move does not support `|args|: return_type {}` lambda syntax.
    // The correct lambda syntax is without explicit return type.
    // Also, the type of a lambda is inferred or you can specify a function.
    // In Aptos Move, lambdas are specified simply as |args| { body }
    public fun call_lambda(x: u8, y: u8): u8 {
        let lambda = |a: u8, b: u8| { a + b };
        lambda(x, y)
    }
}


//# run 0xCAFE::AddAndReturn::add_then_return --args 5u8 7u8


//# run 0xCAFE::AddAndReturn::add_then_return --args 3u8 4u8


//# run 0xCAFE::AddAndReturn::call_lambda --args 8u8 9u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndReturn;

    public fun run_nested_calls(x: u8, y: u8): u8 {
        // Remove the explicit return type annotation ':' from lambda syntax
        let lambda = |z: u8| { AddAndReturn::add_then_return(z, 1u8) };
        AddAndReturn::call_lambda(x, y) + lambda(9u8)
    }
}


//# run 0xCAFE::NestedCalls::run_nested_calls --args 3u8 4u8
