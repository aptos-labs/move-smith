
//# publish
module 0xDEAD::TestSuite {
    use std::vector;
    use std::signer;

    // Error codes for specific aborts
    const ERROR_DIV_ZERO: u64 = 0;
    const ERROR_OVERFLOW: u64 = 1;
    const ERROR_UNDERFLOW: u64 = 2;
    const ERROR_MOD_ZERO: u64 = 3;
    const ERROR_MOVE_IN_FIELD: u64 = 4;
    const ERROR_INVALID_MATCH_ARM: u64 = 5;

    struct DataStruct has copy, drop, store {
        num: u64,
    }

    // Function to intentionally cause divide by zero
    public fun test_divide_by_zero(): u64 {
        let _ = 0u64;
        // This should abort with ERROR_DIV_ZERO
        let _res = 1u64 / 0u64;
        0
    }

    // Function to cause overflow
    public fun test_overflow(): u64 {
        let max = 0xffffffffffffffffu64;
        // This should abort with ERROR_OVERFLOW
        let _res = max + 1u64;
        0
    }

    // Function to cause underflow (subtracting to negative in unsigned)
    public fun test_underflow(): u64 {
        let zero = 0u64;
        // This should abort with ERROR_UNDERFLOW
        let _res = zero - 1u64;
        0
    }

    // Function to cause modulo zero
    public fun test_modulo_zero(): u64 {
        let _ = 10u64 % 0u64;
        0
    }

    // Function to test move-to in struct initializer; should abort
    public fun test_move_in_initializer(s: signer): DataStruct {
        // Move object in struct field initializer - should abort
        let obj = move_from<DataStruct>(signer::address_of(&s));
        DataStruct { num: obj.num }
    }

    // Function with match expression: pattern arm and expression arm
    public fun match_expression_test(val: u64): u64 {
        let result = match (val) {
            0 => {
                // pattern arm
                100u64
            }
            n if (n % 2 == 0) => (
                // expression arm with side effect
                // Note: in Move, match arms are expressions; side effects are possible
                let _ = move_to_temp();
                n
            )
            _ => {
                200u64
            }
        };
        result
    }

    // Helper function for side effect in match arm
    public fun move_to_temp() {
        // No actual move; just a placeholder to simulate side effect
        // To simulate some side effect, we could do a dummy assignment or abort
        // We'll just keep it empty to test pattern matching behavior
    }

    // Function to perform large vector comparison
    public fun large_vector_comparison(): bool {
        let size = 1024u64;
        let v1 = vector::empty<u8>();
        let v2 = vector::empty<u8>();
        // Fill both with zeros
        let i = 0u64;
        while (i < size) {
            vector::push_back(&mut v1, 0);
            vector::push_back(&mut v2, 0);
            i = i + 1;
        };
        // Compare vectors for equality
        vector::equals(&v1, &v2)
    }
}


//# run 0xDEAD::TestSuite::test_divide_by_zero

//# run 0xDEAD::TestSuite::test_overflow

//# run 0xDEAD::TestSuite::test_underflow

//# run 0xDEAD::TestSuite::test_modulo_zero

//# run 0xDEAD::TestSuite::test_move_in_initializer --signers 0xBADD

//# run 0xDEAD::TestSuite::match_expression_test --args 0

//# run 0xDEAD::TestSuite::match_expression_test --args 2

//# run 0xDEAD::TestSuite::match_expression_test --args 3

//# run 0xDEAD::TestSuite::large_vector_comparison


// Featurres:
// 59246af8817918cf0c3fea3aa805e1a8: Test that arithmetic errors in struct field initializers (such as division by zero, overflow, underflow, and modulo by zero) and move-to operations in field initializers correctly fail at runtime with appropriate aborts or errors.
// 44501669dc459dc611e13589cf5aa798: Create match expressions with expression and pattern arms.
// 626f1ddb76fa8fa305868ff758875cd0: Verify that a vector of zeros matches an identical vector of zeros, confirming equality comparison for large byte vectors in Move.
