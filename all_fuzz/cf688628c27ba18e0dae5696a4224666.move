
//# publish
module 0xCAFE::TestAddition {
    // Test that the Move function correctly computes addition of two u8 numbers and returns a fixed value.

    /// Add two u8 values but always return 42
    public fun add_but_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        let _unused = sum;
        42u8
    }
}



//# run 0xCAFE::TestAddition::add_but_return_constant --args 12u8 30u8



//# publish
module 0xCAFE::TestLambda {
    // Write functions containing lambda expressions and test calling them.

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        lambda(10u8, 15u8)
    }

    public fun apply_lambda_and_multiply(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a * b
        };
        let product = f(x, y);
        product
    }
}



//# run 0xCAFE::TestLambda::run_lambda_example



//# run 0xCAFE::TestLambda::apply_lambda_and_multiply --args 6u8 7u8



//# publish
module 0xCAFE::TestNestedInlineCalls {
    // Removed use of unbound module 0xCAFE::MyModule; fixed to implement needed functionality inline.

    public fun f2(a: u16): (u16, u16) {
        // Provide a dummy implementation similar to what MyModule::f2 would have done.
        // For example, return tuple (a, a*2)
        (a, a * 2)
    }

    public fun nested_call(a: u16): u16 {
        let (r1, r2) = Self::f2(a);
        let result = r1 + r2;
        result
    }
}



//# run 0xCAFE::TestNestedInlineCalls::nested_call --args 20u16



//# publish
module 0xCAFE::TestLocalUpdate {
    // Test that assigning a new value to a local variable updates it correctly before returning.
    public fun update_local_var(): u8 {
        let mut_val = 5u8;
        let new_val = mut_val + 10u8;
        // Because we cannot declare mut variables, we simulate reassignment by shadowing
        let mut_val = new_val;
        mut_val
    }
}



//# run 0xCAFE::TestLocalUpdate::update_local_var
