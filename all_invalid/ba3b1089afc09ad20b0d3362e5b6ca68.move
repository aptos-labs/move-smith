//# publish
module 0xCAFE::ClosureShadowing {

    /// Generic function to call a function pointer `f` on a mutable reference to u8.
    /// F must be a function pointer type: fun(u8): u8
    public fun call_with_closure_<F: copy + drop + store>(mut_var: &mut u8, f: F) {
        let inner_mut_var = *mut_var;
        let shadowed = f(inner_mut_var);
        *mut_var = shadowed;
    }

    public fun test_shadowing_and_mutation(): u8 {
        let mut_x = 10u8;
        let mut_x_ref = &mut mut_x;
        // Define a closure as an anonymous function (function pointer)
        let closure = fun(x: u8): u8 {
            let x = x + 5u8; // shadow parameter x
            x
        };
        call_with_closure_<typeof(closure)>(mut_x_ref, closure);
        *mut_x_ref
    }
}
