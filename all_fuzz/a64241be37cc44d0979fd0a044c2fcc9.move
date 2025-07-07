
//# publish
module 0xCAFE::LambdaAndAbort {
    // Removed unused std::signer import and 0xCAFE::MyModule usage as per guideline

    // 1: Test addition of two u8 values and returns specific value
    public fun add_then_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        // discard sum, return fixed 42u8
        42u8
    }

    // 2: Write functions containing lambda expressions
    public fun lambda_example(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add(x, y)
    }

    // 3: Replace call to MyModule::f2 with a local inline function f2
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    public fun call_inline_f2(x: u16): (u16, u16) {
        // call local inline f2 function
        let (a, b) = f2(x);
        (a, b)
    }

    // 4: Mark a function to hint optimizer and flush resource writes efficiently
    // Here we use the 'inline' keyword to mark for possible optimization
    public inline fun optimized_resource_operation(s: signer, v: u8) {
        let obj = Obj { x: v, y: v };
        move_to<Obj>(&s, obj);
    }

    struct Obj has key, store {
        x: u8,
        y: u8
    }

    // 5: Abort execution using abort keyword followed by an expression
    public fun abort_if_zero(x: u8) {
        if (x == 0) {
            abort 1234u64;
        };
    }

    // 6: Using decimal integer literals with underscores for clarity and correctness
    public fun sum_large_literals(): u64 {
        let a: u64 = 1_000_000u64;
        let b: u64 = 2_000_000u64;
        a + b
    }
}



//# run 0xCAFE::LambdaAndAbort::add_then_return_fixed --args 10u8 15u8



//# run 0xCAFE::LambdaAndAbort::lambda_example --args 6u8 7u8



//# run 0xCAFE::LambdaAndAbort::call_inline_f2 --args 100u16



//# run 0xCAFE::LambdaAndAbort::optimized_resource_operation --signers 0xBEEF --args 55u8



//# run 0xCAFE::LambdaAndAbort::abort_if_zero --args 0u8



//# run 0xCAFE::LambdaAndAbort::abort_if_zero --args 5u8



//# run 0xCAFE::LambdaAndAbort::sum_large_literals
