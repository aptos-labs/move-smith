module 0x1::TestCompilerFeatures {

    struct S has copy, drop, store {
        x: u64,
        y: u64,
        z: u64,
    }

    /// Function to test parsing expressions that start with keywords:
    /// abort, break, continue, if, loop, return, while
    public fun test_keyword_expressions(addr: address): u64 {
        let mut sum = 0;

        // Test 'if' starting expression
        if (true) {
            sum = sum + 1;
        } else {
            abort 0;
        }

        // Test 'loop' with break and continue
        let mut i = 0;
        loop {
            i = i + 1;
            if (i == 5) {
                break;  // break expression
            };
            if (i % 2 == 0) {
                continue;  // continue expression
            };
            sum = sum + i;
        }

        // Test 'while'
        let mut j = 3;
        while (j > 0) {
            sum = sum + j;
            j = j - 1;
        }

        // Test 'return'
        if (sum > 0) {
            return sum;
        };

        // Never reached; abort as fallback
        abort 1;
    }

    /// Function to test struct pattern destructuring with local lets,
    /// variable renaming and reordering of fields
    public fun test_struct_pattern_destructuring() {
        let s = S { x: 10, y: 20, z: 30 };

        // Destructuring with renaming and reordering
        let S { y: b, x: a, z } = s;

        // Check values assigned correctly
        assert!(a == 10, 1);
        assert!(b == 20, 2);
        assert!(z == 30, 3);

        // Partial destructuring and renaming again
        let S { x: alpha, .. } = s;
        assert!(alpha == 10, 4);

        // Destructure with local variables without renaming
        let S { x, y, z } = s;
        assert!(x + y + z == 60, 5);
    }
}

address 0x2 {
    module 0x2::AddressBlockTest {
        /// Simple function to check that address block is declared correctly
        public fun test_address_block(): u8 {
            5
        }
    }
}

// Featurres:
// 3ea9a98833ee17472056eee13f00ea7c: Begin parsing expressions at keywords such as 'abort', 'break', 'continue', 'if', 'loop', 'return', and 'while'.
// 453f85e1e8934b0eb47d02c4140d0b7c: Test that struct pattern destructuring with local lets (including variable renaming and reordering of fields) correctly assigns values in Move functions.
// d3ce1d7e9ed24a62b04be31501fee6e6: Declare the 'address' keyword to initiate an address block.
