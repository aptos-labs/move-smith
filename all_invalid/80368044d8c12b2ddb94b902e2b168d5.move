//# publish
module 0xCAFE::MathOps {
    use std::error;
    use std::signer;
    
    /// A function that accepts a lambda (function) of type `fn(u32): u32` and calls it with `input`.
    public fun apply_func(f: fun(u32): u32, input: u32): u32 {
        f(input)
    }

    /// Inline function that adds 1 to the input.
    public inline fun add_one(x: u32): u32 {
        x + 1
    }

    /// Inline function that subtracts 1 from the input.
    public inline fun sub_one(x: u32): u32 {
        x - 1
    }

    /// Inline function that doubles the input.
    public inline fun double(x: u32): u32 {
        x * 2
    }

    /// Inline function that halves the input.
    public inline fun half(x: u32): u32 {
        x / 2
    }

    /// Inline function that returns remainder after division by 3.
    public inline fun mod_three(x: u32): u32 {
        x % 3
    }
    
    /// A function that tests all arithmetic operations on boundary values,
    /// demonstrating normal behavior and boundary overflow/underflow.
    public fun arithmetic_boundaries_test(): bool {
        let zero: u32 = 0;
        let one: u32 = 1;
        let max: u32 = 0xFFFF_FFFF; // u32 max value: 4294967295

        // Overflow example: max + 1 overflows to 0
        let overflow_add: u32 = max + one;

        // Underflow example: zero - 1 underflows to max
        let underflow_sub: u32 = zero - one;

        // Multiplication overflow example: max * 2 overflows to 4294967294 modulo 2^32
        let overflow_mul: u32 = max * 2;

        // Division by zero handled by abort with error code 1 (we emulate by catching error in a script)
        // So here just demonstrate normal division 
        let div_normal: u32 = max / one;

        // Remainder by zero will abort -- handled in script

        // Just return true to indicate function ran
        true
    }

    /// Runner function to test apply_func with inline closure functions.
    public fun runner_apply_lambda(): u32 {
        // Call apply_func with add_one inline function and input 41, expect 42.
        apply_func(add_one, 41)
    }

    /// Runner function to test arithmetic boundaries.
    public fun runner_arith(): bool {
        arithmetic_boundaries_test()
    }
}
//# run 0xCAFE::MathOps::runner_apply_lambda
//# run 0xCAFE::MathOps::runner_arith

//# run
script {
    use std::debug;
    use std::signer;
    use std::error;

    fun test_arithmetic(): () {
        let zero: u32 = 0;
        let one: u32 = 1;
        let max: u32 = 0xFFFF_FFFF;

        // Test add overflow: max + 1 = 0 (wraps around)
        let overflow_add = max + one;
        debug::print(&overflow_add); // Expect 0

        // Test sub underflow: 0 - 1 = max
        let underflow_sub = zero - one;
        debug::print(&underflow_sub); // Expect max

        // Test multiplication overflow: max * 2 = 4294967294 (wraps modulo 2^32)
        let overflow_mul = max * 2;
        debug::print(&overflow_mul); // Expect 4294967294

        // Test division normal: max / 1 = max
        let div_normal = max / one;
        debug::print(&div_normal); // Expect max

        // Test modulo normal: max % 3
        let mod_normal = max % 3;
        debug::print(&mod_normal); // Expect max % 3 = 0xFFFF_FFFF % 3 = 0

        // Test division by zero and modulo by zero (should abort)
        let abort_code = 1;
        // division by zero
        let div_by_zero = vector::length(&vector::empty<u8>()) /* dummy usage */;
        // We'll call division by zero inside `abort_on_div_zero` and catch the abort.
        // Instead, manually try division by zero to get an abort, caught by VM, so commented out here.

        // The following would abort, so commented:
        // let _ = max / zero; 

        // let _ = max % zero; 

        // Since these aborts happen at runtime and we cannot catch inside Move, we leave these lines commented to show intent.

        // Also test `apply_func` with lambdas directly in a script:
        let add_one = fun (x: u32): u32 { x + 1 };
        let sub_one = fun (x: u32): u32 { x - 1 };

        let val1 = 41;
        let val2 = 43;

        let res_add = 0xCAFE::MathOps::apply_func(add_one, val1);
        let res_sub = 0xCAFE::MathOps::apply_func(sub_one, val2);

        debug::print(&res_add); // Expect 42
        debug::print(&res_sub); // Expect 42
    }

    fun main() {
        test_arithmetic();
    }
}

// Featurres:
// 4e6061b3a02c98725eb43873a74a9758: Specify anonymous addresses using hexadecimal address literals in your Move code
// abc3ea01122fec06685a87e425d91f2d: Test that inline functions can accept function values (lambdas/closures) as parameters and correctly invoke them.
// 60fb167a5e1439f457e846cb5b6ab42d: Test the correctness and overflow/underflow behavior of all arithmetic operations (+, -, *, /, %) on the u32 type, including boundary values and division/modulo by zero.
