//# publish
module 0xabc::casting_tests {
    // Function to attempt cast and return a bool indicating success or failure
    public fun try_cast_to_u8(value: u64): bool {
        // Try-cast and handle failure
        // Since Move does not have try-catch, simulate by manually checking range
        if (value <= 255) {
            let _ = value as u8; // Successful cast
            true
        } else {
            false
        }
    }

    public fun try_cast_to_u16(value: u64): bool {
        if (value <= 65535) {
            let _ = value as u16;
            true
        } else {
            false
        }
    }

    public fun try_cast_to_u32(value: u64): bool {
        if (value <= 4294967295) {
            let _ = value as u32;
            true
        } else {
            false
        }
    }

    public fun try_cast_to_u64(value: u128): bool {
        if (value <= 18446744073709551615) {
            let _ = value as u64;
            true
        } else {
            false
        }
    }

    // Inline function demonstrating variable reassignment and multiple return
    inline fun sum_and_upper_bound(x: u64, y: u64): (u64, bool) {
        let sum = x + y;
        // Check if sum fits into u32
        (sum, sum <= 4294967295)
    }

    // Function to test handling large values and variable bindings
    public fun test_var_bindings(): (u64, bool) {
        let large_value = 18446744073709551615u128; // max u128
        let cast_success = if (large_value <= 18446744073709551615u128) {
            let _ = large_value as u64;
            true
        } else {
            false
        };
        (large_value as u64, cast_success)
    }
}

//# run 0xabc::casting_tests::test_try_casts
script {
fun main() {
    // Test safe castings (within range)
    assert!(try_cast_to_u8(255), 1000);
    assert!(try_cast_to_u16(65535), 1001);
    assert!(try_cast_to_u32(4294967295), 1002);

    // Test unsafe castings (overflow)
    assert!(!try_cast_to_u8(256), 1100);
    assert!(!try_cast_to_u16(70000), 1101);
    assert!(!try_cast_to_u32(5000000000), 1102);

    // Casting large u128 to u64
    let max_u128 = 18446744073709551615u128;
    // Should succeed
    let _val: u64 = max_u128 as u64;
    assert!(_val == 18446744073709551615u64, 1200);

    // Overflow case: larger u128
    let overflow_value = 18446744073709551616u128; // one more than max
    // Should fail, simulate by range check
    let result = if (overflow_value <= 18446744073709551615u128) {
        Some(overflow_value as u64)
    } else {
        None
    };
    assert!(result.is_none(), 1201);

    // Test inline function with variable mutation
    let (sum, within_limit) = sum_and_upper_bound(1000, 2000);
    assert!(sum == 3000 && !within_limit, 1300);

    let (big_sum, within_limit2) = sum_and_upper_bound(4000000000, 500000000);
    assert!(big_sum == 4500000000 && within_limit2, 1301);

    // Test variable binding and multiple return
    let (value, success) = test_var_bindings();
    assert!(value == 18446744073709551615u64 && success, 1400);
}
}

//# run 0xabc::casting_tests::test_var_bindings