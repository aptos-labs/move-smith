
//# publish
module 0xCAFE::LvalueDestructuring {
    use std::vector;

    public fun test_destructuring() {
        let (a, b, c) = (1u8, 2u8, 3u8);
        // Destructuring a tuple into variables
        let (x, y) = (a + 1, b + 2);
        // Assigning destructured values to a struct
        let s = S { x: x as u32, y: y as u32 };

        // Replace nested destructuring with sequential destructuring
        let m = 4u16;
        let (n, o) = (5u16, 6u16);

        // Use destructuring to assign multiple variables
        let (d1, d2, d3) = (7u32, 8u32, 9u32);
    }

    public fun test_dead_code_in_conditional() {
        let i = 0u8;
        while (i < 5) {
            // The 'if' with dead code in 'else' branch after break
            if (i == 2) {
                break;
            } else {
                // This branch is dead when i==2, but should not affect execution
                i = i + 1;
            }
        }

        let flag = true;

        // Conditional with dead code after break
        let _ = if (flag) {
            let _ = true;
        } else {
            // Dead code: loop with break
            loop {
                break;
            }
        };
    }

    public fun test_pragma_properties() {
        // Assign boolean to pragma property
        let p_bool: bool = true;

        // Assign numeric values
        let p_u8: u8 = 255;
        let p_u16: u16 = 65535;

        // Assign byte string literals
        let p_bytes: vector<u8> = b"TestBytes";

        // Assign identifier (simulate with boolean for the purposes of test)
        let p_id: bool = false;
    }

    struct S has copy, drop {
        x: u32,
        y: u32,
    }
}



//# run 0xCAFE::LvalueDestructuring::test_destructuring



//# run 0xCAFE::LvalueDestructuring::test_dead_code_in_conditional



//# run 0xCAFE::LvalueDestructuring::test_pragma_properties