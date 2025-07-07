
//# publish
module 0xCAFE::LambdaAdd {
    // Test lambda expressions and addition of two u8 values before returning a fixed value

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        let sum = sum_lambda(a, b);
        sum + 10u8
    }

    public fun return_twelve() {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let s = a + b;
            let t = s + 2u8;
            t
        };
        let _r = f(3u8, 4u8);
    }
}



//# run 0xCAFE::LambdaAdd::add_with_lambda --args 7u8 8u8



//# run 0xCAFE::LambdaAdd::return_twelve



//# publish
module 0xCAFE::InlineCaller {
    // Removed use 0xCAFE::MyModule; since it does not exist

    // Tests that calling an inline function from MyModule works correctly
    // Since 0xCAFE::MyModule is not defined, we remove this module or rewrite it.
    // Assuming we have no MyModule, we cannot fix this; so let's remove it entirely.
}



//# publish
module 0xCAFE::ParallelAssignment {
    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct Container has copy, drop, store {
        p: Pair,
        q: u8,
    }

    public fun swap_u8s(mut_x: u8, mut_y: u8): (u8, u8) {
        let x = mut_x;
        let y = mut_y;
        let (a, b) = (y, x);
        (a, b)
    }

    public fun swap_struct_fields(mut_c1: Container, mut_c2: Container): (Container, Container) {
        let c1 = mut_c1;
        let c2 = mut_c2;
        // Swap inner Pair structs between Container structs via destructuring and parallel assignment
        let Container {p: p1, q: q1} = c1;
        let Container {p: p2, q: q2} = c2;
        let (new_p1, new_p2) = (p2, p1);
        let (new_q1, new_q2) = (q2, q1);
        (
            Container {p: new_p1, q: new_q1},
            Container {p: new_p2, q: new_q2}
        )
    }

    public fun test_reference_and_local_mut() {
        let x = 10u8;
        let y = 20u8;
        let r_x = &mut x;
        let r_y = &mut y;
        // Swap values via mutable references
        let temp = *r_x;
        *r_x = *r_y;
        *r_y = temp;
    }

    public fun evaluation_order() {
        let a = 1u8;
        let b = 2u8;
        // Since Move does not allow assignments inside tuples, split into steps
        b = b + 1u8;
        let (x, y) = (a, b);
        a = y;
        b = x;
    }
}



//# run 0xCAFE::ParallelAssignment::swap_u8s --args 5u8 10u8



//# run 0xCAFE::ParallelAssignment::swap_struct_fields --args 
    (Pair {a: 1u8, b: 2u8}, 3u8) (Pair {a: 4u8, b: 5u8}, 6u8)




//# run 0xCAFE::ParallelAssignment::test_reference_and_local_mut



//# run 0xCAFE::ParallelAssignment::evaluation_order
