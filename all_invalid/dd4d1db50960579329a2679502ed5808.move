
//# publish
module 0xDEED::TestNestedAndScopes {
    // Correct the import statement for debug module
    use std::debug;

    // Struct with nested struct for testing nested field access
    struct Outer has copy, drop, store {
        inner: Inner,
        value: u64,
    }

    struct Inner has copy, drop, store {
        nested: Deep,
        count: u8,
    }

    struct Deep has copy, drop, store {
        detail: bool,
    }

    // Internal function to test internal visibility enforcement
    fun internal_helper(x: u64): u64 {
        x + 10
    }

    // Public function calling internal, but external modules cannot access internal_helper
    public fun call_internal_helper(x: u64): u64 {
        internal_helper(x)
    }
}



//# run 0xDEED::TestNestedAndScopes::test_nested_field_access
script {
    // Instantiate nested structures
    let deep = Deep { detail: true };
    let inner = Inner { nested: deep, count: 255 };
    let outer = Outer { inner: inner, value: 9223372036854775807u64 }; // max u64 literal (assuming 64-bit)

    // Access nested field double-dot notation
    let nested_detail: bool = outer.inner.nested.detail;

    // Assign nested field to a local variable
    let outer_value: u64 = outer.value;

    // Since Move scripts can't mutate global resources directly, simulate mutation by reconstructing structures
    // Create a new Inner with modified nested detail
    let new_inner = Inner { nested: Deep { detail: false }, count: outer.inner.count };
    let new_outer = Outer { inner: new_inner, value: outer_value };

    // Access deeply nested fields
    let deep_detail = new_outer.inner.nested.detail;

    // Shadowing variable in inner scope with nested blocks
    let scope_var: u8 = 1;
    {
        // shadow
        let scope_var: u8 = 2;
        debug::print(&b"Inner scope shadowed var: "[u8]);
        debug::print(&vec![scope_var]);
    } // scope_var in outer scope remains 1

    // Testing variable scope outside inner block
    debug::print(&b"Outer scope var: "[u8]);
    debug::print(&vec![scope_var]);

    // Call internal function (should succeed in module)
    let internal_result = 0xDEED::TestNestedAndScopes::call_internal_helper(5u64);
    debug::print(&b"Internal helper result: "[u8]);
    debug::print(&vec![internal_result]);

    // Literal boundary values
    let max_u8: u8 = 255;
    let max_u16: u16 = 65535;
    let max_u32: u32 = 4294967295;
    let max_u64: u64 = 18446744073709551615;

    (nested_detail, deep_detail, max_u8, max_u16, max_u32, max_u64)
}



//# run 0xDEED::TestNestedAndScopes::test_variable_scope
script {
    let outer_var: u32 = 100;
    // Loop with local variable shadowing
    let _ = {
        let outer_var: u32 = 200;
        // shadow inside inner block
        {
            let outer_var: u32 = 300;
            debug::print(&b"Shadowed inner var: "[u8]);
            debug::print(&vec![outer_var]);
        }
        // outside inner block
        outer_var
    };

    // After block, check variable value (should be outer_var from outermost scope)
    debug::print(&b"Outer variable after inner blocks: "[u8]);
    debug::print(&vec![outer_var]);

    // Loop with local variable declaration
    let i: u64 = 0;
    while (i < 3) {
        let local_i = i; // local variable shadows outer
        debug::print(&b"Loop iteration: "[u8]);
        debug::print(&vec![local_i]);
        i = i + 1;
    };

    // Final value of i
    debug::print(&b"Final i value: "[u8]);
    debug::print(&vec![i]);

    // Test that outer variable remains unchanged inside loop
    outer_var
}



//# publish
module 0xDEED::VisibilityTest {
    // Internal visible function
    fun internal_func(x: u64): u64 {
        x * 2
    }

    // Public function to call internal
    public fun call_internal(x: u64): u64 {
        internal_func(x)
    }
}



//# run 0xDEED::VisibilityTest::call_internal --args 10u64



//# publish
module 0xABCD::LiteralEdge {
    // No functions, testing literal parsing and boundary values
    // Use boundary literals in a function
    public fun test_literals(): (u8, u16, u32, u64) {
        let small_u8: u8 = 255;
        let boundary_u16: u16 = 65535;
        let boundary_u32: u32 = 4294967295;
        let large_u64: u64 = 18446744073709551615;

        (small_u8, boundary_u16, boundary_u32, large_u64)
    }
}
