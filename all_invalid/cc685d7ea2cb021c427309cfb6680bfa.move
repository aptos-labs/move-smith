//# publish
module 0x1::NativeAndNonNativeFunctions {
    native public fun native_add(x: u64, y: u64): u64;

    public fun foo(p: u64, b: bool): u64 {
        // Both branches return p; tests will call with b=true and b=false
        if (b) {
            p
        } else {
            p
        }
    }

    public fun nested_loops_with_break(): u64 {
        let x = 0u64;
        let y = 0u8;
        let z = 0u8;

        // Outer loop
        let mut sum = 0u64;
        while (y < 3u8) {
            let mut w = 0u8;
            // Inner loop
            while (w < 5u8) {
                sum = sum + 1u64;
                if (w == 2u8) {
                    break;
                };
                w = w + 1u8;
            };
            y = y + 1u8;
        };
        sum // Outer loop runs 3 times, inner loop runs up to w==2, so sum = 3*3 = 9
    }

    public fun runner(): u64 {
        // Just expose nested_loops_with_break's result
        nested_loops_with_break()
    }
}

//# run 0x1::NativeAndNonNativeFunctions::foo --signers 0xA --args 42u64 true
//# run 0x1::NativeAndNonNativeFunctions::foo --signers 0xA --args 99u64 false
//# run 0x1::NativeAndNonNativeFunctions::runner --signers 0xA

//# run
script {
    use 0x1::NativeAndNonNativeFunctions;

    fun main() {
        let a = NativeAndNonNativeFunctions::foo(123u64, true);
        let b = NativeAndNonNativeFunctions::foo(500u64, false);
        let sum = NativeAndNonNativeFunctions::native_add(a, b);
        // No Move assertions needed; running sum will invoke the native and regular functions.
        let _x = NativeAndNonNativeFunctions::nested_loops_with_break();
    }
}