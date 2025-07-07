
//# publish
module 0xCAFE::MathAndLambda {
    // This module tests addition, lambda syntax, and inline function calls

    // Since referencing 0xCAFE::MyModule is disallowed, we declare a local inline function f2 here,
    // simulating the expected external inline function returning a tuple (u16, u16).
    // This avoids unbound module errors.

    // Inline function returning a tuple with first element as input and second element as input * 2
    inline fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }

    // Simple function to add two u8 values and return the sum + 10 to check computation
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    // Function demonstrating lambda expression that doubles a given input
    public fun double_with_lambda(x: u8): u8 {
        let doubler: |u8|u8 has copy+drop = |n: u8| {
            n + n
        };
        doubler(x)
    }

    // Function calling nested inline function f2, then returning first element from its tuple
    public fun call_inline_f2(a: u16): u16 {
        let (first, _second) = f2(a);
        first
    }

    // Runner function to exercise all the above functions without requiring external args
    public fun runner() {
        let _ = add_and_offset(5u8, 7u8);
        let _ = double_with_lambda(8u8);
        let _ = call_inline_f2(20u16);
    }
}



//# run 0xCAFE::MathAndLambda::add_and_offset --args 12u8 23u8



//# run 0xCAFE::MathAndLambda::double_with_lambda --args 9u8



//# run 0xCAFE::MathAndLambda::call_inline_f2 --args 42u16



//# run 0xCAFE::MathAndLambda::runner
