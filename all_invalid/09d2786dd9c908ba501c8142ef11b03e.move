//# publish
module 0xA550C0DE::test_arithmetic {
    // Public function to perform arithmetic operations and return results as tuple
    public fun perform_operations(a: u16, b: u16): (u16, u16, u16, u16, u16) {
        let add = a + b;
        let sub = a - b;
        let mul = a * b;
        let div = if (b != 0) { a / b } else { 0 }; // handle division by zero externally
        let rem = if (b != 0) { a % b } else { 0 };
        (add, sub, mul, div, rem)
    }
}

//# run 0xA550C0DE::test_arithmetic::perform_operations --args 100u16 25u16

//# publish
module 0xA550C0DE::test_arithmetic_overflow {
    // Functions to test overflows, expected to abort on overflow
    public fun test_add_overflow(a: u16, b: u16): u16 acquires {
        // This will abort if overflow occurs
        a + b
    }

    public fun test_sub_overflow(a: u16, b: u16): u16 acquires {
        a - b
    }

    public fun test_mul_overflow(a: u16, b: u16): u16 acquires {
        a * b
    }
}

//# run 0xA550C0DE::test_arithmetic_overflow::test_add_overflow --args 65535u16 1u16
//# run 0xA550C0DE::test_arithmetic_overflow::test_sub_overflow --args 0u16 1u16
//# run 0xA550C0DE::test_arithmetic_overflow::test_mul_overflow --args 256u16 256u16

//# publish
module 0xA550C0DE::test_division_zero {
    public fun safe_divide(a: u16, b: u16): u16 {
        if (b == 0) {
            abort 1;
        }
        a / b
    }

    public fun safe_modulus(a: u16, b: u16): u16 {
        if (b == 0) {
            abort 1;
        }
        a % b
    }
}

//# run 0xA550C0DE::test_division_zero::safe_divide --args 100u16 0u16
//# run 0xA550C0DE::test_division_zero::safe_modulus --args 50u16 0u16

//# publish
module 0xA550C0DE::test_mutable_struct {
    resource struct Counter {
        count: u64,
    }

    public fun init_counter(account: &signer) {
        move_to(account, Counter { count: 0 });
    }

    // Mutable function that increments counter and returns the new value
    public fun increment_and_get(counter_ref: &mut Counter): u64 {
        counter_ref.count = counter_ref.count + 1;
        counter_ref.count
    }

    // Runner that calls the mutable function repeatedly
    public fun run_repeated_increments(account: &signer, times: u64): vector<u64> acquires Counter {
        let mut results = vector::empty<u64>();
        let counter_ref = borrow_global_mut<Counter>(  // borrow mutable globally
            move_from(account)); // move from account, then re-publish
        let mut i = 0;
        while (i < times) {
            let val = increment_and_get(&mut counter_ref);
            vector::push_back(&mut results, val);
            i = i + 1;
        }
        results
    }
}

//# run 0xA550C0DE::test_mutable_struct::init_counter --signers 0x1 --args 
//# run 0xA550C0DE::test_mutable_struct::run_repeated_increments --signers 0x1 --args 10u64

//# publish
script {
    // Valid function declaration with a script
    public fun valid_script_function() {
        // do nothing
    }
}
//# run 0xA550C0DE::valid_script_function