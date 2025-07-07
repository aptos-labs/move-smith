
//# publish
module 0xCAFE::AddModule {
    /// A simple function that adds two u8 numbers and returns the sum + 5
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    /// Function that returns a lambda (anonymous function) which adds two u8 numbers and returns u8
    public fun get_adder_lambda(): (|u8, u8| u8) {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda
    }
}


//# run 0xCAFE::AddModule::add_and_offset --args 10u8 20u8


//# run 0xCAFE::AddModule::get_adder_lambda


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddModule;

    /// Call AddModule's add_and_offset inline and add 10 to its result
    public fun call_add_and_offset_inline(x: u8, y: u8): u8 {
        let base_result = AddModule::add_and_offset(x, y);
        base_result + 10
    }
}


//# run 0xCAFE::InlineCaller::call_add_and_offset_inline --args 5u8 7u8


//# publish
module 0xCAFE::VarIncrementer {
    /// Increment a mutable u8 variable by 1
    fun inc(x: &mut u8) {
        *x = *x + 1;
    }

    /// Compute the sum of the inputs and apply increments sequentially
    public fun test(a: u8, b: u8): u8 {
        let sum = a + b;
        inc(&mut sum);
        inc(&mut sum);
        sum
    }
}


//# run 0xCAFE::VarIncrementer::test --args 10u8 20u8


//# publish
module 0xCAFE::LambdaCapture {
    struct Captured has copy, drop {
        a: u8,
        b: u8,
    }

    /// Return lambda capturing primitive copies and struct copies, returning sum plus argument
    public fun capture_primitives_and_struct(): (|u8|u8) {
        // Captured values are copied since u8 and Captured have copy
        let captured_primitive: u8 = 3;
        let captured_struct: Captured = Captured { a: 10, b: 20 };

        let lambda: |u8|u8 has copy+drop = |x: u8| {
            // sum captured_primitive + captured_struct.a + captured_struct.b + x
            let total = captured_primitive + captured_struct.a + captured_struct.b + x;
            total
        };
        lambda
    }
}


//# run 0xCAFE::LambdaCapture::capture_primitives_and_struct


//# publish
module 0xCAFE::SpecSchemaModule {

    spec schema NamedSchemaExample {
        val: u8;
    }

    spec fun test_spec_syntax(x: u8) {
        let _val: u8;
        ghost let v: u8;

        // We just declare named schema and access it here as a no-op test for schema declaration
        spec schema AnotherSchema {
            a: u8;
            b: u8;
        };
    }

    public fun dummy_function(x: u8): u8 {
        x
    }
}


//# run 0xCAFE::SpecSchemaModule::dummy_function --args 42u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c47fc392f1811a79b7c4220e1140db83: Test that calling the `inc` function sequentially updates the mutable variable and that the `test` function correctly computes the sum including these increments.
// 3ed814913fe5b769f9a0f8451b248abd: Declare named schemas inside spec blocks.
// 65dff158b55a6f29b2a47bb6a97de359: Test that functions with captured variables (including primitives and structs) correctly retain their environment and produce expected results when invoked with specific arguments.
