//# publish
module 0xCAFE::SpecMergeTest {

    use std::vector;
    use std::debug;

    // Define a struct with abilities copy, drop, store, key so it can be used in global storage
    struct Value has copy, drop, store, key {
        val: u64,
    }

    // Public function to create and return a Value
    public fun new_value(v: u64): Value {
        Value { val: v }
    }

    // Function demonstrating nested blocks assigning to the same local variable name `x`.
    // Expect that inner blocks can reuse outer variable names independently.
    public fun nested_scopes(): u64 {
        let x = 1u64;
        {
            // inner block 1 re-assigning to x (new local)
            let x = 2u64;
            // use x here
            debug::print(&vector::empty<u8>()); // dummy use of import
        }
        {
            // inner block 2 with same variable name
            let x = 3u64;
            // use x here
        }
        // after inner blocks, x still refers to the outer x
        x
    }

    // Runner function to test nested scopes behavior that can be called without args
    public fun runner(): u64 {
        nested_scopes()
    }
}
//# run 0xCAFE::SpecMergeTest::runner

//# publish
spec module 0xCAFE::SpecMergeTest {

    // Spec for new_value function
    spec fun new_value(v: u64) {}

    // Spec for nested_scopes function verifies variable assignment pattern
    spec fun nested_scopes(): u64;
}