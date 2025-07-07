//# publish
module 0xBEEF::TestModule {
    use std::vector;

    
//# run 0xBEEF::TestModule::test_expression_list_destructure_move
    public fun test_expression_list_destructure_move() {
        // List multiple expressions in a single expression list
        let _ = (1u8, 2u8, 3u8);

        // Destructure tuple returned by a function
        let (a, b) = Self::return_two_u16();
        // Declare new variable and move from expression
        let c = a;
        // Copy value (u8 has copy)
        let d = b;

        // Call a function that returns a tuple and destructure
        let (x, y) = Self::get_u32_and_u64();
        
        // Use move from
        let e = copy x;
        // Use move directly from destructured variable
        let f = move y;

        // Declare variables with move and copy
        let g = copy 42u8;
        let h = copy 99u8;
    }

    fun return_two_u16(): (u16, u16) {
        (10u16, 20u16)
    }

    fun get_u32_and_u64(): (u32, u64) {
        (1234u32, 5678u64)
    }
}
