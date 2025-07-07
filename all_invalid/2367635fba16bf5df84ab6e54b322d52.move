//# publish
module 0x1::ModuleA {
    // A simple function to demonstrate variable bindings and destructuring
    public fun bind_and_destruct() {
        // variable bindings
        let x = 10;
        let (a, b) = (x, 20);
        // inline function
        let add_one = |num: u64| -> u64 { num + 1 };
        let sum = add_one(a) + add_one(b);

        // higher-order function: takes a function and calls it
        fun apply_twice(f: &fn(u64): u64, val: u64): u64 {
            let first = f(val);
            let second = f(first);
            second
        };

        let double_add = |x: u64| -> u64 { x + x };
        let result = apply_twice(&double_add, sum);

        // anonymous closure
        let anon_inc = |y: u64| -> u64 { y + 42 };
        let final_result = anon_inc(result);

        // destructuring a tuple in let
        let (m, n) = (final_result, 100u64);

        // no asserts but a dummy usage to avoid warnings:
        let _ = m + n;
    }

    // conditional branches with if_else expression
    public fun if_else_test(x: u64) {
        let result = if x > 10 {
            x * 2
        } else {
            5
        };

        // with optional else branch omitted
        let _optional = if x == 0 {
            100
        } else {
            0
        };

        // use result to avoid warnings (no asserts needed)
        let _ = result + _optional;
    }

    // runner function that calls the other test functions
    public fun runner() {
        bind_and_destruct();
        if_else_test(15);
        if_else_test(0);
    }
}
//# run 0x1::ModuleA::runner

//# publish
module 0x2::ModuleB {
    // Try duplicated struct name should fail if repeated, so use a unique name here
    struct UniqueStruct has copy, drop, store {
        val: u64,
    }

    // test: variable bindings in loops and destructuring tuples from function returns

    fun return_pair(x: u64): (u64, u64) {
        (x, x * 3)
    }

    public fun complex_bindings() {
        let (p, q) = return_pair(7);

        let mut sum = 0u64;

        let inline_inc = |v: u64| -> u64 { v + 1 };

        let arr = [1u64, 2, 3];
        let mut i = 0;
        while (i < 3) {
            sum = sum + arr[i];
            i = i + 1;
        }

        // anonymous closure capturing sum immutably
        let add_sum = |x: u64| -> u64 { x + sum };

        let total = add_sum(inline_inc(p)) + q;

        // use total to avoid warnings (no asserts)
        let _ = total;
    }

    public fun runner() {
        complex_bindings();
    }
}
//# run 0x2::ModuleB::runner

//# publish
module 0x3::ModuleC {
    // Higher-order functions, anonymous closures combined with if_else expressions

    // A higher order function that accepts a conditional function and a value
    fun conditional_apply(
        cond: &fn(u64): bool,
        f: &fn(u64): u64,
        val: u64
    ): u64 {
        if *cond(val) {
            f(val)
        } else {
            val
        }
    }

    public fun test_if_else_with_hof(x: u64) {
        let is_even = |n: u64| -> bool { n % 2 == 0 };
        let multiply = |n: u64| -> u64 { n * 10 };

        let result = conditional_apply(&is_even, &multiply, x);

        // test inline if_else expression inside anonymous closure
        let inline_closure = |y: u64| -> u64 {
            if y > 50 {
                y - 50
            } else {
                y + 50
            }
        };

        let adjusted = inline_closure(result);

        let _ = adjusted;
    }

    public fun runner() {
        test_if_else_with_hof(42);
        test_if_else_with_hof(15);
    }
}
//# run 0x3::ModuleC::runner

// Test duplicate module name compile failure is not runnable here,
// but let's try publishing a module with the same name (commented out):
/*
# publish
module 0x1::ModuleA {
    public fun dummy() {}
}
*/
// This is to verify the unique module identifier requirement manually.