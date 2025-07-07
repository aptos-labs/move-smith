
//# publish
module 0xCAFE::LambdaAndInline {
    use 0xCAFE::MyModule;

    public fun add_two_values_and_return_10(a: u8, b: u8): u8 {
        let sum = a + b;
        // We ignore sum but the function tests adding two u8 correctly
        10u8
    }

    public fun test_lambda() {
        let increment = |x: u8| { x + 1 };
        let apply_twice = |f: |u8|u8, v: u8| {
            let v2 = f(v);
            f(v2)
        };
        let _res = apply_twice(increment, 1u8);
    }

    public fun cross_module_inline_call(a: u16): u16 {
        // Call f2 inline function of ::MyModule and use returned tuple
        let (x, y) = MyModule::f2(a);
        x + y
    }

    // Define enum with variants having fields with same name and function to mutate and read fields
    enum MultiField has copy, drop {
        VariantA { shared: u8 },
        VariantB { shared: u8 }
    }

    public fun create_a(value: u8): MultiField {
        MultiField::VariantA { shared: value }
    }

    public fun create_b(value: u8): MultiField {
        MultiField::VariantB { shared: value }
    }

    public fun get_shared_value(e: MultiField): u8 {
        match (e) {
            MultiField::VariantA { shared } => shared,
            MultiField::VariantB { shared } => shared
        }
    }

    public fun mutate_shared_value(e: &mut MultiField, new_value: u8) {
        match (e) {
            MultiField::VariantA { shared } => { *shared = new_value; },
            MultiField::VariantB { shared } => { *shared = new_value; }
        };
    }

    public fun run_all() {
        let _ = add_two_values_and_return_10(3u8, 7u8);
        test_lambda();
        let _ = cross_module_inline_call(5u16);

        let v = create_a(100u8);
        mutate_shared_value(&mut v, 101u8);
        let _ = get_shared_value(v);

        let w = create_b(200u8);
        mutate_shared_value(&mut w, 201u8);
        let _ = get_shared_value(w);
    }
}


//# run 0xCAFE::LambdaAndInline::add_two_values_and_return_10 --args 4u8 6u8


//# run 0xCAFE::LambdaAndInline::test_lambda


//# run 0xCAFE::LambdaAndInline::cross_module_inline_call --args 7u16


//# run 0xCAFE::LambdaAndInline::run_all


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 27caab84d63bd8f11cd0e5aff2f33529: Test that fields with the same name in different variants of an enum can be accessed and mutated correctly via variant bindings.
