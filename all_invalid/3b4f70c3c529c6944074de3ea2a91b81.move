//# publish
module 0xCAFE::Module0 {
    use std::signer;

    /// A struct with copy and drop to allow copy semantics.
    struct Data has copy, drop, store {
        a: u64,
        b: u64,
        c: u64,
    }

    public fun sum_three(a: u64, b: u64, c: u64): u64 {
        a + b + c
    }

    /// Entry function to test sum_three, with three locals.
    public fun main(): u64 {
        let x = 10u64;
        let y = 20u64;
        let z = 30u64;
        let s = sum_three(x, y, z);
        s
    }
}
//# run 0xCAFE::Module0::main


//# publish
module 0xCAFE::RefMutTest {
    /// Test mutation and order of evaluation of &mut references and block expr.

    public fun mutate_and_sum(x: &mut u64, y: &mut u64, z: &mut u64): u64 {
        // Increment x by 1, y by 2, z by 3, then sum all.
        *x = *x + 1;
        *y = *y + 2;

        // Use block expression that mutates z and returns its updated value.
        let z_val = {
            *z = *z + 3;
            *z
        };

        // Sum all values after mutation.
        *x + *y + z_val
    }

    /// Runner function to demonstrate mutation and ordering.
    public fun main(): u64 {
        let mut x = 1u64;
        let mut y = 2u64;
        let mut z = 3u64;

        // mutate_and_sum(&mut x, &mut y, &mut z) = (x+1) + (y+2) + (z+3)
        // which equals (1+1) + (2+2) + (3+3) = 2 + 4 + 6 = 12
        mutate_and_sum(&mut x, &mut y, &mut z)
    }
}
//# run 0xCAFE::RefMutTest::main


//# publish
module 0xCAFE::InlineTest {
    /// Nested inline functions.

    /// Inline function that adds two numbers.
    public inline fun add_two(x: u64, y: u64): u64 {
        x + y
    }

    /// Inline function that multiplies two numbers.
    public inline fun mul_two(x: u64, y: u64): u64 {
        x * y
    }

    /// Inline function that nests add_two and mul_two calls.
    public inline fun add_mul_add(a: u64, b: u64, c: u64, d: u64): u64 {
        // Computes (a + b) * (c + d)
        mul_two(add_two(a, b), add_two(c, d))
    }

    /// Runner that calls nested inline functions and returns the result.
    public fun main(): u64 {
        // (2+3)*(4+1) = 5 * 5 = 25
        add_mul_add(2, 3, 4, 1)
    }
}
//# run 0xCAFE::InlineTest::main


//# run
script {
    use 0xCAFE::Module0;
    use 0xCAFE::RefMutTest;
    use 0xCAFE::InlineTest;

    fun main() {
        let res0 = Module0::main();
        // res0 should be 10+20+30 = 60

        let res1 = RefMutTest::main();
        // res1 should be 12 due to mutation and sum

        let res2 = InlineTest::main();
        // res2 should be 25 due to nested inline calls

        // No assertions needed per instruction. Just let execution happen.
    }
}

// Featurres:
// 3774a4fbdff54caa4f56e7e2a018e57b: Test that the module correctly computes the sum of three local variables and the assertion passes when calling main.
// 118a30f282208cbd9dfc2ac3ca907871: Test the correct order of evaluation and mutation for &mut references and block expressions in function calls and expressions.
// 38e37684cc05893eff842609257c711e: Test that two inlined function calls can be nested and optimized correctly when invoked from another inline function.
