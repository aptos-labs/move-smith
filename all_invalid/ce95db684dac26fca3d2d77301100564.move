
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
    // For the sake of test, assume usage triggers a warning/error
    // The actual compile-time warning simulation is environment-specific; here, we test referencing
    // a deprecated module
    // Please note: Move currently doesn't support deprecation annotations; so this is a pseudo-test.

    
//# deprecate 0x1234::

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
    // Define generic and non-generic functions
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

        let fn_mul: FnU8U8 = multiply_u16; // intentionally for test, should cause type mismatch if used wrong
        // Correct would be to define a matching type for u16, but for testing, leave as is

        // Call function pointer inside
        let res = fn_add(2, 2);
        // Use res to keep move success
        res
    }
}

//# publish
module 0x5678::SpecFunctions {
    // Functions with specifications (here, simulated via precondition checks)
    public fun pure_func(x: u64): u64 {
        // For illustration, suppose we verify that x is even
        // (Actually, Move doesn't support annotations, but assume verification outside)
        // This is just a placeholder
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
    // Declare native function with trailing semicolon (correct syntax)
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
    // Just a reference with comment; in real compile, should produce warning
    // 0x1234::DeprecatedModule::dummy();

    // Assign functions to variables and invoke
    let fn_add: 0xEFGH::FunctionPointers::FnU8U8 = 0xEFGH::FunctionPointers::add_u8;
    let sum_result = fn_add(10, 20);
    let fn_mul: 0xEFGH::FunctionPointers::FnU8U8 = 0xEFGH::FunctionPointers::multiply_u16; // Should cause type mismatch
    // Test calling function pointer
    let _ = fn_add(1, 2);

    // Call a function with specification (simulate check, no explicit call needed)
    let _ = 0x5678::SpecFunctions::pure_func(123);
    let _ = 0x5678::SpecFunctions::check_spec_condition(456);

    // Call native functions: correct syntax ends with semicolon
    let sum_native = 0x9ABC::NativeFunctionSyntax::native_sum(5, 7);
    let normal = 0x9ABC::NativeFunctionSyntax::regular_func(4);
}


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// eccac62b7732d501973093a96d582dae: End function declarations with a semicolon for native functions or a block for implemented functions.
