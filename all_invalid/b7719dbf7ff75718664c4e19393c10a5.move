
//# publish
module 0xCAFE::TestCopyAndDrop {
    use std::vector;
    use 0xCAFE::MyModule;

    // A struct with copy and drop abilities
    struct MyStruct has copy, drop {
        id: u64,
        name: vector<u8>,
    }

    public fun test_copy_disposal() {
        let bool_flag: bool = true;

        // Declare a variable with copy
        let primitive_var: u64 = 42;

        // Declare a struct with copy
        let struct_var: MyStruct = MyStruct {id: 1, name: b"test".to_vector()};

        // Consume the copy-valued variable in code path if boolean is true
        if (bool_flag) {
            let _ = primitive_var;
            let _ = struct_var;
        } else {
            // Consume the copy-valued variable in alternative path
            let _ = primitive_var;
            let _ = struct_var;
        };

        // Optional: declare a second copy variable and consume separately
        let copy_primitive: u64 = primitive_var;
        let copy_struct: MyStruct = struct_var;

        if (bool_flag) {
            let _ = copy_primitive;
            let _ = copy_struct;
        } else {
            let _ = copy_primitive;
            let _ = copy_struct;
        };
    }

    // Function parameter with a function type returning a non-function type should be disallowed unless version >= 2.2.
    // Since we are testing features, declare a function with such a parameter and verify compiler rejection as needed.
    // Here, we define a function with a valid param type (primitive) and an invalid one (function returning function).
    public fun accept_valid(func: |u64|: u64): u64 {
        func(10)
    }

    // -- This part tests disallowance: typically, a compiler will reject functions with such parameters.
    // We can include a dummy invalid function for illustration, but in the test we expect compilation error.
    // The invalid code is commented out because it should trigger compiler error.
    /*
    public fun accept_invalid(func_param: |() -> u64|): u64 {
        func_param()
    }
    */

    // Helper function to be passed
    public fun simple_func(x: u64): u64 {
        x + 1
    }

    // Runner function to test
    public fun run_tests() {
        // test copy/dispose logic
        test_copy_disposal();

        // test accepting valid function parameter
        let result = accept_valid(simple_func);
        // result should be 11
    }
}


//# run 0xCAFE::TestCopyAndDrop::run_tests --signers 0xABC

// Featurres:
// 4432107e86be4f839c4cf9df52cc7518: Test that a variable declared with let and initialized with copy can be safely consumed twice through different code paths guarded by mutually exclusive boolean conditions, for both primitives and struct types with copy/drop abilities.
// 5a69b2aba949320a696d079c8b92242d: Disallow parameters that are function types where the function results are function-typed, unless the language version is at least 2.2.
// 5f5b25bcf39841044531a49f33dde23d: Reference functions or features from certain modules (e.g., 'vector') and have the compiler automatically maintain the dependency for you
