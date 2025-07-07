// # publish
module 0xCAFE::U8Arithmetic {

    // A resource to hold some u8 value for testing
    struct ValueHolder has key {
        val: u8,
    }

    public fun add(a: u8, b: u8): u8 {
        // addition, should overflow trap if overflow
        a + b
    }

    public fun sub(a: u8, b: u8): u8 {
        // subtraction, should underflow trap if underflow
        a - b
    }

    public fun mul(a: u8, b: u8): u8 {
        // multiplication, should trap on overflow
        a * b
    }

    public fun div(a: u8, b: u8): u8 {
        // division, should trap on division by zero
        a / b
    }

    public fun modulo(a: u8, b: u8): u8 {
        // modulo, should trap on modulo zero
        a % b
    }

    // A runner function to execute safe operations without args or signers
    public fun runner(): u64 {
        // Use some valid operations, result returned as u64 for visibility
        let sum = add(10, 20); // 30u8
        let difference = sub(50, 10); // 40u8
        let product = mul(5, 5); // 25u8
        let quotient = div(100, 10); // 10u8
        let remainder = modulo(101, 10); // 1u8

        // return sum of all results cast to u64 (30+40+25+10+1=106)
        (sum as u64) + (difference as u64) + (product as u64) + (quotient as u64) + (remainder as u64)
    }
}
// # run 0xCAFE::U8Arithmetic::runner

// # run 0xCAFE::U8Arithmetic::add --args 255u8 1u8 --signers 0xCAFE
script 0xCAFE::TestOverflowAdd {
    fun main(s: &signer) {
        // Attempt to add 255 + 1 which should overflow and trap
        let _ = 0xCAFE::U8Arithmetic::add(255, 1);
    }
}

// # run 0xCAFE::U8Arithmetic::sub --args 0u8 1u8 --signers 0xCAFE
script 0xCAFE::TestUnderflowSub {
    fun main(s: &signer) {
        // Attempt to subtract 1 from 0 which should underflow and trap
        let _ = 0xCAFE::U8Arithmetic::sub(0, 1);
    }
}

// # run 0xCAFE::U8Arithmetic::mul --args 16u8 16u8 --signers 0xCAFE
script 0xCAFE::TestOverflowMul {
    fun main(s: &signer) {
        // 16 * 16 = 256 which overflows u8 and should trap
        let _ = 0xCAFE::U8Arithmetic::mul(16, 16);
    }
}

// # run 0xCAFE::U8Arithmetic::div --args 10u8 0u8 --signers 0xCAFE
script 0xCAFE::TestDivByZero {
    fun main(s: &signer) {
        // division by zero trap expected
        let _ = 0xCAFE::U8Arithmetic::div(10, 0);
    }
}

// # run 0xCAFE::U8Arithmetic::modulo --args 10u8 0u8 --signers 0xCAFE
script 0xCAFE::TestModByZero {
    fun main(s: &signer) {
        // modulo by zero trap expected
        let _ = 0xCAFE::U8Arithmetic::modulo(10, 0);
    }
}

// Featurres:
// 7514c082c12802d1b2c66dd2beca8046: Test that unsigned 8-bit integer arithmetic operations (addition, subtraction, multiplication, division, and modulus) behave correctly within their valid ranges and properly fail or trap on invalid operations such as overflow, underflow, or division/modulus by zero.
// 9def49343c650663209a2268dd6c0e84: Define Move modules to encapsulate related code and resources.
// cfc6e5dd0739dddf7d49b3e71561b42e: Use u64 literal attribute values that are within the u64 range
