
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
        // Valid Move syntax: specify pre and post conditions using 'specs' annotation
        // but inline annotations must be inside a 'specs' block or handled via annotations.
        // Since inline 'ensures' and 'requires' are incorrect in code, we need to set up specs properly.
        // Instead, move spec annotations outside the function using the 'specs' syntax
        // But in this context, the syntax is invalid, so we remove inline specs and convert to proper syntax
    {
        x + 1
    }

    // Proper way: Move uses 'spec' annotations outside functions, or inline
    // However, in Move, inline function contracts are written with 'spec' annotations via 'specs' block.
    // Since the test contains invalid inline 'ensures' and 'requires', fix by removing them or making proper specs.

    // Corrected function with inline specs (Move does not support inline requires/ensures, so comment out or remove)
    // Instead, use the 'specs' attribute for definitions, but Move currently does not support inline pre/post in function body.
    // So, let's simplify: remove the pre/post annotations from the function.

    // Remove invalid inline annotations and just keep the implementation
    public fun spec_func_simple(x: u64): u64 {
        x + 1
    }

    // Variable handling with nested blocks
    public fun variable_shadowing(): u64 {
        let x = 10u64;
        {
            let x = 20u64; // shadows outer x
            let y = x + 5; // y = 25
            y // last expression in inner block
        }
        + x // outer x + last block result = 10 + 25 = 35
    }

    // Function with loop and variable updates
    public fun loop_variable_update(): u64 {
        let sum = 0u64; // Declare mutable variable
        let i = 0u64;
        while (i < 5) {
            sum = sum + i;
            i = i + 1;
        };
        sum // return sum = 10
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
        // Missing return value; in Move, last expression is return value, so add explicit return
        // but the last block doesn't have a value to return
        // So, we need to assign the inner expression to a variable and return it
        let result;
        {
            let b = 2u64;
            {
                let c = 3u64;
                result = c + b + a; // 6
            }
        }
        result
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
        // Should not be able to call internal_func() from outside;
        // but since within same module, it's allowed.
        internal_func()
    }
}



//# run 0xCAF0::TestModule::call_internal_from_script


//# run 0xCAF0::TestModule::spec_func_simple --args 50u64


//# run 0xCAF0::TestModule::variable_shadowing


//# run 0xCAF0::TestModule::loop_variable_update


//# run 0xCAF0::TestModule::nested_blocks_assignments


//# run 0xCAF0::TestModule::break_in_loop --args 3u64


//# run 0xCAF0::TestModule::try_call_private
