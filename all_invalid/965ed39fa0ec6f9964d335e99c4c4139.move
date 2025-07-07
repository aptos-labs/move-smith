
//# publish
module 0xCAFE::Fibonacci {
    // Recursive Fibonacci function
    public fun fib(n: u8): u64 {
        if (n == 0) {
            0u64
        } else {
            if (n == 1) {
                1u64
            } else {
                fib(n - 1u8) + fib(n - 2u8)
            };
        }
    }

    public fun test_fib_0_to_10() {
        let _f0 = fib(0u8);
        let _f1 = fib(1u8);
        let _f2 = fib(2u8);
        let _f3 = fib(3u8);
        let _f4 = fib(4u8);
        let _f5 = fib(5u8);
        let _f6 = fib(6u8);
        let _f7 = fib(7u8);
        let _f8 = fib(8u8);
        let _f9 = fib(9u8);
        let _f10 = fib(10u8);
    }

    public fun use_hex_byte_string() {
        let hex_bytes: vector<u8> = x"01020304AABBCCDD";
        // Use cast/annotate expressions with sub-expressions and types
        let x = (3u8 as u64) + ( ( (1u8 + 2u8) as u64));
        let _y = (x as u8);
    }
}


//# run 0xCAFE::Fibonacci::test_fib_0_to_10


//# run 0xCAFE::Fibonacci::use_hex_byte_string


// Featurres:
// f146d93ffacc97d7479017453a43f502: Test the recursive Fibonacci function implementation and ensure it correctly computes Fibonacci numbers for inputs from 0 to 10.
// aa5d07c7f63825c1fedcba9b5f82c282: Write hexadecimal byte string literals using x"..." syntax in your Move code
// 6f8dd25f8a7d8da62724449569e19dd6: Create cast or annotate expressions with sub-expressions and types.
