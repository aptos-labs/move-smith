
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

    // Function to test variable initialization inside and outside while loops
    public fun variable_scope_test(flag: bool): (u64, u64, u64) {
        let outer_var1 = 0u64;
        let outer_var2 = 0u64;

        let mut_inner: u64;

        let i = 0u64;

        // Variable inside the while loop, shadowed variable
        while (i < 3u64) {
            let inner_var = i + 10u64; // inner variable
            // Shadow outer_var1
            let outer_var1 = inner_var; // define new variable, shadowing outer_var1
            // Assign to mut_inner to verify scoping
            mut_inner = outer_var1;
            i = i + 1;
        };

        // After loop, verify outer variables are unchanged
        (outer_var1, outer_var2, mut_inner)
    }

    // Function to create a variable that shadows an imported module function
    import std::signer;
    use std::signer::{signer};

    // Original imported function (simulate with a dummy, real functions can't be called here)
    public fun imported_function(x: u8): u8 {
        x + 1
    }

    // Shadowed local function with same name
    public fun imported_function(x: u8): u8 {
        x + 42
    }

    // Function to test shadowing of import within a lambda
    public fun shadowing_in_lambda(): u8 {
        let lambda: |u8| u8 = |x: u8| {
            // Call the local/shadowed 'imported_function'
            imported_function(x)
        };
        lambda(10u8)
    }

    // Internal function with 'internal' visibility
    internal fun secret_function(): u64 {
        999u64
    }

    // Public interface to call internal function from inside the module
    public fun call_secret_function(): u64 {
        secret_function()
    }
}


//# run 0xCAFE::NestedAccessTest::access_nested_field --args 0xCAFE::OuterStruct::<field_values>


//# run 0xCAFE::NestedAccessTest::variable_scope_test --args false


//# run 0xCAFE::NestedAccessTest::variable_scope_test --args true


//# run 0xCAFE::NestedAccessTest::shadowing_in_lambda

// External attempt to call internal function should fail (simulate compile error or comment out)
/*
error: cannot invoke internal function from outside module
////  run 0xCAFE::NestedAccessTest::secret_function --args --signers 0xCAFE]
*/


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 0c6264ced8632d23808d99abd623d46c: Test that function parameters can correctly shadow imported module functions with the same name, including in the context of function parameters passed as lambdas.
