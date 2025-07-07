
//# publish
module 0xCAFE::TestSuite {
    use std::vector;
    use std::string;
    use std::error;

    // Utility to format logs
    public fun format_log(message: &vector<u8>): vector<u8> {
        // Prepend "[LOG]" to message
        let prefix = b"[LOG] ";
        let formatted = vector::empty<u8>();
        vector::append(&mut formatted, prefix);
        vector::append(&mut formatted, message);
        formatted
    }

    // Function to test log formatting
    public fun test_log_format() {
        let msg = b"Test message";
        let formatted = format_log(&msg);
        // Emulate checking output (here, just ignore)
        // The last expression is formatted
        formatted
    }

    // Simulate invoking impure functions (spec calls) which should produce errors
    public fun call_impure_spec(): () {
        // Let's simulate a spec violation with a dummy error
        let _ = error::abort_code(0x1);
    }

    // Function to test spec calls error message
    public fun test_spec_call_error() {
        call_impure_spec()
        // The function will abort; in test, expect diagnostic
    }

    // Functions to test unsigned integer operations
    public fun test_u8_operations() {
        let a: u8 = 0b1010_1010;
        let shift_left = a << 2;
        let shift_right = a >> 1;
        let addition = a + 5;
        let subtraction = a - 3;
        let bitwise_and = a & 0xFF;
        let bitwise_or = a | 0x01;
        let bitwise_xor = a ^ 0xFF;
        let division = a / 2;
        let modulo = a % 3;
        let cast_to_u16 = a as u16;
        (shift_left, shift_right, addition, subtraction, bitwise_and, bitwise_or, bitwise_xor, division, modulo, cast_to_u16)
    }

    public fun test_u16_operations() {
        let a: u16 = 0xAAAA;
        let shift_left = a << 4;
        let shift_right = a >> 2;
        let addition = a + 0x1111;
        let subtraction = a - 0x1111;
        let bitwise_and = a & 0xFFFF;
        let bitwise_or = a | 0x0001;
        let bitwise_xor = a ^ 0xFFFF;
        let division = a / 3;
        let modulo = a % 5;
        let cast_to_u32 = a as u32;
        (shift_left, shift_right, addition, subtraction, bitwise_and, bitwise_or, bitwise_xor, division, modulo, cast_to_u32)
    }

    public fun test_u32_operations() {
        let a: u32 = 0xDEADBEEF;
        let shift_left = a << 8;
        let shift_right = a >> 16;
        let addition = a + 0x11111111;
        let subtraction = a - 0x11111111;
        let bitwise_and = a & 0xFFFFFFFF;
        let bitwise_or = a | 0x00000001;
        let bitwise_xor = a ^ 0xFFFFFFFF;
        let division = a / 2;
        let modulo = a % 7;
        let cast_to_u64 = a as u64;
        (shift_left, shift_right, addition, subtraction, bitwise_and, bitwise_or, bitwise_xor, division, modulo, cast_to_u64)
    }

    public fun test_u64_operations() {
        let a: u64 = 0x123456789ABCDEF0;
        let shift_left = a << 12;
        let shift_right = a >> 20;
        let addition = a + 0x1111111111111111;
        let subtraction = a - 0x1111111111111111;
        let bitwise_and = a & 0xFFFFFFFFFFFFFFFF;
        let bitwise_or = a | 0x0000000000000001;
        let bitwise_xor = a ^ 0xFFFFFFFFFFFFFFFF;
        let division = a / 3;
        let modulo = a % 9;
        let cast_to_u128 = a as u128;
        (shift_left, shift_right, addition, subtraction, bitwise_and, bitwise_or, bitwise_xor, division, modulo, cast_to_u128)
    }

    public fun test_u128_operations() {
        let a: u128 = 0xFEDCBA9876543210FEDCBA9876543210;
        let shift_left = a << 16;
        let shift_right = a >> 24;
        let addition = a + 0x11111111111111111111111111111111;
        let subtraction = a - 0x11111111111111111111111111111111;
        let bitwise_and = a & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        let bitwise_or = a | 0x00000000000000000000000000000001;
        let bitwise_xor = a ^ 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        let division = a / 4;
        let modulo = a % 11;
        a
    }

    // Native support with generics, simulate via inline functions
    // Native functions with generics, assume they exist and behave correctly
    // For the test, define mock native functions
    public fun native_generic_function<T: copy + drop>(value: T): T {
        // Mimic native behavior
        value
    }

    // Test calling native functions with different types
    public fun test_native_generic() {
        let a_u8: u8 = 255;
        let res_u8 = native_generic_function<u8>(a_u8);

        let a_u16: u16 = 65535;
        let res_u16 = native_generic_function<u16>(a_u16);

        let a_u32: u32 = 0xFFFFFFFF;
        let res_u32 = native_generic_function<u32>(a_u32);

        let a_u64: u64 = 0xFFFFFFFFFFFFFFFF;
        let res_u64 = native_generic_function<u64>(a_u64);

        let a_u128: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        let res_u128 = native_generic_function<u128>(a_u128);

        (res_u8, res_u16, res_u32, res_u64, res_u128)
    }

    // Main test invocation function - no args
    public fun run_tests() {
        // Test log formatting
        let _formatted_log = test_log_format();

        // Test error message for impure spec call
        // Note: This will abort, in real test environment, capture diagnostics
        // call_spec_call_error();

        // Test unsigned integer operations
        let (a8, b8, c8, d8, e8, f8, g8, h8, i8, j8) = test_u8_operations();
        let (a16, b16, c16, d16, e16, f16, g16, h16, i16, j16) = test_u16_operations();
        let (a32, b32, c32, d32, e32, f32, g32, h32, i32, j32) = test_u32_operations();
        let (a64, b64, c64, d64, e64, f64, g64, h64, i64, j64) = test_u64_operations();
        let _ = test_u128_operations();

        // Call native generic functions
        let _ = test_native_generic();
    }
}


//# run 0xCAFE::TestSuite::run_tests


// Featurres:
// 0b856599ec9c299441989b28ef36e705: Format log records using a custom record formatting function.
// 834db50012e317ce95b4a6e911c524dd: Receive detailed error messages when a specification expression calls an impure Move function.
// 3bc88f08da8c1fc1b775406d9d65238d: Test that various integer operations—shifts, division, modulo, addition, subtraction, type casting, bitwise AND, OR, XOR—produce the expected results for different unsigned integer types in Move.
// 3ce7f9ec7dcf0f463d7ee246609ec231: Define named native functions with custom type parameters for generics.
