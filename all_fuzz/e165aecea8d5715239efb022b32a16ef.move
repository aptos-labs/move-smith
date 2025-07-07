
//# publish
module 0xCAFE::LambdaAndSpec {
    // Removed unused use std::signer;

    // Inline function that adds two u64 numbers, returns the sum and difference
    public inline fun add_and_sub(a: u64, b: u64): (u64, u64) {
        (a + b, a - b)
    }

    // Function that takes a lambda and applies it to two u64 values
    public fun apply_lambda_to_two(a: u64, b: u64, lambda: |u64, u64| u64): u64 {
        lambda(a, b)
    }

    // Function that defines and calls an inline lambda expression returning a u64
    public fun example_lambda_call(): u64 {
        let lambda: |u64, u64| u64 has copy + drop = |x: u64, y: u64| {
            x * y
        };
        let result = lambda(3, 4);
        result
    }

    // Function to test nested calls to the inline function defined in this module
    public fun nested_inline_calls(x: u64, y: u64): u64 {
        let (sum, diff) = add_and_sub(x, y);
        sum + apply_lambda_to_two(sum, diff, |a: u64, b: u64| { a - b })
    }

    // Instead of calling 0xCAFE::MyModule::f2 and enum E which are missing,
    // we define inline replacements here to fix compilation/linker errors.

    public inline fun f2(a: u16): (u16, u16) {
        // Just a simple example: return (a, a+1)
        (a, a + 1)
    }

    public enum E { V3 { a: bool } }

    // Cross module call replaced with internal call to inline f2
    public fun cross_module_inline_call(a: u16): (u16, u16) {
        Self::f2(a)
    }

    // Public function that creates and uses a lambda taking a u8 and returning u8
    public fun call_lambda_with_u8(x: u8): u8 {
        let increment: |u8| u8 has copy+drop = |v: u8| { v + 1 };
        increment(x)
    }

    // Using public visibility on a function that returns an enum variant from MyModule replaced by internal enum
    public fun get_enum_v3(): E {
        E::V3 { a: true }
    }

    spec module {
        // Spec block that targets the entire module
        // We won't use asserts here, just a placeholder indicating presence
        // This is mainly to exercise spec block parsing
        // Without any members or functions declared inline here
    }
}



//# run 0xCAFE::LambdaAndSpec::example_lambda_call



//# run 0xCAFE::LambdaAndSpec::nested_inline_calls --args 10u64 3u64



//# run 0xCAFE::LambdaAndSpec::cross_module_inline_call --args 5u16



//# run 0xCAFE::LambdaAndSpec::call_lambda_with_u8 --args 7u8



//# run 0xCAFE::LambdaAndSpec::get_enum_v3
