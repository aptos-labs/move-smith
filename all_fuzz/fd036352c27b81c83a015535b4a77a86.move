
//# publish
module 0xCAFE::AddModule {
    public fun add_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 42) {
            100u8
        } else {
            sum
        }
    }

    public fun add_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_add(a: u16): (u16, u16) {
        (a + 10, a + 20)
    }
}


//# run 0xCAFE::AddModule::add_u8 --args 20u8 22u8


//# run 0xCAFE::AddModule::add_u8 --args 1u8 1u8


//# run 0xCAFE::AddModule::add_lambda --args 3u8 4u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public fun test_inline_call(x: u16): u16 {
        let (a, b) = AddModule::inline_add(x);
        a + b
    }
}


//# run 0xCAFE::NestedCallModule::test_inline_call --args 5u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
