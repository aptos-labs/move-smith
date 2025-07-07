//# publish
module 0x1::ConstantsTestModule {
    // This module is used for defining internal helper functions if needed in the future.
    // Currently, no functions are needed.
}

//# run
script {
    // Primitive constants
    const U8_CONST: u8 = 255;
    const U16_CONST: u16 = 65535;
    const U32_CONST: u32 = 4294967295;
    const U64_CONST: u64 = 9223372036854775807;
    const U128_CONST: u128 = 340282366920938463463374607431768211455;
    const U256_CONST: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    // Boolean constants
    const TRUE_CONST: bool = true;
    const FALSE_CONST: bool = false;

    // Address constant
    const ADDR_CONST: address = @0xDEADBEEF;

    // Byte vector constants
    const HEX_VECTOR: vector<u8> = x"deadbeef";
    const BYTES_VECTOR: vector<u8> = b"move";

    fun main() {
        // Test integer constants
        assert!(U8_CONST == 255, 10);
        assert!(U16_CONST == 65535, 11);
        assert!(U32_CONST == 4294967295, 12);
        assert!(U64_CONST == 9223372036854775807, 13);
        assert!(U128_CONST == 340282366920938463463374607431768211455, 14);
        assert!(U256_CONST == 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 15);

        // Test boolean constants
        assert!(TRUE_CONST == true, 16);
        assert!(FALSE_CONST == false, 17);

        // Test address constant
        assert!(ADDR_CONST == @0xDEADBEEF, 18);

        // Test byte vector constants
        assert!(HEX_VECTOR == x"deadbeef", 19);
        assert!(BYTES_VECTOR == b"move", 20);
    }
}

 //# run 0x1::ConstantsTestModule::main

//# publish
module 0x2::FunctionInteraction {
    // Inline function that calls passed functions with an argument and sums their results
    inline fun call_and_sum(f: |u64, u64| u64, g: |u64, u64| u64, arg: u64): u64 {
        f(arg, 10) + g(arg, 20)
    }

    // Runner function that tests different function references
    public fun test_functions(): u64 {
        // Function reference 1: adds its two arguments
        let add_fn = |x: u64, y: u64| { x + y };

        // Function reference 2: multiplies the first argument by 2 and second by 3, then sums
        let complex_fn = |x: u64, y: u64| { (x * 2) + (y * 3) };

        // Call inline function with these references
        call_and_sum(add_fn, complex_fn, 5)
    }

    // You may add more functions if needed
}

//# run 0x2::FunctionInteraction::test_functions