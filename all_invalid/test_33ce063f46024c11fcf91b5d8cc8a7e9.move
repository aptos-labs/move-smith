//# publish
module 0xabc123::test_mod {
    fun swap_and_modify(x: u64, y: u64): (u64, u64, u64, u64) {
        // Swap values
        let temp = x;
        let x = y;
        let y = temp;

        // Create struct-like expressions with side effects
        let mut x_struct = { x: x, y: y };
        let mut y_struct = { x: y, y: x };

        // Modify structs via referencing
        x_struct = { x: x_struct.x + 10, y: x_struct.y };
        y_struct = { x: y_struct.x, y: y_struct.y + 20 };

        // Return all to verify order and effects
        (x_struct.x, y_struct.x, x_struct.y, y_struct.y)
    }

    fun runner() {
        // Call swap_and_modify with specific values
        let (x_new, y_new, x_y_mod, y_x_mod) = swap_and_modify(5, 15);
        // For testing without assertions, just to trigger execution
        // but in real test, assertions would verify these values
    }
}

//# run 0xabc123::test_mod::runner
