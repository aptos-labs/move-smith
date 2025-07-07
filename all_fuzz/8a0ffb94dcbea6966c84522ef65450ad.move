
//# publish
module 0xCAFE::AddAndLambda {
    // Removed unused 'use std::signer;' import

    // Removed use of unbound module 0xCAFE::MyModule and replaced inline_call logic with self-contained function

    // We replace MyModule::f2 with a local function f2 that returns a tuple (u16, u16)
    // so inline_call compiles and runs correctly.

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10u8;
        result
    }

    public fun lambda_example(a: u8, b: u8): (u8, u8) {
        // Removed the inline closure since tuple types are not allowed as type arguments in Move
        // Define the functionality inline instead
        let add = a + b;
        let mul = a * b;
        (add, mul)
    }

    // Replace `MyModule::f2` with a local helper function
    public fun f2(n: u16): (u16, u16) {
        // example implementation, returning (n, n+1)
        (n, n + 1)
    }

    public fun inline_call(n: u16): u32 {
        let (a, b) = f2(n);
        (a as u32) * (b as u32)
    }

    public fun runner() {
        let _ = add_two_values(5u8, 7u8);

        // unpack the tuple result from lambda_example rather than assigning to a single variable
        let (_add, _mul) = lambda_example(3u8, 4u8);

        let _ = inline_call(10u16);
    }
}




//# run 0xCAFE::AddAndLambda::runner




//# run 0xCAFE::AddAndLambda::add_two_values --args 8u8 12u8




//# run 0xCAFE::AddAndLambda::lambda_example --args 7u8 6u8




//# run 0xCAFE::AddAndLambda::inline_call --args 20u16
