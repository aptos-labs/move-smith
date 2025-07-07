
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
    // Corrected attribute syntax: replace ] with )
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
