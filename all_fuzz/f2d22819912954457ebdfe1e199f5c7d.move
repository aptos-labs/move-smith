
//# publish
module 0xCAFE::MyModule {
    /// Inline function f2 takes a u16 value and returns a tuple (u16, u16).
    public inline fun f2(value: u16): (u16, u16) {
        (value, value + 1)
    }
}


//# publish
module 0xCAFE::LambdaTest {
    // Removed unused use std::signer;

    // Test function to add two u8 and return 42 if the sum is 42, else return sum
    public fun add_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 42) {
            42
        } else {
            sum
        }
    }

    // Function containing a lambda expression that multiplies two u8 and returns the result
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let multiplier: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x * y
        };
        multiplier(a, b)
    }

    // Function that calls the inline function f2 from 0xCAFE::MyModule, extracts fields, and returns their sum as u32
    public fun nested_inline_call(value: u16): u32 {
        let (x, y) = 0xCAFE::MyModule::f2(value);
        (x as u32) + (y as u32)
    }

    // Dummy verify_script to simulate verification of a script before deployment
    // In real Move, verify_script is not a function but for testing assume this function verifies code correctness
    public fun verify_script(_code: vector<u8>): bool {
        // Always return true for the purpose of this test
        true
    }

    // Runner function that exercises above functions
    public fun runner() {
        let _ = add_check(20u8, 22u8);
        let _ = multiply_lambda(6u8, 7u8);
        let _ = nested_inline_call(10u16);

        let dummy_script: vector<u8> = b"example_script_code";
        let _ = verify_script(dummy_script);
    }
}



//# run 0xCAFE::LambdaTest::add_check --args 40u8 2u8



//# run 0xCAFE::LambdaTest::multiply_lambda --args 6u8 7u8



//# run 0xCAFE::LambdaTest::nested_inline_call --args 10u16



//# run 0xCAFE::LambdaTest::verify_script --args  x"6578616d706c655f7363726970745f636f6465"



//# run 0xCAFE::LambdaTest::runner
