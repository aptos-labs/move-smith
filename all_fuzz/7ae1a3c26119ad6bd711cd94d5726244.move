
//# publish
module 0xCAFE::AddU8Module {
    // This module tests addition of two u8 values with a specific return value.

    // A simple function that adds two u8 numbers then returns the addition plus 10
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    // A function that defines and calls a lambda (anonymous function)
    public fun call_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b + 5
        };
        lambda(x, y)
    }

    // Unit type represented by empty tuple parentheses
    struct Unit has copy, drop {}

    // Function that returns the unit type value
    public fun unit_value(): Unit {
        Unit {}
    }
}


//# run 0xCAFE::AddU8Module::add_and_offset --args 3u8 4u8


//# run 0xCAFE::AddU8Module::call_lambda --args 7u8 2u8


//# run 0xCAFE::AddU8Module::unit_value


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddU8Module;

    // A public inline function with empty body to be inlined away
    public inline fun inline_no_body(): u8 {
        42u8
    }

    // A public function that calls an inline function from AddU8Module and add 1 to its result
    public fun nested_inline_call(x: u8, y: u8): u8 {
        let sum = AddU8Module::add_and_offset(x, y);
        let inline_val = inline_no_body();
        sum + inline_val + 1u8
    }

    // Separate function to demonstrate a specification block usage
    spec module {
        fun dummy_spec(): bool {
            true
        }
    }
}


//# run 0xCAFE::InlineCaller::nested_inline_call --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 1d057386bcda39af1f6c64e60c26b1f8: Define unit types using empty parentheses '()'.
// 7e545afd3c602ca88da9afcee3b4c80c: Use specification blocks to organize code and annotations in Move modules.
// 90664d4b2d8c8d0427947c5eb3a9aa52: Rely on the compiler to remove inline functions with bodies from the final program, preventing code generation issues with certain constructs.
