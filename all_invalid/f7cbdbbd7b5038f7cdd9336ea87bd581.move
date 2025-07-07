
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
        if (flag) {
            let val = 100u8;
            val
        } else {
            let val = 200u8;
            val
        }
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
            let counter = counter + 1; // Shadow inner 'counter'
            // inner 'counter' shadowing outer one
        }
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
        }
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


//# run 0xCAFE::TestSuite::invoke_function --type-args 0xCAFE::TestSuite::double --args 5 --signers 0xCAFE


//# run 0xCAFE::TestSuite::invoke_function --type-args 0xCAFE::TestSuite::increment --args 7 --signers 0xCAFE


//# run 0xCAFE::TestSuite::create_copy_struct --args 123u64


//# run 0xCAFE::TestSuite::create_drop_struct --args 0xCAFE::MyModule
