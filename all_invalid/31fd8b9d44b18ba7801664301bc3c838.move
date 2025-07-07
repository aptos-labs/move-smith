
//# publish
module 0xABCD::NestedAccess {
    // Define nested structures with dot field access
    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
    }

    struct InnerStruct has copy, drop, store {
        value: u64,
        deeply: DeepStruct,
    }

    struct DeepStruct has copy, drop, store {
        detail: u32,
    }

    public fun create_nested_structs(): OuterStruct {
        let deep = DeepStruct { detail: 99 };
        let inner = InnerStruct { value: 42, deeply: deep };
        let outer = OuterStruct { inner };
        outer
    }

    public fun access_deep_field(s: &OuterStruct): u32 {
        s.inner.deeply.detail
    }
}


//# publish
module 0xABCD::DeprecationMarks {
    // Mark entire address as deprecated (simulating via comments as Move currently lacks deprecation attribute)
    // For testing, referencing a deprecated module
    // Note: Move doesn't support deprecation annotations natively; this is for test purposes

    // Define a module under deprecated namespace for illustration

//# publish
    module 0x1234::DeprecatedModule {
        public fun dummy() {
            // no-op
        }
    }
}


//# publish
module 0xEFGH::FunctionPointers {
    // Define functions
    public fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun multiply_u16(a: u16, b: u16): u16 {
        a * b
    }

    // Function pointer type alias
    type FnU8U8 = |u8, u8| -> u8;

    // Assign functions to variables, pass as args, invoke
    public fun test_function_assignments() {
        let fn_add: FnU8U8 = add_u8;
        let result = fn_add(3, 4);

        // To match the type, redefine or cast; for simplicity, demonstrate correct usage
        // Here, intentionally assign incompatible function to trigger test/stub
        // If type mismatch is desired, code would not compile; for this test, leave as correct
        // let fn_mul: FnU8U8 = multiply_u16; // intentionally commented out

        // Call function pointer inside
        let res = fn_add(2, 2);
        // Use res to keep move success
        res
    }
}


//# publish
module 0x5678::SpecFunctions {
    // Functions with specifications (here, simulated via comments)
    public fun pure_func(x: u64): u64 {
        // Placeholder for purity check
        x
    }

    public fun check_spec_condition(x: u64): u64 acquires Spec {
        // Pseudo-spec check
        // For testing, just return x
        x
    }
}


//# publish
module 0x9ABC::NativeFunctionSyntax {
    // Declare native function with trailing semicolon
    native fun native_sum(a: u64, b: u64): u64;

    // Implemented native function (simulate)
    public fun native_sum_impl(a: u64, b: u64): u64 {
        a + b
    }

    // Define a regular function with block
    public fun regular_func(x: u64): u64 {
        let result = x * 2;
        result
    }
}


//# run
script {
    // Test nested field access
    let nested_structs = 0xABCD::NestedAccess::create_nested_structs();
    let deep_value = 0xABCD::NestedAccess::access_deep_field(&nested_structs);

    // Access deprecated module (simulate warning)
    // Just a reference; in real compile, should produce warning
    // 0x1234::DeprecatedModule::dummy();

    // Assign functions to variables and invoke
    let fn_add: 0xEFGH::FunctionPointers::FnU8U8 = 0xEFGH::FunctionPointers::add_u8;
    let sum_result = fn_add(10, 20);
    // The following line would cause a type mismatch if used directly:
    // let fn_mul: 0xEFGH::FunctionPointers::FnU8U8 = 0xEFGH::FunctionPointers::multiply_u16; // intentionally mismatch for testing

    // For a correct scenario, ensure types match or cast if needed
    // Call a function with specification (simulate check, no explicit call needed)
    let _ = 0x5678::SpecFunctions::pure_func(123);
    let _ = 0x5678::SpecFunctions::check_spec_condition(456);

    // Call native functions: correct syntax ends with semicolon
    let sum_native = 0x9ABC::NativeFunctionSyntax::native_sum(5, 7);
    let normal = 0x9ABC::NativeFunctionSyntax::regular_func(4);
}
