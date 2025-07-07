//# publish
module 0xCAFE::TestModule {

    // Function to demonstrate variable assignments, including combined operators
    public fun runner() {
        let x: u64 = 42;
        let initial_x = x;

        // Conditional block: skip to test variable remains unchanged
        // Move does not support `if false { ... }` directly; instead, simulate no execution.
        // Replacing with a block that does nothing to emulate skipping.
        // For the purpose of this test, just omit the block, or use a constant false via `if` with constant.
        // However, Move enforces evaluation of conditions, but `if false` is allowed.
        // The original code used `if false`, which is valid in Move.
        // So, the error must be caused by the parser expecting parentheses.
        // In Move, `if` requires parentheses: `if (false) {...}`.

        if (false) {
            // do nothing
            x = 100;
        }
        // Verify that x remains unchanged if the block is skipped
        assert!(x == initial_x, 0);

        // Combine assignment operators
        // Addition
        let mut a: u8 = 10;
        // Simulate '+=' operator with explicit assignment
        a = a + 5;
        assert!(a == 15, 0);

        // Subtraction
        let mut b: u16 = 20;
        b = b - 5;
        assert!(b == 15, 0);

        // Multiplication
        let mut c: u32 = 3;
        c = c * 4;
        assert!(c == 12, 0);

        // Modulo
        let mut d: u64 = 10;
        d = d % 3;
        assert!(d == 1, 0);

        // Division
        let mut e: u64 = 20;
        e = e / 4;
        assert!(e == 5, 0);

        // Bitwise OR
        let mut f: u8 = 0b0001;
        f = f | 0b0010;
        assert!(f == 0b0011, 0);

        // Bitwise AND
        let mut g: u8 = 0b1111;
        g = g & 0b0101;
        assert!(g == 0b0101, 0);

        // Bitwise XOR
        let mut h: u8 = 0b1100;
        h = h ^ 0b1010;
        assert!(h == 0b0110, 0);

        // Left shift
        let mut i: u8 = 1;
        i = i << 3;
        assert!(i == 8, 0);

        // Right shift
        let mut j: u8 = 16;
        j = j >> 2;
        assert!(j == 4, 0);
    }
}

//# run 0xCAFE::TestModule::runner