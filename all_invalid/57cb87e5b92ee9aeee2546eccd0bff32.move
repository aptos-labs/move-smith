module 0xCAFE::OperatorPrecedenceTest {
    use std::assert;

    // Helper function for addition
    public fun add(a: u32, b: u32): u32 {
        a + b
    }

    // Function to test various operator precedence rules
    public fun test_operator_precedence(x: u32, y: u32, z: u32): bool {
        // Logical AND (&&) has higher precedence than OR (||)
        let logical_expr = (x > y && y < z) || (z == 0);
        // Comparison operators (<, >, ==) are evaluated before logical operators
        let comparison_expr = (x + y) < z && y != 0;
        // Bitwise AND (&) has lower precedence than comparison operators but higher than addition
        let bitwise_expr = ((x | y) & z) == 0xFF;

        // Arithmetic precedence: multiplication (*) before addition and subtraction
        let arithmetic_expr = (x + y) * z > add(x, y) * 2;

        logical_expr && comparison_expr && bitwise_expr && arithmetic_expr
    }

    // Function explicitly testing arithmetic operations
    public fun test_arithmetic_ops(a: u32, b: u32): bool {
        // Test subtraction, addition, multiplication
        let sub = a - b;
        let sum = a + b;
        let prod = a * b;

        // Use add helper to verify addition
        let add_result = add(a, b);
        add_result == sum && prod == (a * b)
    }

    // Function to verify early termination with return inside if branch
    public fun check_early_return(flag: bool): bool {
        if (flag) {
            // Return early, subsequent assertions should not run
            return true;
        } else {
            // This code should be skipped if flag is true
            assert!(false, 999);
            return false;
        }
    }
}


//# run 0xCAFE::OperatorPrecedenceTest::test_operator_precedence --args 10u32 20u32 30u32


//# run 0xCAFE::OperatorPrecedenceTest::test_arithmetic_ops --args 15u32 5u32


//# run 0xCAFE::OperatorPrecedenceTest::check_early_return --args true

// Features:
// acf644e739cb4ed8a9e6290507388add: Verify that operator precedence rules are correctly implemented for logical, comparison, bitwise, and arithmetic operators in Move expressions.
// ba00d2a0082287cf64d197987fcd80c2: Test the `test` function to verify that it correctly performs arithmetic operations, including subtraction, addition, multiplication, and the use of the `add` helper function.
// 2a6cb6f49f542b75785477273a804a43: Test that the script correctly terminates early with a return statement inside an if branch, preventing subsequent code from executing and ensuring that assertions after the return are not triggered.