
//# publish
module 0xBADD::NestedAccess {
    struct InnerData has store, key {
        value1: u64,
        value2: bool,
    }

    struct OuterData has store, key {
        inner: InnerData,
        other_field: bool,
    }

    public fun get_nested_value1(data_ref: &OuterData): u64 {
        data_ref.inner.value1
    }

    public fun set_nested_value2(data_ref: &mut OuterData, new_value: bool) {
        data_ref.inner.value2 = new_value;
    }
}


//# publish
module 0xFAKE::Deprecation {
    // deprecated(address)]
    public fun deprecated_function() {
        // do nothing
    }
}


//# publish
module 0xC0DE::FunctionUtils {
    // Function that accepts a generic function pointer and invokes it
    public fun invoke_fn<F: copy + drop + fun(): u8>(f: &F): u8 {
        f()
    }

    // Function returning a function pointer
    public fun get_closure(): &fun(): u8 {
        &example_fn
    }

    // Some example function for testing
    public fun example_fn(): u8 {
        42
    }
}


//# publish
module 0xSPEC::Checker {
    // Spec functions for validation
    public fun check_pure() {
        // placeholder: imagine static analysis or custom check
    }

    public fun check_correctness() {
        // placeholder
    }
}


//# run 0xBADD::NestedAccess::get_nested_value1 --args 1u64


//# run 0xBADD::NestedAccess::set_nested_value2 --args 2u8


//# run 0xFAKE::Deprecation::deprecated_function


//# run 0xC0DE::FunctionUtils::invoke_fn --args 42u8


//# run 0xC0DE::FunctionUtils::get_closure --signers 0x0 --args --no-args
// Call the function pointer returned to verify it returns 42

//# run 0xC0DE::FunctionUtils::invoke_fn<&fun(): u8> --args 42u8


//# run 0xSPEC::Checker::check_pure

//# run 0xSPEC::Checker::check_correctness


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
