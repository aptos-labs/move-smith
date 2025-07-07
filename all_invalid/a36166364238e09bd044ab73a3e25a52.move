// SPDX-License-Identifier: Apache-2.0
// This is a Move transactional test script written for Aptos framework,
// which focuses on testing the Move compiler and VM on:
// 1) Avoiding sequences with multiple expressions inside binary operands,
// 2) Use of type parameters in struct fields,
// 3) Operator precedence and logical assertions involving logical, comparison,
//    bitwise, and arithmetic expressions.

script {
    use std::debug;
    use std::signer;

    /// A generic struct with type parameter T used in a field type.
    struct Wrapper<T> has copy, drop, store {
        value: T,
    }

    /// Helper function to demonstrate usage of Wrapper<T> and avoid sequences in binary operands.
    fun compute_wrapped_sum<T: copy + drop + store>(w1: Wrapper<u64>, w2: Wrapper<u64>, w3: Wrapper<u64>): u64 {
        // Avoid sequences in binary operands by assigning intermediate values first.
        let a = w1.value + w2.value;   // sum of first two
        let b = w3.value;              // third value
        // Return sum to test correctness
        a + b
    }

    fun test_operator_precedence() {
        // Testing operator precedence explicitly:
        //
        // Expression: (5 + 3 * 2) - (8 >> 1) & 3 | 1
        // Should be evaluated as:
        // Step 1: 3 * 2 = 6
        // Step 2: 5 + 6 = 11
        // Step 3: 8 >> 1 = 4
        // Step 4: 11 - 4 = 7
        // Step 5: 7 & 3 = 3
        // Step 6: 3 | 1 = 3 (Binary OR of 11 and 01 is 11 = 3)
        let expr = ((5 + (3 * 2)) - (8 >> 1)) & 3 | 1;
        debug::assert(expr == 3, 100);

        // Logical operators and comparison:
        //
        // Expression: (true && false) || (!false && (3 < 5)) && (0b101 & 0b001 == 0b001)
        //
        // Stepwise:
        // true && false = false
        // !false = true
        // 3 < 5 = true
        // true && true = true
        // false || true = true
        // 0b101 & 0b001 = 0b001 == 0b001 is true
        // So final: true && true => true
        let logical_expr = (true && false) || ((!false) && (3 < 5)) && ((0b101 & 0b001) == 0b001);
        debug::assert(logical_expr, 101);
    }

    fun test_type_param_struct_fields() {
        // Create Wrapper<u64>
        let w_u64 = Wrapper<u64> { value: 42 };
        // Create Wrapper<bool>
        let w_bool = Wrapper<bool> { value: true };

        // Use compute_wrapped_sum with Wrapper<u64>
        let sum = compute_wrapped_sum(w_u64, Wrapper<u64>{value: 8}, Wrapper<u64>{value: 10});
        debug::assert(sum == 60, 102); // 42 + 8 + 10 = 60

        // Simply check the bool wrapper value to ensure type param works
        debug::assert(w_bool.value == true, 103);
    }

    /// Entry point of the test
    public fun main(account: &signer) {
        test_operator_precedence();
        test_type_param_struct_fields();
    }
}

// Featurres:
// 8b353d0c6605264224828047f87c28a2: Avoid placing sequences with multiple expressions inside the operands of binary operations, or rewrite code to eliminate such sequences to ensure clearer evaluation order.
// fa09991c70ad2489dd408fee816518bc: Use type parameters in the types of struct fields.
// 2a5c0713c8238f842eb685a75c21917e: Test that operator precedence and logical assertions behave as expected in Move scripts, including logical operators, comparison, bitwise, and arithmetic expressions.
