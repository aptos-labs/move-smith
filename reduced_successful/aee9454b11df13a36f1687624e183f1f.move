
//# publish
module 0xCAFE::AdditionModule {
    // This module tests addition of two u8 values and returns a specific value.
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always return 42 after computing sum
        42
    }

    fun private_helper(x: u8): u8 {
        // Private helper to be tested for module-level privacy (cannot be called externally)
        x * 2
    }

    public fun public_caller(x: u8): u8 {
        // Calls private_helper internally
        private_helper(x)
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::AdditionModule::public_caller --args 15u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    // Call an inline function within AdditionModule via a public wrapper here to test nested calls

    public inline fun no_arg_inline_function(): u16 {
        100u16
    }

    public fun call_inline_function_and_add(x: u8, y: u8): u8 {
        // use AdditionModule::add_and_return_sum to add x and y but ignore result
        let _ = AdditionModule::add_and_return_sum(x, y);

        // call this module's inline function and cast to u8 then return
        let val: u8 = no_arg_inline_function() as u8;
        val
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_function_and_add --args 5u8 6u8


//# publish
module 0xCAFE::StructInitModule {
    struct MyStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun create_and_sum_fields(x: u8, y: u8): u8 {
        let s = MyStruct {
            a: x + 1,
            b: y + 2,
        };
        let MyStruct {a, b} = s;
        a + b
    }
}


//# run 0xCAFE::StructInitModule::create_and_sum_fields --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 6671883b5bb4d8b099e86b2d8f615f3b: Enforce module-level privacy for functions within a module
// a68db4fdbfc3a4cda1b4e974ef8912ce: Test that the Move module correctly initializes a struct with nested expressions and correctly destructures it to sum its fields.
