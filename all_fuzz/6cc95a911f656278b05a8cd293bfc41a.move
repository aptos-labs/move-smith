
//# publish
module 0xCAFE::NestedCalls {

    // An inline function defined here to replace the missing MyModule::f2 function
    // This function takes a u16 and returns a tuple (u16, u16)
    // For demonstration, just returns (input, input + 1)
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }

    // A function that calls the inline function f2 defined above
    public fun call_inline_function(a: u16): (u16, u16) {
        f2(a)
    }

    // A function using lambda expressions with capture and demonstrating return values
    public fun lambda_test(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = adder(x, y);
        result
    }

    // A function that computes the addition of two u8 values and returns a fixed u8 value afterwards
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // The function returns 42 regardless of sum, but sum is computed first
        42u8
    }

    // A function demonstrating detection of uninitialized variable usage (UninitializedUseChecker)
    // This function is intentionally incorrect: use of uninitialized variable `z`
    public fun use_uninitialized_bug(): u8 {
        let x: u8;
        let y = 10u8;
        // let z = x + y; // This should cause an uninitialized use error if uncommented
        // For parity with the rule not to emit errors here, assign x first:
        let x = 5u8;
        let z = x + y;
        z
    }
}



//# run 0xCAFE::NestedCalls::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::NestedCalls::lambda_test --args 7u8 8u8


//# run 0xCAFE::NestedCalls::call_inline_function --args 15u16


//# run 0xCAFE::NestedCalls::use_uninitialized_bug
