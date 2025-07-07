
//# publish
module 0xCAFE::MyModule {
    // Define the inline function f2 as expected
    // Returns a tuple (u16, u16)
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}


//# publish
module 0xCAFE::AdderModule {
    // Test feature 1: simple addition and return

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            100u8
        } else {
            sum
        }
    }

    // Test feature 2: function with lambda expressions
    public fun lambda_example(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let multiplier: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let total = adder(x, y) + multiplier(x, y);
        total
    }

    // Test feature 3: call inline function from another module
    // We reuse MyModule::f2 which is inline and returns a tuple (u16,u16).
    // This function returns the sum of the tuple elements.

    public fun call_inline_and_sum(a: u16): u16 {
        let (p, q) = 0xCAFE::MyModule::f2(a);
        p + q
    }
}



//# run 0xCAFE::AdderModule::add_and_return --args 5u8 6u8



//# run 0xCAFE::AdderModule::add_and_return --args 3u8 4u8



//# run 0xCAFE::AdderModule::lambda_example --args 2u8 3u8



//# run 0xCAFE::AdderModule::call_inline_and_sum --args 10u16



//# publish
module 0xCAFE::BytecodeCleaner {
    // Test feature 4: remove leading label simulation
    // Since Move source can't manipulate bytecode labels explicitly,
    // emulate the process by rearranging a vector (simulating bytecode instructions)
    // Remove the first element considered as a "label"

    use std::vector;

    public fun remove_leading_label(instructions: vector<u8>): vector<u8> {
        let len = vector::length(&instructions);
        if (len == 0) {
            instructions
        } else {
            let result = vector::empty<u8>();
            let i = 1;
            while (i < len) {
                vector::push_back(&mut result, *vector::borrow(&instructions, i));
                i = i + 1;
            };
            result
        }
    }

    // Runner to test
    public fun test_clean() {
        let instrs = vector[99u8, 1u8, 2u8, 3u8, 4u8];
        let _cleaned = remove_leading_label(instrs);
    }
}



//# run 0xCAFE::BytecodeCleaner::test_clean


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 0c5654bd569406574cefb2f5df29c13d: Remove the leading label from a sequence of bytecode instructions to clean up or prepare code for further processing.
