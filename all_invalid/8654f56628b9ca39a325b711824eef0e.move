
//# publish
module 0xCAFE::ClosureShadowing {

    // This module tests variable shadowing and mutation within closures passed as arguments

    // Change the type of f to &fun(u8): u8 from &fun(u8): u8 which is invalid
    // Use the correct type for a function pointer: &fun(u8): u8 is incorrect syntax,
    // instead use &fun(u8): u8 -> &fun(u8): u8 is invalid, use &fun(u8): u8 is invalid.
    // The correct syntax for a function pointer in Move is &fun(u8): u8 or &fun(u8): u8? Actually in Move,
    // function types are written as fun(u8): u8 (without &), but references to functions are `&fun(u8): u8`.

    // However, Move doesn't currently support passing functions as values in this manner.
    // Instead, you declare inline anonymous functions, or use generics, or use entry functions.

    // So a typical workaround is to pass the closure as a generic fun parameter.

    // We'll update call_with_closure to be generic over a fun:

    public fun call_with_closure<F: copy>(mut_var: &mut u8, f: F): u8
        // F must be a function pointer taking u8 and returning u8
    {
        let inner_mut_var = *mut_var;
        // call closure f which is expected to shadow and mutate mut_var
        let shadowed = f(inner_mut_var);
        // assign shadowed value back to mut_var
        *mut_var = shadowed;
        shadowed
    }

    // Correct the closure declaration to create a function pointer with `fun(u8): u8` type
    // In Aptos Move, anonymous functions with `fun` keyword are allowed inside some contexts,
    // but the generic parameter must be bound to fun(u8): u8

    // So let's add the proper constraint on F

    // So update call_with_closure to:

    public fun call_with_closure_<F: copy + fun(u8): u8>(mut_var: &mut u8, f: F) {
        let inner_mut_var = *mut_var;
        let shadowed = f(inner_mut_var);
        *mut_var = shadowed;
    }

    public fun test_shadowing_and_mutation(): u8 {
        let mut_x = 10u8;
        let mut_x_ref = &mut mut_x;
        // Define a closure that shadows the outer x and mut_x_ref and mutates via argument
        let closure = fun(x: u8): u8 {
            let x = x + 5u8; // shadow parameter x
            x
        };
        call_with_closure_<fun(u8): u8>(mut_x_ref, closure);
        *mut_x_ref
    }
}
