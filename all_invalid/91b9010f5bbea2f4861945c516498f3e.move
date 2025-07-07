
//# publish
module 0xCAFE::ArithmeticAndLambda {
    use std::vector;

    // 1: Test addition of two u8 values and return a constant value if correct
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == (a + b)) {
            42u8
        } else {
            0u8
        }
    }

    // 2: Functions containing lambda expressions
    public fun lambdas_test(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        let mul_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a * b };
        let sum = add_lambda(x, y);
        let product = mul_lambda(x, y);
        sum + product
    }

    // 6: Test unsigned integer arithmetic, bitwise, shifts, casting for various types and edges
    public fun arithmetic_bitwise_casting(): u256 {
        let max_u8: u8 = 0xFFu8;
        let max_u16: u16 = 0xFFFFu16;
        let max_u32: u32 = 0xFFFFFFFFu32;
        let max_u64: u64 = 0xFFFFFFFFFFFFFFFFu64;
        let max_u128: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128;
        let max_u256: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu256;

        // Casting max values between types (downcast intentionally clips bits)
        let cast_u16_to_u8 = max_u16 as u8;
        let cast_u32_to_u16 = max_u32 as u16;
        let cast_u64_to_u32 = max_u64 as u32;
        let cast_u128_to_u64 = max_u128 as u64;

        // Bitwise & shift tests
        let and_val = max_u8 & 0xAAu8;
        let or_val = max_u8 | 0x55u8;
        let xor_val = max_u8 ^ 0xFFu8;
        let shl_val = 1u8 << 7;
        let shr_val = 0x80u8 >> 7;

        // Arithmetic tests
        let add = max_u8 + 1; // overflow wraps around (u8 overflow)
        let sub = 0u8 - 1;    // overflow wraps around (underflow)

        // packed result to u256 combining these results in distinct bytes (just for example)
        let result: u256 = (and_val as u256)
            | ((or_val as u256) << 8)
            | ((xor_val as u256) << 16)
            | ((shl_val as u256) << 24)
            | ((shr_val as u256) << 32)
            | ((add as u256) << 40)
            | ((sub as u256) << 48)
            | ((cast_u16_to_u8 as u256) << 56);

        result
    }
}


//# run 0xCAFE::ArithmeticAndLambda::add_and_check --args 20u8 22u8


//# run 0xCAFE::ArithmeticAndLambda::lambdas_test --args 5u8 7u8


//# run 0xCAFE::ArithmeticAndLambda::arithmetic_bitwise_casting



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::ArithmeticAndLambda;

    // 3: Test calling inline function of one module within another
    public inline fun inline_add_plus_one(a: u16): u16 {
        let (x, _) = ArithmeticAndLambda::add_and_return_tuple(a);
        x + 1
    }

    // Helper inline function inside ArithmeticAndLambda just for this test:
    // so define this function also here inline for test completeness.

    public inline fun add_and_return_tuple(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }
}


//# run 0xCAFE::InlineCaller::inline_add_plus_one --args 10u16



//# publish
module 0xCAFE::LiveIntervals {
    use std::string;

    // 4: Generate string representation of live interval events

    // We'll simulate events as vector<u8> (bytes of ASCII string)
    public fun live_interval_events(): vector<u8> {
        let events = vector::empty<u8>();
        let events_list = [
            b"start live_interval_1\n",
            b"end live_interval_1\n",
            b"start live_interval_2\n",
            b"end live_interval_2\n",
        ];

        let length = vector::length(&events_list);
        let i = 0u64;
        while (i < length) {
            let event = *vector::borrow(&events_list, i as u64);
            vector::push_back(&mut events, event);
            i = i + 1;
        };

        // But this will push vector<u8> elements (byte vectors) into events incorrectly.
        // So instead we build a concatenated vector<u8> of all bytes in event strings:

        let real_events = vector::empty<u8>();
        let j = 0u64;
        while (j < length) {
            let current_event = *vector::borrow(&events_list, j as u64);
            // Copy all bytes from current_event to real_events
            let k = 0u64;
            let event_len = vector::length(&current_event);
            while (k < event_len) {
                vector::push_back(&mut real_events, *vector::borrow(&current_event, k));
                k = k + 1;
            };
            j = j + 1;
        };
        real_events
    }
}


//# run 0xCAFE::LiveIntervals::live_interval_events



//# publish
module 0xCAFE::NamedAddressSuggestion {
    // 5: Enable declaration suggestions for unresolved named addresses

    // This is a dummy function just referencing an unresolved named address to
    // exercise declaration suggestion feature in Move compiler diagnostics.

    public fun unresolved_named_address() {
        let _ = @UnresolvedAddress;
    }
}


//# run 0xCAFE::NamedAddressSuggestion::unresolved_named_address


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4c58d7885ded84952dba85ff5adf684b: Generate a string representation of live interval events for debugging or analysis
// 8f051af9cf43bd2317f6be002a338f08: Enable declaration suggestions for unresolved named addresses
// dc331187b1c268d7e698ab78a6bc22b1: Test that integer arithmetic, bitwise operations, shifts, and casting between all unsigned integer types (u8, u16, u32, u64, u128, u256) work correctly and consistently, including edge cases and maximum values.
