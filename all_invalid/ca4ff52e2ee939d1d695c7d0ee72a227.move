
//# publish
module 0xCAFE::FeatureTestModule {
    use std::vector;
    use std::signer;

    // Defines a simple module with functions to test call expressions
    public fun simple_add(a: u64, b: u64): u64 {
        a + b
    }

    public fun call_in_scheme(a: u64, b: u64): u64 {
        // Call the simple_add function using call expression
        call simple_add(a, b)
    }
}


//# run 0xCAFE::FeatureTestModule::simple_add --args 10u64 20u64


//# run 0xCAFE::FeatureTestModule::call_in_scheme --args 15u64 25u64



//# publish
module 0xCAFE::ConditionalAssignment {
    // Function that assigns a value based on a condition and returns it
    public fun assign_in_if_else(cond: bool, x: u32, y: u32): u32 {
        let result: u32;
        if (cond) {
            result = x;
        } else {
            result = y;
        };
        result
    }
}


//# run 0xCAFE::ConditionalAssignment::assign_in_if_else --args true 42u32 99u32


//# run 0xCAFE::ConditionalAssignment::assign_in_if_else --args false 42u32 99u32

// Featurres:
// 136168fd43b03e5103901de66b029b08: Define modules using the 'module' or 'spec' keywords in Move files.
// 8fe5fef24c0e585a801639f4602b3ed1: Test that the Move script correctly assigns a value to a variable within an if-else conditional and returns the assigned value.
// 957f4ac0040e1148684d1fb2cc2c2abb: Call functions and methods using the `call` expression, specifying the function name, call kind, optional type arguments, and argument list.
