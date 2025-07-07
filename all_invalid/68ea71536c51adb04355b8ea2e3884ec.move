//# publish
module 0xCAFE::TestModule {

    // Function to demonstrate variable assignments, including combined operators
    public fun runner() {
        let x: u64 = 42;
        let initial_x = x;

        // Conditional block: skip to test variable remains unchanged
        if false {
            x = 100;
        }
        // Verify that x remains unchanged if the block is skipped
        assert!(x == initial_x, 0); // Should pass because block is skipped

        // Combine assignment operators
        // Addition
        let a: u8 = 10;
        a >== 5; // Although Move doesn't have '+=' operator, simulate with a = a + 5;
        a = a + 5;
        assert!(a == 15, 0);

        // Subtraction
        let b: u16 = 20;
        b -= 5;
        b = b - 5;
        assert!(b == 10, 0);

        // Multiplication
        let c: u32 = 3;
        c *= 4;
        c = c * 4;
        assert!(c == 48, 0);

        // Modulo
        let d: u64 = 10;
        d %= 3;
        d = d % 3;
        assert!(d == 1, 0);

        // Division
        let e: u64 = 20;
        e /= 4;
        e = e / 4;
        assert!(e == 5, 0);

        // Bitwise OR
        let f: u8 = 0b0001;
        f |= 0b0010;
        f = f | 0b0010;
        assert!(f == 0b0011, 0);

        // Bitwise AND
        let g: u8 = 0b1111;
        g &= 0b0101;
        g = g & 0b0101;
        assert!(g == 0b0101, 0);

        // Bitwise XOR
        let h: u8 = 0b1100;
        h ^= 0b1010;
        h = h ^ 0b1010;
        assert!(h == 0b0110, 0);

        // Left shift
        let i: u8 = 1;
        i <<= 3;
        i = i << 3;
        assert!(i == 16, 0);

        // Right shift
        let j: u8 = 16;
        j >>= 2;
        j = j >> 2;
        assert!(j == 4, 0);
    }
}

//# run 0xCAFE::TestModule::runner

// Featurres:
// cff3dd41dce0fdf717f0f7fe905177e7: Verify that the Move script correctly leaves variables unchanged and that the assertion properly detects the initial value of `x` when the conditional block is skipped.
// 3df0ef442032dba0d5e22544d91c02b8: Use combined assignment operators such as +=, -=, *=, %=, /=, |=, &=, ^=, <<=, >>= in Move code.
// 68ae2f5b9f9a5852aa1233765397d347: Define modules at the root of a package.
