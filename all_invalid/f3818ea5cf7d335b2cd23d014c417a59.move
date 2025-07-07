
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::vector;

    const INTERNAL_CONST: u8 = 42;

    // Internal function not exposed outside
    fun internal_increment(x: u8): u8 {
        x + 1
    }

    // Internal function with loops and local variables
    fun internal_loop_example(limit: u8): u8 {
        let count = 0;
        let i = 0;

        // for loop simulation
        while (i < limit) {
            let inner_x = i; // Shadow variable
            count = count + inner_x;
            i = i + 1;
        };

        count
    }

    // Entry point script function to test module invocation
    public fun script_entry(x: u8): u8 {
        internal_increment(x)
    }

    // Entry point that calls internal loop example
    public fun script_loop_entry(limit: u8): u8 {
        internal_loop_example(limit)
    }

    // A function with variable shadowing within a block
    public fun shadowing_example(): u8 {
        let value = 10;
        if (value > 5) {
            let value = 20; // shadow outer 'value'
            value
        } else {
            value
        }
    }

    // Internal function with nested loops for test
    fun internal_nested_loop(x: u8): u8 {
        let sum = 0;
        let j = 0;

        while (j < x) {
            let k = 0;
            while (k < 2) {
                sum = sum + k;
                k = k + 1;
            };
            j = j + 1;
        };
        sum
    }

    // Public function calling internal_nested_loop
    public fun call_internal_nested(x: u8): u8 {
        internal_nested_loop(x)
    }

    // Function attempting external access to internal, should be compile-time error
    // pub fun unauthorized_access() {
    //     let _ = internal_increment(5); // should fail if uncommented
    // }
}


//# run 0xCAFE::TestModule::script_entry --args 10u8

//# run 0xCAFE::TestModule::script_loop_entry --args 5u8

//# run 0xCAFE::TestModule::shadowing_example

//# run 0xCAFE::TestModule::call_internal_nested --args 3u8

// External code attempting to access internal functions should result in compile-time errors.
// The below commented code demonstrates attempting to call internal functions from outside,
// which should not compile if uncommented, confirming proper visibility restrictions.

// # outside script that should fail to compile
// 
//# run 0xCAFE::TestModule::internal_increment --args 5u8   // Should error: 'internal_increment' is internal
// 
//# run 0xCAFE::TestModule::internal_loop_example --args 5u8 // Should error


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
