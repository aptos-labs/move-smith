
//# publish
module 0xCAFE::AddModule {
    // Simple function adding two u8 values and returning a u8 result plus a fixed offset
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    // Function containing a lambda that multiplies a and b, returning u8 result
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let mult: |u8, u8| u8 has copy+drop = |x: u8, y: u8| x * y;
        mult(a, b)
    }

    // A public inline function that returns a tuple of (u8,u8)
    public inline fun add_and_double(a: u8): (u8, u8) {
        (a, a * 2)
    }
}


//# publish
module 0xCAFE::CallAddModule {
    use 0xCAFE::AddModule;
    use std::vector;

    // Calls the inline function add_and_double from AddModule, sums the tuple, returns the sum as u8
    public fun call_add_and_double_and_sum(val: u8): u8 {
        let (one, two) = AddModule::add_and_double(val);
        one + two
    }

    // Function demonstrating vector usage with literals and type args
    public fun vector_usage(): u8 {
        let v1 = vector[1u8, 2u8, 3u8];
        let v2: vector<u8> = vector[4u8, 5u8];
        let v3: vector<u8> = vector[];
        let v4 = vector[10u8, 20u8];
        let sum = *vector::borrow(&v1, 0) + *vector::borrow(&v2, 1) + 5u8;
        sum
    }
}


//# run 0xCAFE::AddModule::add_and_offset --args 5u8 7u8


//# run 0xCAFE::AddModule::multiply_lambda --args 3u8 4u8


//# run 0xCAFE::CallAddModule::call_add_and_double_and_sum --args 10u8


//# run 0xCAFE::CallAddModule::vector_usage


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d139b53871f4a67fd9722cb7af8e5085: Use vector/array literals with or without type arguments.
// 956362626ea76d8af911fd1edb9a9551: Avoid using the name 'Self' for module members, as it is restricted.
// 5fe5f0c6c64e1761cc6a8bb2b2be8730: Support different token types (identifier, star, numeric value) after commas to continue parsing additional access specifiers.
