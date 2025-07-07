//# publish
module 0xCAFE::ShadowTest {
    use std::debug;

    // This function uses bindings as locals and module access expressions
    public fun run_bindings() {
        let local_var = 100u64;
        let module_var = Self::get_module_var();

        debug::print(&local_var);
        debug::print(&module_var);
    }

    // Module scoped variable
    const MODULE_VAR: u64 = 42;

    public fun get_module_var(): u64 {
        MODULE_VAR
    }

    // A function that takes a closure modifying an outer variable by shadowing and mutating it
    public fun shadow_and_mutate(mut_var: &mut u64, f: &mut (fun(&mut u64))) {
        f(mut_var);
    }

    // Public runner function that demonstrates closure capture, shadowing, and mutation
    public fun run_shadow() {
        let mut x = 5u64;
        // Closure shadows outer 'x' and mutates it via reference
        Self::shadow_and_mutate(&mut x, &mut (fun (y: &mut u64) {
            let mut x = *y;
            x = x + 10;
            *y = x;
        }));
        debug::print(&x);
    }
}


//# run 0xCAFE::ShadowTest::run_bindings


//# run 0xCAFE::ShadowTest::run_shadow


//# run
script {
    use std::debug;
    use 0xCAFE::ShadowTest;

    fun main() {
        debug::print(&"Running script main...");

        let mut outer = 10u64;

        // Closure that shadows `outer` and mutates the variable from outer scope captured by reference
        let mut add_to_outer = fun (f: &mut (fun(&mut u64))) {
            let mut outer = outer;
            // This shadows the outer variable but also calls passed closure to mutate outer
            f(&mut outer);
            debug::print(&outer);
        };

        add_to_outer(&mut fun(y: &mut u64) {
            *y = *y + 20;
        });

        // Call module functions to show bindings
        ShadowTest::run_bindings();
        ShadowTest::run_shadow();

        // Output compiler diagnostics with source context
        std::debug::output_diagnostics();
    }
}

// Featurres:
// d388ee95bcc895dc7c69185d12334fd6: Bind variables as local or module access expressions depending on context and name validity.
// 7ae320749aa1a3fa69ec63bdd6cf3ca6: Test that variables from the outer scope can be shadowed and mutated by closures passed to functions, verifying correct variable capture and assignment behavior.
// 75ee3fa84956c120f08c2d91e03731db: Call `output_diagnostics` to display compiler diagnostics with source code context.
