//# publish
module 0xA550::TestUnsigned16 {
    // Helper function to check addition overflow
    public fun test_add(a: u16, b: u16): u16 {
        a + b
    }

    // Helper function to check subtraction (may panic on underflow)
    public fun test_sub(a: u16, b: u16): u16 {
        a - b
    }

    // Helper function to check multiplication (may panic on overflow)
    public fun test_mul(a: u16, b: u16): u16 {
        a * b
    }

    // Helper function to check division (panic if b == 0)
    public fun test_div(a: u16, b: u16): u16 {
        a / b
    }

    // Helper function to check modulus (panic if b == 0)
    public fun test_mod(a: u16, b: u16): u16 {
        a % b
    }
}

module 0xA550::TestStruct {
    // A simple struct with a mutable field
    resource struct Counter {
        value: u64,
    }

    // Initialize the counter resource
    public fun init_counter(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    // Repeatedly calls this function to mutate the counter and return current value
    public fun mutate_and_get(counter: &mut Counter, increment: u64): u64 {
        counter.value = counter.value + increment;
        counter.value
    }
}

module 0xA550::TestScripts {
    // Function with a valid name and body
    public fun valid_function(): bool {
        true
    }

    // Function attempting to call a private function from another module (should fail if not public)
    // Documentation purpose only; actual test in script
    public fun call_private(): bool {
        0xA550::TestUnsigned16::test_add(1, 2) == 3
    }
}

script //{
    //# run
    // Testing unsigned 16-bit integer arithmetic

    // Valid addition
    let sum = 0x1234 + 0x00FF; // 0x1234 + 0x00FF = 0x1333
    // Valid subtraction
    let diff = 0x1234 - 0x0010; // 0x1224
    // Valid multiplication
    let prod = 0x0010 * 0x0020; // 0x20 * 0x10 = 0x200
    // Valid division
    let quotient = 0x2000 / 0x0010; // 0x200
    // Valid modulus
    let rem = 0x1234 % 0x0100; // 0x34

    // Testing overflow: addition should panic or error if overflow occurred
    // (simulate by attempting an addition that overflows u16)
    // uncomment to test overflow behavior:
    // let overflow_add = 0xFFFF + 1; // should panic

    // Testing division by zero - should panic
    // uncomment to test:
    // let div_zero = 10 / 0;

    //# run 0xA550::TestStruct::Counter::init_counter --signers 0xA550
    //# run 0xA550::TestStruct::Counter::mutate_and_get --signers 0xA550 --args 5
    //# run 0xA550::TestStruct::Counter::mutate_and_get --signers 0xA550 --args 10

    // Use a local variable to hold counter
    let counter_ref = move {
        // Initialize counter resource
        // Assume account 0xA550 has a signer
        // Note: In actual test framework, the following will be run as scripts
        // For demonstration, focus on calls
        // Initialize counter
        // Setup counter resource
    };
} 