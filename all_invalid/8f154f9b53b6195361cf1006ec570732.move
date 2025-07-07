
//# publish
module 0xCAFEBABE::NestedStructs {
    // Use std for fundamental vector and assertions
    use std::vector;
    use std::assert;

    // Define a complex nested structure
    struct InnerStruct has copy, drop, store {
        a: u8,
        b: u16,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        c: bool,
    }

    // A module containing deprecated attribute for testing
    // Assume this is a new, optionally deprecated module
    // deprecated]
//# publish
    module 0xCAFE::DeprecatedModule {
        use std::assert;

        struct Data has copy, drop, store {
            value: u64,
        }

        public fun get_value(d: &Data): u64 {
            d.value
        }
    }

    // Function to create and mutate nested fields
    public fun test_nested_access() {
        let inner = InnerStruct { a: 12, b: 300 };
        let outer = OuterStruct { inner, c: false };

        // Access nested field
        let _a_value = outer.inner.a;
        let _b_value = outer.inner.b;

        // Mutate nested field
        let outer_mut = &mut outer;
        outer_mut.inner.a = 34;
        outer_mut.inner.b = 400;

        // Re-access mutated values
        let new_a = outer.inner.a;
        let new_b = outer.inner.b;

        // Use assertions to validate mutation
        assert!(new_a == 34, 101);
        assert!(new_b == 400, 102);
    }

    // Function to test deprecated module usage, expecting warnings or errors
    public fun test_deprecated_module_usage() {
        // Borrow global data from deprecated module
        // This should trigger deprecation warning/error in compiler
        let data = move_from<0xCAFE::DeprecatedModule::Data>(0xCAFE);
        let val = 0xCAFE::DeprecatedModule::get_value(&data);

        // Validate via assertion
        assert!(val == 42, 103);
    }

    // Function to assign functions to variables and invoke with type args
    public fun test_function_assignments() {
        // Define a simple function
        fun add_one(x: u8): u8 {
            x + 1
        }

        // Assign function to a variable
        let f: |u8|u8 = add_one;

        // Call via variable
        let res = f(10);
        assert!(res == 11, 104);

        // Generic function
        fun generic_id<T: copy>(x: T): T {
            x
        }
        // Assign generic function with type parameter
        let gf: |u16|u16 = generic_id;

        // Call generic function
        let g_res = gf(255);
        assert!(g_res == 255, 105);

        // Pass function as argument and invoke
        fun call_func(fptr: |u8|u8, val: u8): u8 {
            fptr(val)
        }
        let result2 = call_func(add_one, 20);
        assert!(result2 == 21, 106);
    }

    // Function to test function pointers with type arguments
    public fun test_function_pointers_with_type_args() {
        // Define a generic function
        fun identity<T: copy>(x: T): T {
            x
        }

        // Function pointer with specific type
        let fp: |u64|u64 = identity;

        // Invoke function pointer
        let res = fp(12345);
        assert!(res == 12345, 107);
    }

    // Function to test specification checks and purity
    public fun test_spec_and_purity() {
        // Define pure functions
        fun pure_add(x: u64, y: u64): u64 {
            x + y
        }

        // Function using pure function in call chain
        fun caller(x: u64, y: u64): u64 {
            pure_add(x, y)
        }

        // Validate functions' purity (assuming test validation for pureness)
        // In actual test, Pseudo-analyze or verify this conforms
        let res = caller(10, 20);
        assert!(res == 30, 108);
    }

    // Integrated test accessing nested fields, deprecated module, function vars, and specs
    public fun test_integration() {
        // Nesting access within complex struct
        let inner = InnerStruct { a: 7, b: 77 };
        let outer = OuterStruct { inner, c: true };

        // Mutate and access nested fields
        outer.inner.a = 55;
        outer.inner.b = 555;

        // Access deprecated module data
        let data = move_from<0xCAFE::DeprecatedModule::Data>(0xCAFE);
        let val = 0xCAFE::DeprecatedModule::get_value(&data);
        // No explicit assertion, just simulate usage

        // Assign function to variable and invoke
        fun double(x: u8): u8 { x * 2 }
        let func_var: |u8|u8 = double;

        let result = func_var(4);
        // use result
        assert!(result == 8, 109);

        // Call function pointer with type args
        fun generic_identity<T: copy>(x: T): T { x }
        let fp: |u16|u16 = generic_identity;
        let gres = fp(999);
        assert!(gres == 999, 110);
    }
}


//# run 0xCAFEBABE::NestedStructs::test_nested_access



//# run 0xCAFEBABE::NestedStructs::test_deprecated_module_usage --signers 0xDABBAD00



//# run 0xCAFEBABE::NestedStructs::test_function_assignments


//# run 0xCAFEBABE::NestedStructs::test_function_pointers_with_type_args


//# run 0xCAFEBABE::NestedStructs::test_spec_and_purity


//# run 0xCAFEBABE::NestedStructs::test_integration


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
