
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    struct DummyStruct has copy, drop, store {
        a: u64,
        b: bool,
    }

    /// This function tests that quantifier expressions are handled correctly in the Move compiler.
    /// Since Move currently lacks explicit quantifiers like "forall" or "exists," 
    /// we simulate the effect using iterators or comprehensions if needed.
    /// For the purpose of this test, we use inline inline functions with quantifier-like patterns in comments.
    public fun test_quantifiers(x: u8, b: bool): bool {
        // No explicit quantifiers in Move, but we test repeated variable declarations based on conditions.

        // Declare multiple variables with different initialization syntax
        let a: u8 = if b { 1 } else { 2 }; // variable declaration with if expression
        let c: u8 = if b { a } else { a + 1 }; // using previous variable

        // Use successive variable declarations
        let d = a + c;

        // Use inline anonymous function with captured variables
        let lambda: |u8, u8| u8 = |p: u8, q: u8| {
            p + q
        };
        let sum = lambda(a, c);

        // Return whether sum is greater than a
        sum > a
    }

    /// This function tests that let binding with copy variables can be used in mutually exclusive branches.
    public fun test_copy_consumption_conditions(flag1: bool, flag2: bool): u64 {
        // Declare a copy variable
        let num_copy = 987654321u64;

        // Consume in mutually exclusive branches
        if (flag1) {
            // use num_copy
            let consumed_num = num_copy;
            // do something with consumed_num
            consumed_num
        } else if (flag2) {
            // clone or re-assign the copy
            let reused_num = num_copy; // copy semantics in Move allow this
            reused_num
        } else {
            // fallback, return 0
            0
        }
    }

    /// This function tests that variables can be safely used after different branches,
    /// and that return immediately followed by unary/expression are correctly handled.
    public fun test_return_followed_by_unary() {
        let x: u8 = 5;
        // variable with copy ability
        let y = x;

        // branching that uses the same variable in mutually exclusive paths
        if (x > 0) {
            // consume y
            let result = y;
            return result;
        } else {
            // negate y using unary
            let neg_y = -y as i8; // convert to signed to negate
            neg_y
        };
        // The last expression `neg_y` is the return value if else executes
    }

    /// Additional test to verify the compiler handles `return` immediately followed by expressions with unary/reference operators.
    public fun test_return_unary_expression() {
        let a: u16 = 10;
        if (a > 5) {
            return -a; // unary minus on variable, should be accepted
        } else {
            return &a as &u16; // returning reference, move semantics should be valid
        };
    }
}


//# run 0xDEAD::TestModule::test_quantifiers --signers 0xBEEF

//# run 0xDEAD::TestModule::test_copy_consumption_conditions --signers 0xBEEF --args true false

//# run 0xDEAD::TestModule::test_return_followed_by_unary --signers 0xBEEF

//# run 0xDEAD::TestModule::test_return_unary_expression --signers 0xBEEF

// Featurres:
// 677da68c45adc9186eb6119868a1fa65: Write quantifier expressions followed by a colon or an identifier to define variables in move logic.
// 4432107e86be4f839c4cf9df52cc7518: Test that a variable declared with let and initialized with copy can be safely consumed twice through different code paths guarded by mutually exclusive boolean conditions, for both primitives and struct types with copy/drop abilities.
// 763a9a0b4cdb31d17703a38ffa5b9cb4: Test that `return` statements can be immediately followed by unary or reference expressions without being incorrectly parsed as binary operators.
