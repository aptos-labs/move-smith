//# publish
module 0xDEAD::TestModule {
    use std::vector;
    use std::marker;

    // Function to test early return when condition is true
    public fun early_return_test(flag: bool): bool {
        if (flag) {
            return true; // Explicitly return the value
        } else {
            // this should be skipped if flag is true
            assert!(false, 999);
            return false;
        }
    }

    // Inline function capturing and modifying external variable
    public fun inline_function_test(): u8 {
        let x = 10u8; // Make x mutable to modify it
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
        phantom: marker::PhantomData<T>,
    }

    // Function to create and return the struct
    public fun create_struct_with_phantom(): StructWithPhantom<bool> {
        let s = StructWithPhantom<bool> { data: 12345, phantom: marker::PhantomData };
        s
    }
}


//# run 0xDEAD::TestModule::early_return_test --args true


//# run 0xDEAD::TestModule::early_return_test --args false


//# run 0xDEAD::TestModule::inline_function_test


//# run 0xDEAD::TestModule::create_struct_with_phantom
