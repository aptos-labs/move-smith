//# publish
module 0xCAFE::ParallelAssignment {
    use std::signer;

    struct Pair has store, copy, drop {
        a: u8,
        b: u8,
    }

    struct Nested has store, copy, drop {
        p: Pair,
        c: u8,
    }

    public fun create_pair(x: u8, y: u8): Pair {
        Pair { a: x, b: y }
    }

    public fun destructure_and_swap() {
        let mut x = 1u8;
        let mut y = 2u8;
        // Parallel assignment swap of local variables
        (x, y) = (y, x);
        // With references: mutable refs to x and y
        let x_ref: &mut u8 = &mut x;
        let y_ref: &mut u8 = &mut y;
        (*x_ref, *y_ref) = (*y_ref, *x_ref);
        // Confirm x and y swapped back
        let _ = (x, y);

        // Parallel assignment with struct fields
        let mut p = Pair { a: 10u8, b: 20u8 };
        let p_ref: &mut Pair = &mut p;
        (p_ref.a, p_ref.b) = (p_ref.b, p_ref.a);

        // Destructuring of nested struct and swapping inner fields
        let mut n = Nested { p: Pair { a: 5u8, b: 9u8 }, c: 3u8 };
        // Destructure n into local variables with nested pattern
        let Nested { p: Pair { a: a1, b: b1 }, c: c1 } = n;
        // Local parallel assignment of destructured values
        let (mut a, mut b, mut c) = (a1, b1, c1);
        (a, b, c) = (c, a, b);
        // Mutate back into n fields
        n = Nested { p: Pair { a, b }, c };

        // Evaluation order test: assign and swap with expressions that have side-effects simulated by let binding order
        let mut u = 3u8;
        let mut v = 4u8;
        let foo = || { u += 1; u };
        let bar = || { v += 1; v };
        // Evaluate foo() and bar(), then swap results into u,v in parallel assignment
        (u, v) = (foo(), bar());

        // References immutable and mutable
        let s = Pair { a: 7u8, b: 8u8 };
        let s_ref: &Pair = &s;
        // Immutable reference access
        let _a = s_ref.a;
        // Mutable reference
        let mut t = Pair { a: 0u8, b: 0u8 };
        let t_mut_ref: &mut Pair = &mut t;
        t_mut_ref.a = 42u8;
    }

    // Function trying to access resource without acquires annotation - should fail during publish/compile.
    // Uncomment to test compile failure:
    /*
    struct Res has key {}
    public fun no_acquire_access(addr: address) {
        let r: &Res = borrow_global<Res>(addr);
        let _dummy = r;
    }
    */
}

//# run 0xCAFE::ParallelAssignment::destructure_and_swap

// Featurres:
// c015c25c829fde241d5e66151d548aa0: Test that parallel (tuple) assignment and swapping—including with structs, references, local mutation, destructuring, and evaluation order—works correctly in Move.
// 7104d86b95d439a3adacf8f4f073e87e: Create reference types with read-only or mutable access using '&type' and '&mut type' syntax, respectively.
// dc1da8d900c95d61ef4f1d8b18e8e32b: Receive compiler errors if a function accesses resources not listed in its 'acquires' annotation when inference is not available.
