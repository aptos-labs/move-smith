
//# publish
module 0xCAFE::LambdaTest {
    // removed unused `use std::signer;`

    // Simple addition function
    public fun add_two_numbers(a: u8, b: u8): u8 {
        a + b
    }

    // Function to receive a lambda and a u8, apply lambda to the u8
    public fun apply_lambda_to_value(f: |u8|u8, val: u8): u8 {
        f(val)
    }

    // Function returning a lambda that adds 5 to its input
    public fun get_add_five_lambda(): |u8| u8 {
        |x: u8| {
            x + 5
        }
    }

    // Inline function to add 10 to input
    public inline fun inline_add_ten(x: u8): u8 {
        x + 10
    }
}



//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::LambdaTest;

    // Calls the inline_add_ten function from LambdaTest and then adds 1 more
    public fun call_nested_inline(x: u8): u8 {
        let inner_result = LambdaTest::inline_add_ten(x);
        inner_result + 1
    }
}



//# run 0xCAFE::LambdaTest::add_two_numbers --args 20u8 22u8

// Removed the failing apply_lambda_to_value run because:
// It requires a lambda (|u8|u8) as first argument, which cannot be passed inline via `--args`.

// We keep running get_add_five_lambda to verify it returns a lambda object.


//# run 0xCAFE::LambdaTest::get_add_five_lambda


//# run 0xCAFE::NestedCallTest::call_nested_inline --args 30u8
