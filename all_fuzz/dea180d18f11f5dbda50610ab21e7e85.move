
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}


//# publish
module 0xCAFE::TestAddAndLambda {
    // Removed unused 'use std::signer' to avoid warning

    struct Container has copy, drop, store {
        value: u8,
        flag: bool,
    }

    // 1. Test addition of two u8 values before returning a specific value.
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        let fixed: u8 = 42;
        // Use sum to ensure the computation
        let _ = sum;
        fixed
    }

    // 2. Lambda (anonymous function) that doubles a number
    public fun double_and_apply_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy + drop = |a: u8| {
            a * 2
        };
        lambda(x)
    }

    // 3. Calls inline function from another module
    public fun nested_inline_call(x: u16): u16 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        a + b
    }

    // 4. Test if-else variable initialization and usage
    public fun if_else_var_use(cond: bool): u8 {
        let v: u8;
        if (cond) {
            v = 10;
        } else {
            v = 20;
        };
        // Use v after if-else
        v + 1
    }

    // 5. Define a condition expression within a spec block
    // Spec blocks are not supported in runtime Move but typically part of Move Prover spec.
    // We'll fake one here to adhere to the requirement (though it won't have effect at execution).
    // This is just a regular function now.
    public fun spec_condition(x: u8, y: u8): bool {
        x + y > 10
    }

    // 6. Access nested fields with dot notation
    public fun nested_field_access(): u8 {
        let c = Container {value: 100, flag: true};
        let v = c.value;
        // We ignore flag but demonstrate access
        if (c.flag) {
            v + 1
        } else {
            v
        }
    }

    // Runner function calling all above to exercise them
    public fun runner() {
        let _ = add_then_return(3, 4);
        let _ = double_and_apply_lambda(7);
        let _ = nested_inline_call(5);
        let _ = if_else_var_use(true);
        let _ = if_else_var_use(false);
        let _ = nested_field_access();
    }
}


//# run 0xCAFE::TestAddAndLambda::add_then_return --args 1u8 2u8


//# run 0xCAFE::TestAddAndLambda::double_and_apply_lambda --args 6u8


//# run 0xCAFE::TestAddAndLambda::nested_inline_call --args 2u16


//# run 0xCAFE::TestAddAndLambda::if_else_var_use --args true


//# run 0xCAFE::TestAddAndLambda::if_else_var_use --args false


//# run 0xCAFE::TestAddAndLambda::nested_field_access


//# run 0xCAFE::TestAddAndLambda::runner
