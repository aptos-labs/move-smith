// Feature 1: Only Accessible Functions in Inline Functions

//# publish
module 0x1::AccessTest {
    // Private function, not accessible outside this module
    fun private_func(): u8 {
        1
    }

    // Public function
    public fun public_func(): u8 {
        private_func()
    }

    // Inline function calling public_func() (OK)
    public fun inline_fn(): u8 {
        public_func()
    }

    // "Runner" - safe to call from script
    public fun run() {
        let _x = inline_fn();
    }
}
//# run 0x1::AccessTest::run --signers 0x1

// Feature 2: Token Types After Commas in Access Specifiers + nested blocks

//# publish
address 0xABCD {
module TokenAccess {
    // public(friend) token, identifier after comma
    public(friend, TokenAccess) fun friend_func(): u64 { 10 }
    // public(script) token, star after comma
    public(script, *) fun script_func(): u64 { 20 }
    // public(token) token, numeric value after comma (not allowed in access specifiers, but tests numeric parsing)
    // (This line would not compile in current Move, but let's try an identifier and a * as required.)
    // We will instead use a mix of public access specifiers and call to test parser robustness.

    // Nested braces and complex blocks
    public fun block_fn(): u64 {
        let x = {
            let inner = {
                let a = 5;
                a + 3
            };
            inner * 2
        };
        x + friend_func() + script_func()
    }

    // "Runner" for testing block & access combinations
    public fun run() {
        let val = block_fn();
        spec {
            // spec block inside function to exercise nested braces and parsing
            let _s = 100;
        }
    }
}
}
//# run 0xABCD::TokenAccess::run --signers 0xABCD

// Feature 3: Script block, nested sequences, blocks, spec

//# run
script {
    fun main(s: signer) {
        let a = 7;
        let b = {
            let c = {
                let d = 2;
                spec {
                    // spec block in nested braces
                    let _spec_val = d;
                }
                d + 5
            };
            c * 3
        };
        let _ = a + b;
    }
}
