//# publish
module 0x1::NestedBlockTest {
    /// This function tests nested block expressions with variable assignments and arithmetic calculations.
    public fun test_nested_blocks(): u64 {
        let x = 10;
        let y = {
            let a = x + 5;
            let b = {
                let c = a * 2;
                c + 3
            };
            b * 2
        };
        y + 1
    }

    /// This function will be called to test partial AST simplification (simulated).
    /// It uses basic arithmetic, hoping the AST_SIMPLIFY experiment deals fine with it.
    public fun test_ast_simplify(): u64 {
        let x = 1 + 2;
        let y = x * 3;
        y + 4
    }

    /// This function takes a parameter by reference, copies it, and returns the copy.
    public fun test_ref_copy(x: &u64): u64 {
        let copy = *x; // dereference to copy the value
        copy + 1
    }

    /// Runner calls the above functions to enable testing.
    public fun runner(): u64 {
        // sum all three test functions
        let a = test_nested_blocks();
        let b = test_ast_simplify();
        let c = {
            let val = 42u64;
            test_ref_copy(&val)
        };
        a + b + c
    }
}
//# run 0x1::NestedBlockTest::runner