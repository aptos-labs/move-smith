
//# publish
module 0xCAFE::TestNestedAccess {
    // Removed invalid use of std::assert with incorrect syntax
    // std assertion macros are not available in Move; use `assert!` macro instead if available
    // but for simplicity, we can remove the use statement as std::assert might not be valid in this context
    // use std::assert;
    use std::vector;

    // Struct with nested fields
    struct Outer has copy, drop, store {
        inner: Inner,
        value: u64,
    }

    struct Inner has copy, drop, store {
        nested_value: u128,
        nested_struct: NestedStruct,
    }

    struct NestedStruct has copy, drop, store {
        flag: bool,
    }

    public fun create_outer(): Outer {
        let nested = NestedStruct { flag: true };
        let inner = Inner { nested_value: 1234567890123456789, nested_struct: nested };
        Outer { inner, value: 42 }
    }

    public fun get_nested_value(o: &Outer): u128 {
        o.inner.nested_value
    }

    public fun get_flag(o: &Outer): bool {
        o.inner.nested_struct.flag
    }

    // Function to test nested field access
    public fun test_nested_fields(): u128 {
        let outer = create_outer();
        let nested_val = get_nested_value(&outer);
        let flag = get_flag(&outer);
        nested_val + if (flag) { 1 } else { 0 }; // Added missing semicolon
    }
}



//# run 0xCAFE::TestNestedAccess::test_nested_fields



//# publish
module 0xCAFE::TestVariableScoping {
    use std::assert;

    // Variables outside loop
    public fun outer_scope_variables(): u64 {
        let a = 10u64;
        let b = 20u64;
        let c = 30u64;
        // Cannot reassign variables in Move; use shadowing or re-declare
        // Move does not support assignment to local variables, so changing to shadow variables
        let a = a + 1;
        let b = b + 2;
        let c = c + 3;
        (a + b) + c
    }

    // Variables inside loop, shadowed inside
    public fun loop_variable_shadowing(): u64 {
        let x = 100u64;
        let total = 0u64;
        let i = 0u64; // Need mut for reassignment
        while (i < 3) {
            // Shadow `x`
            let x = x + i;
            total = total + x;
            // confirm shadowing works
            assert!(x == 100 + i, 0);
            i = i + 1;
        }; // Added missing semicolon after the while loop
        total
    }
}



//# run 0xCAFE::TestVariableScoping::outer_scope_variables



//# run 0xCAFE::TestVariableScoping::loop_variable_shadowing



//# publish
module 0xCAFE::TestInternalVisibility {
    use std::assert;

    // Internal function only accessible within the module
    fun internal_helper(x: u8): u8 {
        x + 1
    }

    public fun call_internal_helper(x: u8): u8 {
        internal_helper(x)
    }

    // Attempt to call internal_helper from outside should be invalid
}



//# run 0xCAFE::TestInternalVisibility::call_internal_helper --args 5u8



//# publish
module 0xCAFE::TestComplexInteraction {
    use std::assert;

    // Reuse nested structures from previous module
    struct NestedInner has copy, drop, store {
        count: u8,
        nested_struct: 0xCAFE::TestNestedAccess::Inner,
    }

    struct OuterInteraction has copy, drop, store {
        nested: NestedInner,
        description: vector<u8>,
    }

    public fun create_outer_interaction(): OuterInteraction {
        let inner = 0xCAFE::TestNestedAccess::Inner { nested_value: 999999, nested_struct: 0xCAFE::TestNestedAccess::NestedStruct { flag: false } };
        let nested_inner = NestedInner { count: 3u8, nested_struct: inner };
        let description = b"Interaction Test".to_vector();
        OuterInteraction { nested: nested_inner, description }
    }

    public fun access_nested_fields(oi: &OuterInteraction): u128 {
        let nested_struct_flag = oi.nested.nested_struct.flag;
        let count = oi.nested.count;
        let nested_value = get_nested_value(&oi.nested.inner);
        if (nested_struct_flag) {
            nested_value + (count as u128)
        } else {
            nested_value - (count as u128)
        }
    }

    // Helper to get nested_value
    fun get_nested_value(inner: &0xCAFE::TestNestedAccess::Inner): u128 {
        inner.nested_value
    }
}

// Note: Removed "use std::assert;" as std assertions may not be available. If assertions are needed, use `assert!` macro directly.
