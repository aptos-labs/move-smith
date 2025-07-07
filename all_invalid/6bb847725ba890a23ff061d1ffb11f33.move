// # publish
module 0xCAFE::SpecMergeTest {

    use std::vector;

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
// # run 0xCAFE::SpecMergeTest::runner

// # publish
module 0xCAFE::SpecMergeTest {

/*
  Spec block merged into the implementation module below.
  This tests the merge of specification into the target module.
  The spec block can refer to public functions and types.
  This block is a dummy spec that refers to `new_value` and `nested_scopes`.
  The spec does not implement real formal verification but tests the compiler's handling
  of spec blocks merged into the module and how the compiled bytecode gets attached after compilation.
*/

spec module 0xCAFE::SpecMergeTest {

    // Spec for new_value function
    spec fun new_value(v: u64) {}

    // Spec for nested_scopes function verifies variable assignment pattern
    spec fun nested_scopes(): u64;
}

}

// Featurres:
// 01a43e94f76e7d519185aeeff2c06acb: Merge specification modules into target modules to associate specifications with implementations.
// fda188fe1ba52851ff503c9efdd2a9d9: Attach the generated compiled bytecode directly to the analysis model after successful compilation.
// 17e3833c6ca38c51a0d77586ece9db2c: Test that nested code blocks within a function can assign to and use the same local variable in independent block scopes.
