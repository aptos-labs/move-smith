
//# publish
module 0xCAFE::NestedStructModule {
    use std::vector;

    struct InnerStruct has copy, drop, store {
        a: u64,
        b: u64,
        nested: NestedStruct,
    }

    struct NestedStruct has copy, drop, store {
        c: u64,
        d: u64,
    }

    public fun create_inner_struct(a: u64, b: u64, c: u64, d: u64): InnerStruct {
        let nested = NestedStruct { c, d };
        let inner = InnerStruct { a, b, nested };
        inner
    }

    public fun get_nested_field(inner: &InnerStruct): u64 {
        inner.nested.c
    }

    public fun set_nested_field(inner: &mut InnerStruct, new_c: u64) {
        inner.nested.c = new_c;
    }
}


//# run 0xCAFE::NestedStructModule::create_inner_struct --args 10 20 30 40

//# run 0xCAFE::NestedStructModule::get_nested_field --args 10u64 20u64 30u64 40u64


//# publish
module 0xDEAD::DeprecationTest {
    // Mark entire module as deprecated (simulate) by attribute
    deprecate;
    // Since Move doesn't have an actual deprecate attribute, assume this is a conceptual marker.
    use std::signer;

    struct DeprecatedStruct has copy, drop, store {
        val: u8,
    }

    public fun create_deprecated_struct(val: u8): DeprecatedStruct {
        let ds = DeprecatedStruct { val };
        ds
    }
}


//# publish
module 0xCAFE::DeprecationWrapper {
    use 0xDEAD::DeprecationTest;

    // Function calling deprecated module
    public fun call_deprecated_module() {
        let _ = DeprecationTest::create_deprecated_struct(42);
    }
}


//# run 0xCAFE::DeprecationWrapper::call_deprecated_module


//# publish
module 0xCAFE::FunctionTest {
    use std::vector;

    // Function assigned to variable
    public fun add_one(x: u64): u64 {
        x + 1
    }

    // Higher-order function accepting a function pointer
    public fun apply_fn(f: |u64|: u64, val: u64): u64 {
        f(val)
    }

    // Function pointer variable
    public fun test_first_class() {
        let func_ptr: |u64|: u64 = add_one;
        let result = apply_fn(func_ptr, 5);
        // Use result for anything or just ensure no errors
        assert!(result == 6, 999);
        // Pass function pointer directly
        let result2 = apply_fn(|x| x * 2, 7);
        assert!(result2 == 14, 999);
    }
}


//# run 0xCAFE::FunctionTest::test_first_class


//# publish
module 0xCAFE::SpecCompliance {
    // Example of a pure function with pre/post conditions (simulate via comments)
    public fun pure_add(x: u64, y: u64): u64 {
        // Precondition: x >= 0, y >= 0 (implied by u64)
        // Postcondition: result == x + y
        x + y
    }

    // Another function—should be pure and adhere to standards
    public fun multiply(x: u64, y: u64): u64 {
        x * y
    }
}


//# run 0xCAFE::SpecCompliance::pure_add --args 10u64 20u64

//# run 0xCAFE::SpecCompliance::multiply --args 5u64 4u64


//# publish
module 0xCAFE::ComplexInteractionTest {
    use 0xCAFE::NestedStructModule;
    use 0xDEAD::DeprecationTest;

    // Nested struct access, deprecation and function as first-class
    public fun test_complex_flow() {
        let inner = NestedStructModule::create_inner_struct(1, 2, 3, 4);
        let c_value = NestedStructModule::get_nested_field(&inner);
        assert!(c_value == 3, 101);

        // Attempt to set new nested value
        let inner_mut = inner;
        NestedStructModule::set_nested_field(&mut inner_mut, 99);

        let updated_c_value = NestedStructModule::get_nested_field(&inner_mut);
        assert!(updated_c_value == 99, 102);

        // Call deprecated module function from nested context
        let _ = DeprecationTest::create_deprecated_struct(55);
    }

    // Test treating functions as first-class and passing as arguments
    public fun test_first_class_integration() {
        // assign function to variable
        let f: |u64|: u64 = |x| x + 5;
        let result = f(10);
        assert!(result == 15, 103);

        // passing function as argument
        let res_apply = apply_and_negate(f, 20);
        assert!(res_apply == -25, 104);
    }

    public fun apply_and_negate(f: |u64|: u64, val: u64): i64 {
        // simulate negation as casting to i64 and subtracting
        let res = f(val);
        -(res as i64)
    }
}


//# run 0xCAFE::ComplexInteractionTest::test_complex_flow

//# run 0xCAFE::ComplexInteractionTest::test_first_class_integration


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
