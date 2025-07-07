
//# publish
module 0xDEADBEEF::NestedStructAccess {
    use std::debug;

    struct InnerStruct has copy, drop, store {
        inner_field: u128,
        more_data: bool,
    }

    struct OuterStruct has copy, drop, store {
        nested: InnerStruct,
        value: u64,
    }

    public fun create_outer_struct(): OuterStruct {
        let inner = InnerStruct { inner_field: 9999, more_data: true };
        let outer = OuterStruct { nested: inner, value: 42 };
        outer
    }

    public fun get_nested_inner_field(s: OuterStruct): u128 {
        s.nested.inner_field
    }

    public fun get_nested_more_data(s: OuterStruct): bool {
        s.nested.more_data
    }
}



//# publish
module 0xBADDCAFE::DeprecationMarker {
    // All modules under this address are deprecated
    // This attribute should propagate to modules produced here
    // deprecated]
    public fun dummy() { }
}



//# publish
module 0xDEADBEEF::FunctionPointerTests {
    use std::debug;
    use std::vector;
    use std::signer;

    // Example of a simple function to be used as first-class function
    public fun add_one(x: u64): u64 {
        x + 1
    }

    // Generic function
    public fun generic_increment<T: copy + drop + store>(x: T): T {
        // In real code, we would have type-specific logic.
        // For testing function assignment, just return x.
        x
    }

    // Closure in Move (simulate via inline function assigned to variable)
    public fun create_closure(): |u64| -> u64 {
        |x: u64| { x + 10 }
    }

    // Function to test passing function as argument
    public fun apply_func(f: |u64| -> u64, value: u64): u64 {
        f(value)
    }

    // Function to assign function pointer to variable
    public fun assign_func_pointer(): |u64| -> u64 {
        add_one
    }

    // Function to invoke function pointer
    public fun invoke_func_pointer(f: |u64| -> u64, input: u64): u64 {
        f(input)
    }

    // Testing nested struct with dot notation
    public fun test_nested_structure(): u64 {
        let outer = super::NestedStructAccess::create_outer_struct();
        let inner_value = super::NestedStructAccess::get_nested_inner_field(outer);
        let more_data_flag = super::NestedStructAccess::get_nested_more_data(outer);
        // Use the retrieved values to compute or just return inner_value
        if (more_data_flag) {
            inner_value as u64 + 100
        } else {
            inner_value as u64
        }
    }
}



//# run 0xDEADBEEF::FunctionPointerTests::apply_func --args 11u64


//# run 0xDEADBEEF::FunctionPointerTests::assign_func_pointer --signers 0x0 --args


//# run 0xDEADBEEF::FunctionPointerTests::invoke_func_pointer --args add_one 7u64


//# run 0xDEADBEEF::FunctionPointerTests::test_nested_structure



//# run 0xBADDCAFE::DeprecationMarker::dummy --signers 0x0

// Attempt to use deprecated module (should still compile but flagged as deprecated)
 

//# run 0xBADDCAFE::DeprecationMarker::dummy --signers 0x0

// Confirms that nested struct gets correct property access


//# run 0xDEADBEEF::FunctionPointerTests::test_nested_structure --args
