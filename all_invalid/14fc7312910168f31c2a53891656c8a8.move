
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // Function to test early return when condition is true
    public fun early_return_test(flag: bool): bool {
        if (flag) {
            true
        } else {
            // this should be skipped if flag is true
            assert!(false, 999);
            false
        }
    }

    // Inline function capturing and modifying external variable
    public fun inline_function_test() {
        let x = 10u8;
        let lambda: |u8| u8 = |a: u8| {
            // Inside lambda, modify outer variable
            x = x + a;
            x
        };
        let result = lambda(5);
        result
    }

    // Struct with phantom type parameter
    struct StructWithPhantom<T> has copy, drop, store {
        data: u64,
        phantom: std::marker::PhantomData<T>,
    }

    // Function to create and return the struct
    public fun create_struct_with_phantom(): StructWithPhantom<bool> {
        let s = StructWithPhantom<bool> { data: 12345, phantom: std::marker::PhantomData };
        s
    }
}


//# run 0xDEAD::TestModule::early_return_test --args true

//# run 0xDEAD::TestModule::early_return_test --args false


//# run 0xDEAD::TestModule::inline_function_test


//# run 0xDEAD::TestModule::create_struct_with_phantom


// Featurres:
// d24423718daed51dcda59d04ee963c94: Test that the script correctly returns early when the condition is true and does not execute the assertion or cause a failure.
// 206ebfe6b421d8dcf6d3ea42bdb5b167: Test that the inline function correctly captures and modifies the local variable `x` when called within the `test` function.
// 47683053c10f197cf3a788b32aeb628c: Mark struct type parameters as phantom using the 'phantom' keyword in struct definitions
