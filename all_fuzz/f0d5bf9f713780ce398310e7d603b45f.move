
//# publish
module 0xCAFE::CalcModule {
    /// Adds two u8 numbers and returns their sum.
    public fun add_two_numbers(x: u8, y: u8): u8 {
        let z = x + y;
        z
    }

    /// Returns a lambda that multiplies a u8 by 2.
    public fun get_double_lambda(): |u8|u8 {
        let f = |a: u8| {
            a + a
        };
        f
    }

    /// Runs a given lambda |u8|u8 on input and returns the result.
    public fun run_lambda(f: |u8|u8, input: u8): u8 {
        f(input)
    }

    /// Runner function that tests add_two_numbers and lambda functionality.
    public fun runner(): u8 {
        let sum = add_two_numbers(10u8, 20u8);

        let double_lambda = get_double_lambda();
        let doubled_value = run_lambda(double_lambda, sum);

        doubled_value
    }
}



//# run 0xCAFE::CalcModule::add_two_numbers --args 15u8 25u8



//# run 0xCAFE::CalcModule::runner



//# publish
module 0xCAFE::MyModule {
    /// Inline function f2 returns a tuple of two u16 values derived from input.
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;
    use 0xCAFE::MyModule;

    /// Calls the inline function f2 from MyModule again but through a wrapped call.
    /// Then adds x to the sum of the tuple returned.
    public fun call_inline_and_add(x: u16): u16 {
        let (a, b) = MyModule::f2(x);
        (a + b) + x
    }

    /// Nested call that calls CalcModule::runner and adds 5 to its result.
    public fun nested_calls(): u8 {
        let val = CalcModule::runner();
        val + 5u8
    }
}



//# run 0xCAFE::CallerModule::call_inline_and_add --args 10u16



//# run 0xCAFE::CallerModule::nested_calls
