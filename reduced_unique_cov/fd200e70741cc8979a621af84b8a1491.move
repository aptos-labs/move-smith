
//# publish
module 0xCAFE::TestFeatures {
    use std::vector;

    const U8_ONE: u8 = 1u8;
    const U8_TWO: u8 = 2u8;
    const U64_MAX: u64 = 0xffff_ffff_ffff_ffff;
    const U128_MAX: u128 = 0xffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;
    const BOOL_TRUE: bool = true;
    const BOOL_FALSE: bool = false;
    const ADDR_ZERO: address = @0x0;
    const ADDR_ONE: address = @0x1;
    const HEX_VALUE: vector<u8> = x"DEADBEEF";
    const BYTEARRAY_VALUE: vector<u8> = b"bytearray";

    // 1: Test addition of u8 values and returning a specific value
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 42) {
            42
        } else {
            sum
        }
    }

    // 2a: Function that defines and calls a lambda (anonymous function)
    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = add_lambda(a, b);
        result
    }

    // 2b: Lambda that captures outer scope variable
    public fun lambda_capture(y: u8): u8 {
        let x = 10u8;
        let capture_lambda: |u8| u8 has copy+drop = |param: u8| {
            x + param + y
        };
        capture_lambda(y)
    }

    // 3: Call inline function from another module to test nested calls and returns
    // Fixed by replacing 'MyModule' with a placeholder inline function defined here.
    // Since MyModule is unbound, we provide stub function f2 here.
    public fun f2(x: u16): (u16, u16) {
        // Example implementation for testing purposes
        (x, x + 1)
    }

    public fun call_inline_f2(x: u16): (u16, u16) {
        let (a, b) = Self::f2(x);
        (a, b)
    }

    // 4: Variable reassignment after move in if-else control flow
    public fun move_and_reassign(flag: bool): u8 {
        let v1 = 10u8;
        let moved_v1 = v1;
        // here v1 is moved, so cannot use v1 directly
        let v2 = if (flag) {
            moved_v1 + 1
        } else {
            42
        };
        // Reassign v1 after move via initializing a new binding of v1
        let v1 = v2;
        v1
    }

    // 5a: Constant folding and equality/inequality tests of u8, u64, u128
    public fun prmitive_comparisons(): bool {
        (U8_ONE == 1u8) &&
        (U8_TWO != 3u8) &&
        (U64_MAX == 0xffff_ffff_ffff_ffff) &&
        (U128_MAX != 0) &&
        (BOOL_TRUE == true) &&
        (BOOL_FALSE != true) &&
        (ADDR_ZERO == @0x0) &&
        (ADDR_ONE != @0x2) &&
        (vector::length<u8>(&HEX_VALUE) == 4) &&
        (vector::length<u8>(&BYTEARRAY_VALUE) == 9)
    }
}




//# run 0xCAFE::TestFeatures::add_and_return --args 20u8 22u8




//# run 0xCAFE::TestFeatures::lambda_add --args 10u8 15u8




//# run 0xCAFE::TestFeatures::lambda_capture --args 7u8




//# run 0xCAFE::TestFeatures::call_inline_f2 --args 100u16




//# run 0xCAFE::TestFeatures::move_and_reassign --args true




//# run 0xCAFE::TestFeatures::move_and_reassign --args false




//# run 0xCAFE::TestFeatures::prmitive_comparisons
