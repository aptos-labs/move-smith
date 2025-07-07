
//# run 0xCAFE::TestFeatures::test_nested_field_access


//# publish
module 0xCAFE::TestFeatures {
    use std::vector;

    // Struct with nested structure
    struct NestedStruct has store, key {
        outer: OuterStruct,
    }

    struct OuterStruct has store, key {
        inner: InnerStruct,
    }

    struct InnerStruct has store, key {
        value: u64,
    }

    // Function to manipulate deeply nested field
    public fun access_nested_field(ns: &mut NestedStruct): u64 {
        // access nested field via dot notation
        let nested_value: &mut u64 = &mut ns.outer.inner.value;
        // mutate nested value
        *nested_value = *nested_value + 10;
        *nested_value
    }

    // Setup initial nested structure
    public fun init_nested(): NestedStruct {
        let inner = InnerStruct { value: 42 };
        let outer = OuterStruct { inner };
        let ns = NestedStruct { outer };
        ns
    }
}



//# run 0xCAFE::TestFeatures::test_nested_field_access --args


//# publish
module 0xCAFE::DeprecationTest {
    // Apply deprecation attribute at address level
    // (Note: Move doesn't have a built-in deprecated attribute syntax, so just a comment)
    // deprecated]
    use std::signer;
}



//# run 0xCAFE::DeprecationTest::test_deprecation_warnings


//# publish
module 0xCAFE::FunctionAsFirstClass {
    use std::vector;

    // A generic function to be passed around
    public fun generic_fn<T: copy + drop>(x: T): T {
        x
    }

    // Assign function to a variable
    public fun assign_fn(): (u8, u8) -> u8 {
        generic_fn<u8>
    }

    // Define function trait (simulate first-class function pointer)
    public trait FnTrait {
        fun call(x: u8): u8;
    }

    // Implement trait for function pointer
    impl FnTrait for (u8) -> u8 {
        fun call(x: u8): u8 {
            x + 1
        }
    }

    // Function that calls function passed as argument
    public fun call_fn_fn<F: FnTrait>(f: F, arg: u8): u8 {
        f.call(arg)
    }

    // Test passing function as argument
    public fun test_pass_function() {
        let f: (u8) -> u8 = |a: u8| a * 2;
        let result = call_fn_fn(f, 3u8);
        // result should be 6
        assert!(result == 6, 999);
    }
}



//# run 0xCAFE::FunctionAsFirstClass::test_pass_function --args


//# publish
module 0xCAFE::FunctionPurity {
    use std::vector;

    // Function with spec (ensure purity)
    public fun pure_function(x: u64): u64 {
        x + 1
    }

    // Function with side effects (simulate impurity)
    public fun impure_function(x: &mut u64) {
        *x = *x + 1;
    }

    // Function that calls only pure functions
    public fun test_pure(): u64 {
        let result = pure_function(10);
        result
    }

    // Function that attempts to call impure function in a pure context should fail
    // (This is a compile-time check, so code is commented)
    // public fun invalid_pure_call() {
    //     let x = 0;
    //     impure_function(&mut x); // should error
    // }
}
