//# publish
module 0xCAFE::TestModule {
    // Test feature 1: function parameters and explicit return types
    // Test feature 2: mutation via assignment, move, and mutable borrow
    // Test feature 3: test inline function with nested shadowing lambdas

    use std::vector;

    // A struct to help test mutation and move semantics
    struct Container has copy, drop, store {
        val: u64,
    }

    public fun add_u64(a: u64, b: u64): u64 {
        a + b
    }

    public fun mutate_var_assignment(): u64 {
        let mut x: u8 = 10;
        x = 20; // mutate by assignment
        (x as u64) // return
    }

    public fun mutate_var_move(): u8 {
        let x: u8 = 100;
        let y = x; // move copy because u8 is copy
        y
    }

    public fun mutate_var_borrow(): u64 {
        // borrowing in Move is done by reference, simulate mutation via container struct
        let mut c = Container { val: 5 };
        let r = &mut c;
        r.val = 123;
        c.val
    }

    // inline function quux with nested lambdas and shadowed variable names
    //
    // Rules:
    // - quux is `public inline fun`
    // - uses nested lambdas with shadowed variable names
    //
    // On calling quux(x):
    //   It computes ((((x + 1) * 2) - 3) + 4) == expected result
    //
    // Details:
    // lambda1 shadows variable x, adds 1
    // lambda2 shadows variable x, multiplies by 2
    // lambda3 shadows variable x, subtracts 3
    // outer expression adds 4

    public inline fun quux(x: u64): u64 {
        // lambda1: (x) -> x + 1
        fun lambda1(x: u64): u64 {
            x + 1
        }
        // lambda2: (x) -> x * 2
        fun lambda2(x: u64): u64 {
            x * 2
        }
        // lambda3: (x) -> x - 3
        fun lambda3(x: u64): u64 {
            x - 3
        }
        let x = lambda1(x);
        let x = lambda2(x);
        let x = lambda3(x);
        x + 4
    }

    public fun test_shadowing(): u64 {
        quux(10)
    }
}
//# run 0xCAFE::TestModule::mutate_var_assignment
//# run 0xCAFE::TestModule::mutate_var_move
//# run 0xCAFE::TestModule::mutate_var_borrow
//# run 0xCAFE::TestModule::test_shadowing

// Featurres:
// dd9e07f90e31992b3dbccf1579768cad: Declare function parameters and return types with proper syntax in function signatures.
// 5857892d922f0a971e9fae8e65751c3e: Mutate variables via expressions such as assignment, Move, or mutable Borrow, and have these operations treated as modifications by the compiler.
// 403a96dd507b1786415b9a6297174731: Test that the `quux` inline function correctly uses nested lambdas with shadowed variable names and produces the expected result when called from `test_shadowing`.
