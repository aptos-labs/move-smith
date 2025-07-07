
//# publish
module 0xBAD1::SyntaxSemanticsTests {
    use std::vector;

    // Function to test nested calls with parentheses and multiple arguments
    public fun nested_calls_test(): u8 {
        // Outer call with inner call as argument
        let result = f_outer(
            f_inner(3u8),
            f_add(5u8, 10u8),
            f_chain(f_inner(2u8), f_add(1u8, 1u8))
        );
        result
    }

    // Helper inline functions to simulate nested call semantics
    public inline fun f_inner(arg: u8): u8 {
        arg + 1
    }

    public fun f_add(a: u8, b: u8): u8 {
        a + b
    }

    public inline fun f_chain(a: u8, b: u8): u8 {
        a + b
    }

    public fun f_outer(arg1: u8, arg2: u8, arg3: u8): u8 {
        arg1 + arg2 + arg3
    }

    // Attribute assignment simulation: Assign module attribute
    // (Note: Move does not support attribute syntax directly, so we simulate via comments and process context)
    
//# attribute 0xBAD1::AttrModule

    // Submit a call with attribute referencing module
    public fun attribute_assignment_test(): u8 {
        // simulate attribute linkage
        let _module_attr = 0xBAD1::AttrModule;
        // call a function from the attribute module
        // expecting that attribute points to module
        // Correct attribute usage
        0xBAD1::AttrModule::attr_func()
    }

    // inline function to test inline function calls
    public inline fun inline_test(): u16 {
        // call an inline-only function
        inline_only_func(7u16)
    }

    // declare an inline-only function
    public inline fun inline_only_func(val: u16): u16 {
        val + 1
    }

    // Attempt to call a non-inline function from inline context (should be compile error if uncommented)
    // public fun non_inline_call(): u16 {
    //     inline_only_func(5u16) // Correct as the function is inline
    //     // non_inline_func(10u16) // Error: non-inline function called from inline function
    // }

    // Test combined scenario: call functions with attributes, inline calls, nested calls
    public fun combined_test(): u16 {
        
//# attribute 0xBAD1::AttrModule
        let basic_call = f_add(2u8, 3u8); // Nested calls syntax rule
        let inlined = inline_test(); // Inline function call
        let nested = f_outer(1u8, 2u8, 3u8);
        inlined + basic_call + nested
    }
}


//# run 0xBAD1::SyntaxSemanticsTests::nested_calls_test


//# run 0xBAD1::SyntaxSemanticsTests::attribute_assignment_test


//# run 0xBAD1::SyntaxSemanticsTests::inline_test


//# run 0xBAD1::SyntaxSemanticsTests::combined_test


// Featurres:
// caec1675c076a2ccee1b7c91d7ddd101:  Call functions or constructors using parentheses '()' with call arguments after a name.
// 618ec165be600d3844d66fbef3466d89: Handle attributes with valid module identifiers or names, ensuring correct association of code locations with modules.
// 710936f97ac79b39c6dcbe50c215b94b: Design functions that call only inline functions to be targeted for inlining.
