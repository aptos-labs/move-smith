//# publish
module unsigned_comparisons {
    public fun run_all() {
        // No-op function to allow external invocation if needed
    }
}

 //# run
script {
fun main() {
    // Testing -1 as unsigned should not compile, so we test only valid unsigned comparisons
    // Comparing u8 values
    assert!(0u8 == 0u8, 1000);
    assert!(1u8 != 2u8, 1001);
    assert!(0u8 < 1u8, 1002);
    assert!(1u8 > 0u8, 1003);
    assert!(0u8 <= 0u8, 1004);
    assert!(1u8 >= 1u8, 1005);
    assert!(!(1u8 < 0u8), 1100);
    assert!(!(0u8 > 1u8), 1101);
    assert!(!(0u8 >= 1u8), 1102);
    assert!(!(1u8 <= 0u8), 1103);

    // Testing u64
    assert!(0u64 == 0u64, 2000);
    assert!(12345u64 != 54321u64, 2001);
    assert!(1000000u64 < 2000000u64, 2002);
    assert!(3000000u64 > 1000000u64, 2003);
    assert!(0u64 <= 0u64, 2004);
    assert!(999999u64 >= 999999u64, 2005);
    assert!(!(1u64 < 0u64), 2100);
    assert!(!(0u64 > 1u64), 2101);
    assert!(!(0u64 >= 1u64), 2102);
    assert!(!(1u64 <= 0u64), 2103);

    // Testing u128
    assert!(0u128 == 0u128, 3000);
    assert!(999u128 != 1000u128, 3001);
    assert!(5000u128 < 10000u128, 3002);
    assert!(10000u128 > 5000u128, 3003);
    assert!(0u128 <= 0u128, 3004);
    assert!(123456789u128 >= 123456789u128, 3005);
    assert!(!(1u128 < 0u128), 3100);
    assert!(!(0u128 > 1u128), 3101);
    assert!(!(0u128 >= 1u128), 3102);
    assert!(!(1u128 <= 0u128), 3103);

    // Testing u16
    assert!(0u16 == 0u16, 4000);
    assert!(2u16 != 3u16, 4001);
    assert!(0u16 < 1u16, 4002);
    assert!(2u16 > 1u16, 4003);
    assert!(0u16 <= 0u16, 4004);
    assert!(5u16 >= 5u16, 4005);
    assert!(!(1u16 < 0u16), 4100);
    assert!(!(0u16 > 1u16), 4101);
    assert!(!(0u16 >= 1u16), 4102);
    assert!(!(1u16 <= 0u16), 4103);

    // Testing u32
    assert!(0u32 == 0u32, 5000);
    assert!(999u32 != 1000u32, 5001);
    assert!(1000u32 < 2000u32, 5002);
    assert!(3000u32 > 1000u32, 5003);
    assert!(0u32 <= 0u32, 5004);
    assert!(9999u32 >= 9999u32, 5005);
    assert!(!(1u32 < 0u32), 5100);
    assert!(!(0u32 > 1u32), 5101);
    assert!(!(0u32 >= 1u32), 5102);
    assert!(!(1u32 <= 0u32), 5103);

    // Testing u256 (assuming it's supported)
    // For demonstration, treat as large u128 (since Move might not support u256 natively)
    // or as a placeholder to indicate the test
    assert!(0u128 == 0u128, 6000);
    assert!(123456789u128 != 987654321u128, 6001);
    assert!(999999u128 < 1000000u128, 6002);
    assert!(1000000u128 > 999999u128, 6003);
    assert!(0u128 <= 0u128, 6004);
    assert!(123456789012345678u128 >= 123456789012345678u128, 6005);
    assert!(!(1u128 < 0u128), 6100);
    assert!(!(0u128 > 1u128), 6101);
    assert!(!(0u128 >= 1u128), 6102);
    assert!(!(1u128 <= 0u128), 6103);
}
}

//# run
script {
fun main() {
    // Testing for 'not equal' with boundary values
    assert!(0u8 != 1u8, 7000);
    assert!(255u8 != 0u8, 7001);
    assert!(65535u16 != 65534u16, 7002);
    assert!(4294967295u32 != 0u32, 7003);
    assert!(u128::MAX != 0u128, 7004);

    // Testing 'less than' on maximum values
    assert!(0u8 < 1u8, 7100);
    assert!(65535u16 < 65536u16, 7101);
    assert!(u128::MAX - 1 < u128::MAX, 7102);

    // Testing 'greater than' interactions
    assert!(2u8 > 1u8, 7200);
    assert!(70000u16 > 65535u16, 7201);
    assert!(u128::MAX > u128::MAX - 1, 7202);

    // Boundary checks for <= and >=
    assert!(0u8 <= 0u8, 7300);
    assert!(65535u16 >= 65535u16, 7301);
    assert!(u128::MAX >= u128::MAX, 7302);

    // Negative scenarios
    assert!(!(1u8 < 0u8), 7400);
    assert!(!(0u16 > 65535u16), 7401);
    assert!(!(u128::MAX < u128::MAX - 1), 7402);
}
}

//# run
script {
fun main() {
    // Confirm inequality with different types
    assert!(0u8 != 1u8, 8000);
    assert!(100u64 != 101u64, 8001);
    assert!(500u128 != 501u128, 8002);
    assert!(10u16 != 20u16, 8003);
    assert!(300u32 != 400u32, 8004);

    // Comparing same values with != should be false
    assert!(!(0u8 != 0u8), 8100);
    assert!(!(12345u64 != 12345u64), 8101);
    assert!(!(999u128 != 999u128), 8102);
    assert!(!(65535u16 != 65535u16), 8103);
    assert!(!(100u32 != 100u32), 8104);
}
}

//# run
script {
fun main() {
    // Cross-width comparisons should not compile, only test same-width
    // Inner logic to compare less than, greater than, equality
    assert!(0u8 < 1u8, 9000);
    assert!(255u8 > 254u8, 9001);
    assert!(100u16 >= 100u16, 9002);
    assert!(50u32 <= 100u32, 9003);
    assert!(u128::MAX > u128::MAX - 1, 9004);
}
}