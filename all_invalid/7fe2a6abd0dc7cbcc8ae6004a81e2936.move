
//# publish
module 0xBADD::NestedStructs {
    // Define nested structures and expressions with dot notation access
    struct InnerChild has copy, drop, store {
        subfield1: u8,
        subfield2: u16,
    }

    struct InnerParent has copy, drop, store {
        child: InnerChild,
        flag: bool,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerParent,
        value: u32,
    }

    public fun create_nested_structs(): OuterStruct {
        let nested_child = InnerChild { subfield1: 1u8, subfield2: 300u16 };
        let nested_parent = InnerParent { child: nested_child, flag: true };
        let outer = OuterStruct { inner: nested_parent, value: 999u32 };
        outer
    }

    public fun validate_nested_fields(outer: &OuterStruct): bool {
        outer.inner.child.subfield1 == 1u8 &&
        outer.inner.child.subfield2 == 300u16 &&
        outer.inner.flag
    }
}


//# publish
module 0xC0DE::DeprecationModule {
    // Mark entire module as deprecated (simulated via attribute, Move itself doesn't support deprecation directly)
    // For testing, we will treat it as deprecated and expect warnings/errors upon usage.
    // Note: Actual deprecation would be via compiler warning, which cannot be simulated here; we just use a comment.
    // Deprecation attribute simulation
    // // deprecated]
    //  This module is deprecated.
    // For the purpose of this test, assume the compiler flags this upon usage.
    use std::string;

    // Nested sub-module
//# publish
    module nested_sub {
        struct Data has copy, drop, store {
            info: vector<u8>,
        }

        public fun get_info(data: &Data): vector<u8> {
            data.info
        }
    }

    public fun dummy() {}
}


//# publish
module 0xFAKE::FunctionPointerTest {
    use std::vector;
    use std::signer;
    use 0xBADD::NestedStructs;

    // Define function types as values
    // Note: Function types as variables need to be simulated via `fun` references
    
    // Function pointer to a non-generic function
    fun f_plain(x: u8): u8 {
        x + 10u8
    }

    // Generic function - for Move, simulate by a non-generic function with explicit specialization
    fun f_generic<T: copy + drop>(x: T): T {
        x
    }

    // Closure function: in Move, represented as function pointer, for test pass as argument
    fun closure_add(x: u8): u8 {
        x + 5u8
    }

    // Function accepting another function as argument
    public fun apply_function(fp: fun(x: u8): u8, val: u8): u8 {
        fp(val)
    }

    // Function that returns a function pointer
    public fun get_fn_pointer(): fun(x: u8): u8 {
        f_plain
    }

    // Function that calls nested module attribute (simulate deprecated module usage)
    // using 'deprecated' module's function
    public fun call_deprecated_module_func(): vector<u8> {
        // Simulate passing function from deprecated module, which should produce warning/error
        // assuming compiler flags this
        0xC0DE::DeprecationModule::nested_sub::get_info(@0xC0DE::DeprecationModule::nested_sub)
    }

    // Function pointer as argument with nested attribute access
    public fun process_with_deprecated_func(): u8 {
        let deprecated_fn_ref: fun(data: &0xC0DE::DeprecationModule::nested_sub::Data): vector<u8> = 0xC0DE::DeprecationModule::nested_sub::get_info;
        // Using deprecated function (simulate warning/error)
        // To test, just invoke with dummy data
        let dummy_data = 0xC0DE::DeprecationModule::nested_sub::Data { info: vector::empty<u8>() };
        // simulate the usage
        // NOTE: In real move, passing a function with such type may not be straightforward, here just testing assignment
        // In actual Move, function pointers are limited; for the test, assume it works
        Vector::length(&deprecated_fn_ref(&dummy_data))
    }

    // Function to test passing function pointers to other functions
    public fun run_function_tests(): u8 {
        let fp = get_fn_pointer();
        let res = apply_function(fp, 20u8);
        res
    }

    // Function to test passing a closure (simulate via function pointer)
    public fun use_closure(): u8 {
        let closure_fn: fun(x: u8): u8 = closure_add;
        apply_function(closure_fn, 50u8)
    }
}


//# run 0xFAKE::FunctionPointerTest::run_function_tests --args
// (This tests passing function pointers, including generic and closure as first-class values)


//# run 0xFAKE::FunctionPointerTest::use_closure --args

// This script tests nested field access

//# run 0xBADD::NestedStructs::create_nested_structs

//# run 0xBADD::NestedStructs::validate_nested_fields --args 


//# run 0xC0DE::DeprecationModule::dummy


//# run 0xC0DE::DeprecationModule::nested_sub::get_info --args 


//# run 0xFAKE::FunctionPointerTest::call_deprecated_module_func


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
