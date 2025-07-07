
//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // Internal function only accessible within this module
    fun internal_counter(x: u8): u8 {
        let count = x; // Changed to 'mut' for mutation
        let i = 0;     // Changed to 'mut' for mutation
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
        let x = x; // shadowing parameter, 'mut' needed for mutation
        let i = 0; // 'mut' for mutation
        while (i < 4) {
            let _x = i; // shadowing outer x
            x = x + _x;
            i = i + 1;
        };
        x
    }

    // Function that performs nested loops with variable modifications
    public fun nested_loops(a: u8): u8 {
        let total = 0; // 'mut' for mutation
        let i = 0; // 'mut' for mutation
        while (i < 2) {
            let j = 0; // 'mut' for mutation
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
