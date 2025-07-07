module 0x1::transactional_test {

    use std::signer;
    use std::assert;

    /// A simple resource representing a token with a value
    struct Token has store {
        value: u64,
    }

    /// A struct with combined abilities: copy + store + drop
    // This tests using multiple abilities combined via '+'
    struct ComplexAbilitiesType has copy + store + drop {
        data: u8,
    }

    /// Creates a Token resource with an initial value under the given signer
    public fun create_token(account: &signer, initial_value: u64) {
        let token = Token { value: initial_value };
        move_to(account, token);
    }

    /// Reads the token value via a reader reference (&Token)
    public fun read_token_value(token_ref: &Token): u64 {
        token_ref.value
    }

    /// Updates the token value via a mutable writer reference (&mut Token)
    public fun update_token_value(token_ref: &mut Token, new_value: u64) {
        token_ref.value = new_value;
    }

    #[test]
    public fun test_token_lifecycle() {
        // Create a signer for the test
        let signer = @0x1;

        // 1. Create the token with initial value 100
        create_token(&signer, 100);

        // Borrow immutable reference (reader)
        let token_ref = borrow_global<Token>(signer);

        // Assert the token value is 100
        let val = read_token_value(token_ref);
        assert::assert(val == 100, 1001);

        // Borrow mutable reference (writer)
        let token_ref_mut = borrow_global_mut<Token>(signer);

        // Update token value to 200
        update_token_value(token_ref_mut, 200);

        // Re-borrow immutable reference for verification after update
        let token_ref = borrow_global<Token>(signer);

        // Assert that token value is now 200
        let val = read_token_value(token_ref);
        assert::assert(val == 200, 1002);
    }

    #[test]
    public fun test_abilities_combination() {
        let a = ComplexAbilitiesType { data: 42 };
        // Copy the variable to check copy ability
        let b = a;
        let c = b;
        // Just assert that the copy preserved the data correctly
        assert::assert(c.data == 42, 2001);
    }

    // A dummy function to enable AST simplification and code elimination
    // This function is never called, but exists to let the compiler optimize unused code away
    #[inline(always)]
    fun _dead_code_elimination_helper(x: u64): u64 {
        let mut y = x;
        y = y + 1;
        y = y - 1;
        y
    }
}

// Featurres:
// c19c1168e12ffc158978d20a4daf215f: Test that a token's value can be created, read via a reader reference, updated via a writer reference, and verified through assertions that reflect the change.
// b39b2c5ecfe520bd28e7d0729b418906: Enable full AST (Abstract Syntax Tree) simplification and code elimination for Move programs.
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
