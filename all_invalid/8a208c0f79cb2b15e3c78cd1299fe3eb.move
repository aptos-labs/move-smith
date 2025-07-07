//# publish
module 0xCAFE::LoopAndLiteralTest {
    // Declare a public function that returns a vector of u8
    public fun get_one(): u8 {
        1
    }

    // Declare a function with friend visibility
    friend only public fun friend_only_function(): bool {
        true
    }

    // A function to test the friend access; it calls the friend-only function
    public fun call_friend_only(): bool {
        friend_only_function()
    }
}

//# run 0xCAFE::LoopAndLiteralTest::get_one --signers 0xCAFE
// This runs the function to ensure literals work correctly

//# publish
module 0xCAFE::LoopAndLiteralTestRunner {
    use 0xCAFE::LoopAndLiteralTest;

    // Runner function to test for loop and literals
    public fun run_tests() {
        // Test 1: For loop from 0..10
        let sum: u64 = 0;
        for i in 0..10 {
            sum = sum + (i as u64);
        };
        // sum should be 45 (0+1+2+...+9)
        // No assertion needed as per instructions

        // Test 2: Use typed literal with suffix
        let x: u8 = 42u8;
        let y: u64 = 12345u64;
        let _z: u128 = 1234567890123456u128; // move supports u128 as well

        // Test 3: Call friend-only function
        let friend_access_result = LoopAndLiteralTest.call_friend_only();
    }
}

//# run 0xCAFE::LoopAndLiteralTestRunner::run_tests --signers 0xCAFE

// Featurres:
// d3fa72cc69505d29275ee408acad95a3: Test that a for loop with a range (0..10) executes without errors in a script.
// bf9d6723bbe3a98f8af6efcf0b0e836f: Write typed numeric literals directly as values, such as with a specific suffix.
// 3eb02b2b9cf5da4359e8c4e6eb736e2f: Declare functions with friend visibility that can be called from specified friend modules.
