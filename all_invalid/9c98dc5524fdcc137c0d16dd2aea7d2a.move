
//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // Internal function only accessible within this module
    fun internal_counter(x: u8): u8 {
        let count = x;
        let i = 0;
        while (i < 3) {
            let _shadow_var = count;
            count = count + 1;
            i = i + 1;
        };
        count
    }

    // Public function to invoke internal function, used in scripts
    public fun internal_invoker(s: signer, x: u8): u8 {
        internal_counter(x)
    }

    // Function demonstrating variable shadowing and loop variable assignment
    public fun loop_variable_shadowing(x: u8): u8 {
        let x = x; // shadowing parameter
        let i = 0;
        while (i < 4) {
            let _x = i; // shadowing outer x
            x = x + _x;
            i = i + 1;
        };
        x
    }

    // Function that performs nested loops with variable modifications
    public fun nested_loops(a: u8): u8 {
        let total = 0;
        let i = 0;
        while (i < 2) {
            let j = 0;
            while (j < 2) {
                total = total + a + i + j;
                j = j + 1;
            };
            i = i + 1;
        };
        total
    }
}


//# run 0xCAFE::TestModule::internal_invoker --signers 0xDEAD --args 5u8


//# run 0xCAFE::TestModule::loop_variable_shadowing --signers 0xDEAD --args 10u8


//# run 0xCAFE::TestModule::nested_loops --signers 0xDEAD --args 3u8


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
