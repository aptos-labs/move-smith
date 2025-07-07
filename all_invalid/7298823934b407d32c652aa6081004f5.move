
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


//# run 0xBEEF::TestModule::test_expression_list_destructure_move


// Featurres:
// 2235658ff2cf510854ab0cd8af9f181c: List multiple expressions in a single expression list context.
// fd5e5aee0e1fe660bee184852c41b5dd: Destructure tuples or multiple return values into multiple variables in a single let statement.
// 64240e4f41dc8af5ad2114a4b4df7c34: Declare variables and move values using the `Copy` and `Move` expressions.
