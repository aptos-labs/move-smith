//# publish
module 0xCAFE::NestedAccessTest {
    use std::vector;

    // Structs with nested fields for nested access testing
    struct InnerStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct MiddleStruct has copy, drop, store {
        inner: InnerStruct,
        c: u8,
    }

    struct OuterStruct has copy, drop, store {
        middle: MiddleStruct,
        d: u8,
    }

    // Public function to test nested field access
    public fun access_nested_field(o: OuterStruct): u8 {
        // Accessing deeply nested fields
        o.middle.inner.a
    }

    // Function to test variable scope and shadowing inside while loops
    public fun variable_scope_test(flag: bool): (u64, u64, u64) {
        let outer_var1 = 0u64;
        let outer_var2 = 0u64;

        let mut_inner: u64 = 0;

        let i = 0u64;

        // Loop with shadowing variable
        while (i < 3u64) {
            let inner_var = i + 10u64; // inner variable
            // Shadow outer_var1
            let outer_var1 = inner_var; // defines a new local variable in scope
            // assign to mutable variable to verify scope
            mut_inner = outer_var1;
            i = i + 1;
        };
        // After loop, outer_var1 is unchanged; mut_inner holds last assigned shadowed value
        (outer_var1, outer_var2, mut_inner)
    }

    // Import and function shadowing example
    use std::signer;

    // Simulated imported function
    public fun imported_function(x: u8): u8 {
        x + 1
    }

    // Shadowed local function with same name
    public fun imported_function(x: u8): u8 {
        x + 42
    }

    // Function to test shadowing of import within lambda
    public fun shadowing_in_lambda(): u8 {
        let lambda: |u8| u8 = |x: u8| {
            // Calls the local 'imported_function' (shadowed)
            imported_function(x)
        };
        lambda(10u8)
    }

    // Internal function with 'internal' visibility
    internal fun secret_function(): u64 {
        999u64
    }

    // Public function to call internal function
    public fun call_secret_function(): u64 {
        secret_function()
    }
}

// Usage and test commands (to be run with correct args)

// Correct way to specify type-args or no needs if none are needed
// Example, if no type arguments required, just omit '<>' in command

// Access nested field
// run 0xCAFE::NestedAccessTest::access_nested_field --args "0xCAFE<field_value_for_a> 0xCAFE<field_value_for_b> 0xCAFE<field_value_for_c> 0xCAFE<field_value_for_d>"

// But since the function takes a struct, you need to pass a serialized struct or use default initialization.
// Alternatively, for testing purposes, create and move a struct within the test environment:

// For the faulty command, the problem was trying to pass <field_values> as a type-args token, which is invalid.
// Instead, you should prepare the struct in Move or in the test environment and pass a move value, not as type args.

// Example: To test the 'access_nested_field' function, you need to prepare the struct beforehand.
// Since this is a code sample, the method of passing args depends on your testing setup, e.g., in a script or test.


// For the variable_scope_test function, call with true or false
// run 0xCAFE::NestedAccessTest::variable_scope_test --args false
// run 0xCAFE::NestedAccessTest::variable_scope_test --args true

// For shadowing_in_lambda
// run 0xCAFE::NestedAccessTest::shadowing_in_lambda

// Note: The main fix is to avoid passing '<field_values>' as a type-argument, which is invalid syntax.
// Instead, prepare values in the move script or test environment accordingly.
