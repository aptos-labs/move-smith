//# publish
module 0xCAFE::FunctionAndLoopTest {
    // Test 1: Function definitions with naming, visibility and entry modifier

    // A public function without entry
    public fun public_fun(x: u8): u8 {
        x + 1
    }

    // A public entry function
    public entry fun entry_fun(s: signer, val: u8): u8 {
        val * 2
    }

    // An internal function
    fun internal_fun(x: u16): u16 {
        x + 100
    }

    // Test 2: Use constructor function to mimic access specifiers (simulate private data)
    struct PrivateData has store {
        secret: u64,
    }

    // Constructor function for PrivateData
    fun new_private_data(secret: u64): PrivateData {
        PrivateData { secret }
    }

    // Public accessor function
    public fun get_secret(data: &PrivateData): u64 {
        data.secret
    }

    // Test 3: Loop with immediate break should run without error
    public fun loop_with_immediate_break(): u8 {
        let mut counter = 0u8;
        loop {
            break;
            counter = counter + 1;
        };
        counter
    }
}

//# run 0xCAFE::FunctionAndLoopTest::public_fun --args 10u8

//# run 0xCAFE::FunctionAndLoopTest::entry_fun --signers 0xBEEFBEEF --args 20u8

//# run 0xCAFE::FunctionAndLoopTest::get_secret --args 123456u64

//# run 0xCAFE::FunctionAndLoopTest::loop_with_immediate_break

// Featurres:
// 6316d8fa2d30e15c3c8423f8853e1553: Create function definitions with correct naming, visibility, and optional 'entry' modifier.
// 47d4ca81c3e1568d734b223e6ca2faf1: Use the constructor function to create specific types of access specifiers during parsing.
// bf3251b5a7b15e7299a545b81e9edd51: Test that a loop with an immediate break statement executes without errors.
