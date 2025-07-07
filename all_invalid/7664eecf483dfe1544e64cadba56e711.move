
//# publish
module 0xBADD::TestModule {
    // Inline function to increment a u64 value
    public fun inc(value: u64): u64 {
        value + 1
    }

    // Function to test incremental logic
    public fun test(initial: u64): u64 {
        let first_inc = inc(initial);
        let second_inc = inc(first_inc);
        initial + first_inc + second_inc
    }

    // Function that makes use of nested module via access chain
    public fun nested_ref(initial: u64): u64 acquires 0xCAFE::MyModule::S {
        // Reference nested deep in the module hierarchy
        let s_ref: &0xCAFE::MyModule::S = borrow_global<0xCAFE::MyModule::S>(0xCAFE);
        // Return combined value for testing
        s_ref.x as u64 + initial
    }

    // Bind variables to expressions, with optional type annotation
    public fun bind_vars_and_test(x_input: u64): u64 {
        // Create bind variables to different expressions
        let _ = Bind::<u64>::new(x_input + 5);
        // Binding to a complex expression
        let y = Bind::<u64>::new(inc(x_input));
        // Binding to a simple literal
        let z = Bind::<u64>::new(42);
        // Compose result
        x_input + y.value + z.value
    }
}


//# run 0xBADD::TestModule::test --args 10u64


//# run 0xBADD::TestModule::nested_ref --args 15u64


//# run 0xBADD::TestModule::bind_vars_and_test --args 20u64


// Featurres:
// 18a0a3ccca635e19e8dceadd6be8dd5c: Test that the inline function `inc` correctly increments a u64 value and that the `test` function accurately sums the initial value with two increments of that value.
// 531270db1412b409e3b2e734b6fa50cf: Reference modules via module access chains, allowing composition of nested module paths.
// afce6dde9812b907927aaec064498535: Bind variables to expressions with optional type annotations using `Bind`.
