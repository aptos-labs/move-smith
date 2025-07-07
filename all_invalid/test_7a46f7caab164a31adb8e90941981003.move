//# publish
module 0x123::UInt16ArithmeticTests {
    use std::error::Error;

    /// Helper function to trigger overflow on addition (expect failure)
    public fun test_add_overflow() {
        // This function is a placeholder to invoke overflow
        // Actual overflow induces a runtime error
        // e.g., 65535u16 + 1u16 should fail
    }

    /// Helper function to trigger overflow on multiplication
    public fun test_mul_overflow() {
        // Attempt multiplication overflow
    }

    /// Helper function to trigger overflow on subtraction (should not overflow in normal case)
    public fun test_sub_underflow() {
        // Attempt subtraction that underflows
    }
}

//# run
script {
    fun main() {
        // Valid addition cases
        assert!(0u16 + 0u16 == 0u16, 1000);
        assert!(0u16 + 65535u16 == 65535u16, 1001);
        assert!(123u16 + 456u16 == 579u16, 1002);

        // Should fail: addition overflow
        // 65535 + 1 => overflow
        // Expected to abort or error
        65535u16 + 1u16;
    }
}

//# run
script {
    fun main() {
        // Valid subtraction
        assert!(100u16 - 50u16 == 50u16, 2000);
        assert!(65535u16 - 65534u16 == 1u16, 2001);
        assert!(5000u16 - 4999u16 == 1u16, 2002);
        
        // Should fail: subtraction underflow
        // 0 - 1
        0u16 - 1u16;
    }
}

//# run
script {
    fun main() {
        // Valid multiplication
        assert!(0u16 * 0u16 == 0u16, 3000);
        assert!(1u16 * 65535u16 == 65535u16, 3001);
        assert!(2u16 * 32767u16 == 65534u16, 3002);
        
        // Should fail: multiplication overflow
        // 65535 * 2
        65535u16 * 2u16;
    }
}

//# run
script {
    fun main() {
        // Valid division
        assert!(65535u16 / 1u16 == 65535u16, 4000);
        assert!(65535u16 / 65535u16 == 1u16, 4001);
        assert!(100u16 / 2u16 == 50u16, 4002);
        
        // Should fail: division by zero
        100u16 / 0u16;
    }
}

//# run
script {
    fun main() {
        // Valid modulus
        assert!(65535u16 % 1u16 == 0u16, 5000);
        assert!(65535u16 % 65535u16 == 0u16, 5001);
        assert!(100u16 % 3u16 == 1u16, 5002);
        
        // Should fail: modulus by zero
        123u16 % 0u16;
    }
}