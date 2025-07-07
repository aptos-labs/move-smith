
//# publish
module 0xCAFE::TestSuite {
    use std::assert;
    use std::signer;
    use std::vector;

    // Internal function to test access control
    // Only accessible within this module
    internal fun secret_function(): u8 {
        42
    }

    // Function to test variable assignment inside if without braces
    public fun assign_in_if(s: signer, flag: bool): u8 {
        if (flag)
            let val = 100u8;
        else
            let val = 200u8;
        // The variable 'val' is scoped within each branch
        // Return the value based on flag
        if (flag)
            val
        else
            val
    }

    // Function to test variable shadowing
    public fun shadow_variable(x: u8): u8 {
        let x = x + 1; // Shadow outer x
        let x = x * 2; // Shadow again
        x
    }

    // Function to test local variable manipulation
    public fun local_variable_test(): u64 {
        let counter = 0u64;
        while (counter < 3) {
            let counter = counter + 1; // Shadow inner counter
            // inner 'counter' shadowing outer one
        };
        // after loop, outer 'counter' remains
        counter
    }

    // Function to test internal access, called from outside but restricted
    public fun call_secret() : u8 {
        secret_function()
    }

    // Function to test variable scope within while loop
    public fun while_loop_scope(): u8 {
        let i = 0u8;
        while (i < 3) {
            let i = i + 1; // Shadow 'i'
        };
        // 'i' outside loop should be unchanged
        i
    }

    // Inline function that accepts a function parameter and calls it
    public fun invoke_function(f: |u8|u8, val: u8): u8 {
        f(val)
    }

    // Helper inline functions (closures)
    public fun double(x: u8): u8 {
        x * 2
    }

    public fun increment(x: u8): u8 {
        x + 1
    }

    // Generic struct with 'copy' bound
    struct CopyStruct<T: copy> has copy, drop {
        val: T
    }

    // Generic struct with 'drop' bound
    struct DropStruct<T: drop> has drop {
        val: T
    }

    // Function to instantiate CopyStruct
    public fun create_copy_struct<T: copy>(value: T): CopyStruct<T> {
        CopyStruct { val: value }
    }

    // Function to instantiate DropStruct
    public fun create_drop_struct<T: drop>(value: T): DropStruct<T> {
        DropStruct { val: value }
    }
}


//# run 0xCAFE::TestSuite::assign_in_if --args true

//# run 0xCAFE::TestSuite::assign_in_if --args false

//# run 0xCAFE::TestSuite::shadow_variable --args 10

//# run 0xCAFE::TestSuite::local_variable_test

//# run 0xCAFE::TestSuite::call_secret

//# run 0xCAFE::TestSuite::while_loop_scope

//# run 0xCAFE::TestSuite::invoke_function --args 0xCAFE::TestSuite::double --signers 0xCAFE --args 5

//# run 0xCAFE::TestSuite::invoke_function --args 0xCAFE::TestSuite::increment --signers 0xCAFE --args 7

//# run 0xCAFE::TestSuite::create_copy_struct --args 123u64

//# run 0xCAFE::TestSuite::create_drop_struct --args 0xCAFE::MyModule


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// e6f62292f061ed9f4a0d4c0378174232: Test that assigning a value to a variable inside an if statement without braces works correctly in a Move script.
// e962ae36f37285143dc6f6976c3acd76: Test that inline functions with function-typed parameters correctly accept and invoke closures as arguments.
// b6f59781a2434810c7c4757062670e46: Specify the constraints for struct type parameters using an ability set, such as copy or drop abilities.
