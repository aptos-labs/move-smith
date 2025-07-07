
//# publish
module 0xCAFE::AdditionHelper {
    // Provide an inline function for adding two u8 numbers
    public inline fun add_two_numbers(a: u8, b: u8): u8 {
        a + b
    }
}

//# publish
module 0xCAFE::AdditionWithLambda {
    // Remove unused import
    // use std::vector;

    // Simple struct for pattern matching wildcard test
    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
        c: u8,
    }

    // Inline function to add two u8 numbers and return u8
    public inline fun add_two_numbers(x: u8, y: u8): u8 {
        x + y
    }

    // A function that returns another function (lambda) that adds a captured value to input
    public fun make_adder(x: u8): |u8|u8 has copy + drop {
        let lambda: |u8|u8 has copy + drop = |y: u8| {
            x + y
        };
        lambda
    }

    // Function that uses an anonymous function to multiply two u8 numbers and return u8
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy + drop = |x: u8, y: u8| {
            x * y
        };
        lambda(a, b)
    }

    // Function demonstrating nested calls including inline function from another module
    public fun nested_calls(x: u8, y: u8): u8 {
        // Import AdditionHelper explicitly to call add_two_numbers
        use 0xCAFE::AdditionHelper;

        // call inline add_two_numbers from this module
        let sum1 = add_two_numbers(x, y);

        // call inline add_two_numbers from AdditionHelper module
        let sum2 = AdditionHelper::add_two_numbers(x, y);

        sum1 + sum2
    }

    // Function demonstrating pattern matching with wildcard (dot-dot) syntax
    public fun match_with_wildcard(p: Pair): u8 {
        let res = match (p) {
            Pair { a, .. } => a,
            // No other patterns needed due to wildcard
        };
        res
    }

    // Function demonstrating lambda capturing variable and returning result
    public fun lambda_captures(x: u8, y: u8): u8 {
        let z = 10u8;
        let lambda: |u8|u8 has copy + drop = |a: u8| { a + x + y + z };
        lambda(1u8)
    }
}



//# run 0xCAFE::AdditionWithLambda::add_two_numbers --args 5u8 7u8



//# run 0xCAFE::AdditionWithLambda::make_adder --args 10u8



//# run 0xCAFE::AdditionWithLambda::multiply_lambda --args 3u8 4u8



//# run 0xCAFE::AdditionWithLambda::nested_calls --args 2u8 3u8



//# run 0xCAFE::AdditionWithLambda::match_with_wildcard --args 0u8 8u8 9u8



//# run 0xCAFE::AdditionWithLambda::lambda_captures --args 1u8 2u8
