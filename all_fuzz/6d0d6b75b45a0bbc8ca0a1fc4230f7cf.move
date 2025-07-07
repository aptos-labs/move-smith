
//# publish
module 0xCAFE::MyModule {
    // Defines the function f2 that returns a tuple (u16, u16)
    // to be called from LambdaTest

    public inline fun f2(x: u16): (u16, u16) {
        (x + 1u16, x)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    // Test lambda and addition

    public fun add_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always end expressions with semicolon here
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            // Expressions must have parentheses if needed
            if (x == sum) {
                42u8
            } else {
                0u8
            }
        };
        lambda(sum)
    }

    public fun use_inline_function(x: u16): u16 {
        // Calling inline function defined below within same module to test nested call
        inline_increment(x)
    }

    public inline fun inline_increment(val: u16): u16 {
        val + 1u16
    }

    public fun use_inline_from_other_module(x: u16): u16 {
        // Calling inline function from 0xCAFE::MyModule
        let (incremented, _) = 0xCAFE::MyModule::f2(x);
        incremented
    }
}



//# run 0xCAFE::LambdaTest::add_u8_values --args 10u8 32u8



//# run 0xCAFE::LambdaTest::use_inline_function --args 100u16



//# run 0xCAFE::LambdaTest::use_inline_from_other_module --args 50u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
