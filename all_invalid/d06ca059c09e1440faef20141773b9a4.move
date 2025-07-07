//# publish
module 0xCAFE::Module0 {
    /// A function that takes a function value (lambda) as an argument and calls it with 10.
    public inline fun apply_func(f: &dyn Fn(u64): u64): u64 {
        f(10)
    }

    /// Inline function that doubles the input.
    public inline fun double(x: u64): u64 {
        x * 2
    }

    /// A function that calls the inline function `double`.
    public fun call_double(x: u64): u64 {
        double(x)
    }

    /// Runner function to test binding `b` in a for loop and calling inline functions.
    public fun runner(): u64 {
        // Test 1: Bind each variable `b` in the range list.
        let mut sum = 0u64;
        let mut b = 0u64; // ensure b declared ahead (just demo, though it's shadowed below)
        let range = 1..=3;
        // For each b in range, add b.
        // The `b` here is a newly bound variable.
        for b in range {
            sum = sum + b;
        }

        // Test 2: Use inline function with function value argument.
        // Here we pass a closure that adds 5 to input.
        let add_5 = |x: u64| -> u64 { x + 5 };
        let applied = apply_func(&add_5);

        // Test 3: Call inline functions within other functions.
        // call_double calls inline double
        let doubled = call_double(4);

        // Return sum + applied + doubled
        sum + applied + doubled
    }
}
//# run 0xCAFE::Module0::runner

// Featurres:
// c6ba468d221603c510f04f345e506ccf: Bind each variable 'b' in the range list as an unbound name, establishing its declaration.
// ce0b87fbc06882d26f1bfd9a5b30df50: Test that an inline function can accept a function value (lambda/closure) as an argument and invoke it correctly.
// f014b399e4686074b1fe7647b8e38e9b: Call inline functions within other functions to have them expanded at call sites.
