//# publish
module 0xCAFE::ClosureShadowing {

    // This module tests variable shadowing and mutation within closures passed as arguments

    public fun call_with_closure(mut_var: &mut u8, f: &fun(u8): u8) {
        let inner_mut_var = *mut_var;
        // call closure f which is expected to shadow and mutate mut_var
        let shadowed = f(inner_mut_var);
        // assign shadowed value back to mut_var
        *mut_var = shadowed;
    }

    public fun test_shadowing_and_mutation(): u8 {
        let x = 10u8;
        let mut_x = x;
        let mut_x_ref = &mut (copy mut_x);
        // Define a closure that shadows the outer x and mut_x_ref and mutates via argument
        let closure = fun(x: u8): u8 {
            let x = x + 5u8; // shadow parameter x
            x
        };
        call_with_closure(mut_x_ref, &closure);
        *mut_x_ref
    }

}
