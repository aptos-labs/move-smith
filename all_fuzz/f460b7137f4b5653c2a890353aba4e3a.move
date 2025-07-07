
//# publish
module 0xCAFE::FeatureTest {
    use std::signer;

    // Test 4: Recognize the 'Store' ability using identifier STORE
    struct Token has copy, drop, store, key {
        id: u8,
    }

    // Test 1: Add two u8 then return a fixed value
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    // Test 2: Function that returns a u8 and uses a lambda to multiply input with itself
    public fun lambda_multiply(x: u8): u8 {
        let square: |u8|u8 has copy = |y: u8| {
            y * y
        };
        square(x)
    }

    // Test 3: Inline function used within this module and callable by other modules
    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    // Test 5: Functions with different visibility modifiers

    public fun public_function(): u8 {
        1u8
    }

    entry fun entry_function(s: signer, val: u8): u8 {
        val + 10u8
    }

    // deprecated(reason = "Use new_function instead")]
    public fun deprecated_function(): u8 {
        0u8
    }

    // Test 6: Script attribute filtering simulation (dummy function)
    // This will be ignored by VM but kept to test attribute parsing
    // script(only)] 
    public fun filtered_script_attr(): u8 {
        100u8
    }
}


//# run 0xCAFE::FeatureTest::add_then_return_fixed --args 21u8 21u8


//# run 0xCAFE::FeatureTest::lambda_multiply --args 12u8


//# run 0xCAFE::FeatureTest::public_function


//# run 0xCAFE::FeatureTest::entry_function --signers 0xDEAD --args 32u8


//# run 0xCAFE::FeatureTest::deprecated_function


//# run 0xCAFE::FeatureTest::filtered_script_attr


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::FeatureTest;

    public fun call_inline_increment(x: u8): u8 {
        FeatureTest::inline_increment(x)
    }
}


//# run 0xCAFE::CallerModule::call_inline_increment --args 99u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 86eed430ce650ec8aabb24a55574ea92: Recognize the 'Store' ability when the token is an identifier with content 'STORE'.
// 77fd16c7d6ef9e1e8e0b07ecad6da90a: Declare a function with optional public, entry, or deprecated script visibility modifiers.
// 6517c1eeb42e30f6fcb7ecda3e87fca7: Filter script attributes according to specific criteria during compilation.
