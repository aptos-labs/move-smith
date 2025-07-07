
//# publish
module 0xCAFE::AddLambda {
    // This module tests addition of two u8 values and lambdas

    public fun add_two(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 200) {
            200u8
        } else {
            sum
        }
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            let s = a + b;
            s
        };
        lambda(x, y)
    }

    public fun call_lambda_from_lambda(x: u8, y: u8): u8 {
        let inner_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        // fixed the outer_lambda type annotation to avoid ',' inside function-type parameters
        // using type alias to clarify the function type might help but is unnecessary here,
        // simply remove the type annotation or simplify it.
        let outer_lambda = |t: (u8, u8), f: |u8, u8|u8| {
            let (a, b) = t;
            f(a, b)
        };
        outer_lambda((x, y), inner_lambda)
    }
}



//# run 0xCAFE::AddLambda::add_two --args 120u8 130u8



//# run 0xCAFE::AddLambda::apply_lambda --args 40u8 50u8



//# run 0xCAFE::AddLambda::call_lambda_from_lambda --args 10u8 20u8



//# publish
module 0xCAFE::InlineCallAndRefs {

    struct RefExample has store {
        x: u32,
        y: u32,
    }

    // Since 0xCAFE::MyModule does not exist, define a dummy f2 function here
    // that matches the expected signature and returns a tuple.

    public fun f2(x: u16): (u16, u16) {
        // For testing purposes, return (x, x+1)
        (x, x + 1)
    }

    public fun create_and_borrow(x: u16): (u32, u32) {
        let (a, b) = f2(x);
        let obj = RefExample { x: (a as u32), y: (b as u32) };

        let ref_obj: &RefExample = &obj;
        let x_ref: &u32 = &(ref_obj.x);
        let y_ref: &u32 = &(ref_obj.y);

        (*x_ref, *y_ref)
    }

    public fun create_and_mutate(x: u16): (u32, u32) {
        let (a, b) = f2(x);
        let mut_obj = RefExample { x: (a as u32), y: (b as u32) };

        let mut_ref: &mut RefExample = &mut mut_obj;
        mut_ref.x = mut_ref.x * 2;
        mut_ref.y = mut_ref.y * 3;

        (mut_ref.x, mut_ref.y)
    }
}



//# run 0xCAFE::InlineCallAndRefs::create_and_borrow --args 100u16



//# run 0xCAFE::InlineCallAndRefs::create_and_mutate --args 50u16
