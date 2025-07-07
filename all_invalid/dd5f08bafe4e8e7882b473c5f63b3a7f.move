
//# publish
module 0xCAF0::TestModule {
    use std::signer;
    use std::vector;

    // Internal function, should not be callable from outside
    fun internal_func(): u8 {
        42
    }

    public fun call_internal_from_script(): u8 {
        internal_func()
    }

    // Spec function with pre and post conditions for validation
    public fun spec_func(x: u64): u64
        ensures result == x + 1
        requires x < 100
    {
        x + 1
    }

    // Variable handling with nested blocks
    public fun variable_shadowing(): u64 {
        let x = 10u64;
        {
            let x = 20u64; // shadows outer x
            let y = x + 5; // y = 25
            y // last expression
        }
        + x // outer x + last block result = 10 + 25 = 35
    }

    // Function with loop and variable updates
    public fun loop_variable_update(): u64 {
        let sum = 0u64; // Note: mutable local vars are not allowed directly, but simulate via loop
        let i = 0u64;
        while(i < 5) {
            sum = sum + i;
            i = i + 1;
        };
        sum // return sum = 0+1+2+3+4=10
    }

    // Function with nested blocks and assignments, verifying order
    public fun nested_blocks_assignments(): u64 {
        let a = 1u64;
        {
            let b = 2u64;
            {
                let c = 3u64;
                c + b + a // 3 + 2 + 1 = 6
            }
        }
    }

    // Function with break and continue simulation (using loop + break)
    public fun break_in_loop(target: u64): u64 {
        let res = 0u64;
        let i = 0u64;
        loop {
            if (i == target) {
                res = i;
                break;
            };
            i = i + 1;
        };
        res
    }

    // Test that calling external functions is restricted
    public fun try_call_private(): u8 {
        // Should not be able to call internal_func() from outside
        // But since within same module, it works, this is just to test visibility
        internal_func()
    }
}


//# run 0xCAF0::TestModule::call_internal_from_script


//# run 0xCAF0::TestModule::spec_func --args 50u64


//# run 0xCAF0::TestModule::variable_shadowing


//# run 0xCAF0::TestModule::loop_variable_update


//# run 0xCAF0::TestModule::nested_blocks_assignments


//# run 0xCAF0::TestModule::break_in_loop --args 3u64


//# run 0xCAF0::TestModule::try_call_private


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 86f8adf1e0f084864bf8f1a02cbe9d90: Test that variable assignments and returns within code blocks are evaluated in the correct order and that control flow behaves as expected within expression blocks.
// 78b50b09721fe7e731c9a18c29a2bb99: Write inline specifications within Move functions to specify behavior.
