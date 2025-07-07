
//# publish
module 0xCAFE::CalcAdd {
    public fun add_u8_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = add_lambda(a, b);
        result
    }

    public fun inline_caller(a: u16): u16 {
        // Calls a nested inline function to get tuple and returns sum of elements
        let (x, y) = Self::inline_function(a);
        x + y
    }

    public inline fun inline_function(a: u16): (u16, u16) {
        (a + 3, a + 4)
    }

    public fun pure_function_use(a: u8): u8 {
        // calling only non-move function guaranteed no side effect.
        Self::pure_increment(a)
    }

    public fun pure_increment(a: u8): u8 {
        a + 1
    }
}


//# run 0xCAFE::CalcAdd::add_u8_and_return_sum --args 12u8 15u8


//# run 0xCAFE::CalcAdd::with_lambda --args 20u8 22u8


//# run 0xCAFE::CalcAdd::inline_caller --args 100u16


//# run 0xCAFE::CalcAdd::pure_function_use --args 99u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 26f6660ae3138fce9223bab9fdbd4006: Use function calls only with non-move functions to guarantee they are side-effect free.
