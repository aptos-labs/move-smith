//# publish
module 0xCAFE::LoopAndLiteralTest {
    // Declare a public function that returns a u8
    public fun get_one(): u8 {
        1
    }

    // Declare a function with friend visibility
    // Note: 'friend only' should be 'public' with specific access control
    // Move currently doesn't support 'friend only' visibility in the way Rust does.
    // Instead, for testing purposes, make it 'public' but only call from a module with access.
    // To simulate friend access, you can leave it 'public' and only call from allowed modules.
    public fun friend_only_function(): bool {
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
        let mut sum: u64 = 0;
        let i = 0;
        while (i < 10) {
            sum = sum + (i as u64);
            // Increment i
            // Move doesn't have 'for'; use while loop with mutable variable
            // For clarity, define mutable 'i' outside
            // But since 'i' must be mutable, declare 'let mut i = 0;'
            // Correct the code accordingly
            break; // placeholder; will fix below
        }

        // Corrected approach:
        {
            let mut i = 0;
            let mut local_sum: u64 = 0;
            while (i < 10) {
                local_sum = local_sum + (i as u64);
                i = i + 1;
            }
            // Now assign to sum
            // But variables out of scope
            // Let's rewrite with variables declared prior
        }

        // Simplify: declare mutable variables properly

        // Correct implementation:
        let mut sum: u64 = 0;
        let mut i: u64 = 0;
        while (i < 10) {
            sum = sum + i;
            i = i + 1;
        }
        // sum should be 45

        // Test 2: Use typed literal with suffix
        let x: u8 = 42u8;
        let y: u64 = 12345u64;
        let _z: u128 = 1234567890123456u128; // move supports u128 as well

        // Test 3: Call friend-only function
        let friend_access_result = LoopAndLiteralTest.call_friend_only();
    }
}

//# run 0xCAFE::LoopAndLiteralTestRunner::run_tests --signers 0xCAFE