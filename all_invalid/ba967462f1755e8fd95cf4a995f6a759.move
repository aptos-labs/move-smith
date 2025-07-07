
//# publish
module 0xBADD::TestSuite {
    use std::vector;

    // Helper function to make nested match expression with lambdas.
    public fun nested_match_test(value: u8): u8 {
        match (value) {
            0 => {
                let lambda: |u8| u8 = |a| {
                    a + 10
                };
                lambda(value)
            }
            1 => {
                let lambda: |u8, u8| u8 = |a, b| {
                    a + b
                };
                lambda(value, 5)
            }
            _ => {
                let lambda: || u8 = || {
                    42
                };
                lambda()
            }
        }
    }

    // Test lambdas with multiple parameters, no parameters, nested execution.
    public fun test_lambda_variants() {
        let a1 = |x: u8| x + 1;
        let result1 = a1(10u8);
        let a2: || u8 = || 7u8;
        let result2 = a2();
        let a3: |u8, u8| u8 = |x, y| x * y;
        let result3 = a3(3u8, 4u8);
        (result1, result2, result3)
    }

    // Test namespace management with members and aliasing.
    public fun namespace_conflict_test(flag: bool): bool {
        // Correct usage: defining with unique names
        if (flag) {
            const member_a: u8 = 1;
            const alias_b: u8 = 2;
        } else {
            // Intentional conflict: duplicate member name 'member_a'
            // This should cause compile error if uncommented.
            // const member_a: u8 = 3; // ERROR: duplicate member name
            // or using same alias b
            // const alias_b: u8 = 4; // ERROR: duplicate alias in same namespace
        }
        true
    }

    // Test match expression with multiple arms and pattern matching.
    public fun match_expression_test(input: E): u8 {
        match (input) {
            E::V1 => 1,
            E::V2(x, y) => {
                let lambda: |u8, u8| u8 = |a, b| a + b;
                lambda(x, y)
            }
            E::V3 { a } => {
                if (a) {
                    2
                } else {
                    3
                }
            }
        }
    }

    // Test combining lambdas within match arms, including nested lambda expressions.
    public fun combined_match_lambda(input: E): u8 {
        match (input) {
            E::V2(x, y) => {
                let lambda: |u8, u8| u8 = |a, b| {
                    let inner_lambda: |u8| u8 = |c| c + 1;
                    inner_lambda(a) + inner_lambda(b)
                };
                lambda(x, y)
            }
            _ => 0u8
        }
    }

    // Edge case: Symbol conflict between lambda param and module member
    public fun lambda_member_conflict(x: u8): u8 {
        // Suppose module has a member named 'x' (simulate conflict)
        // but in Move, lambda parameters are local, so no error.
        let x = x + 5;
        x
    }

    // Function with nested match and lambda demonstrating complex interactions.
    public fun complex_nested_match(input: u8): u8 {
        match (input) {
            0 => {
                let lambda: |u8| u8 = |a| {
                    match (a) {
                        0 => 100,
                        _ => a
                    }
                };
                lambda(0)
            }
            1 => {
                let lambda: || u8 = || 255;
                lambda()
            }
            _ => {
                let lambda: |u8| u8 = |a| a + 50;
                lambda(input)
            }
        }
    }

    // Function to intentionally trigger namespace conflict error: duplicate member names
    // (This would cause compile error if uncommented)
    public fun trigger_conflict_error() {
        // const duplicate: u8 = 1;
        // const duplicate: u8 = 2; // ERROR: duplicate member name
        // or alias conflict
    }
}


//# run 0xBADD::TestSuite::nested_match_test --args 0u8

//# run 0xBADD::TestSuite::nested_match_test --args 1u8

//# run 0xBADD::TestSuite::nested_match_test --args 5u8


//# run 0xBADD::TestSuite::test_lambda_variants


//# run 0xBADD::TestSuite::match_expression_test --args E::V1

//# run 0xBADD::TestSuite::match_expression_test --args E::V2(3, 4)

//# run 0xBADD::TestSuite::match_expression_test --args E::V3 { a: true }


//# run 0xBADD::TestSuite::combined_match_lambda --args E::V2(7, 8)

//# run 0xBADD::TestSuite::combined_match_lambda --args E::V3 { a: false }

//# run 0xBADD::TestSuite::complex_nested_match --args 0u8

//# run 0xBADD::TestSuite::complex_nested_match --args 1u8

//# run 0xBADD::TestSuite::complex_nested_match --args 42u8


// Featurres:
// 7349d4319874d32ee2f215437315aae7: Define lambda parameter lists using pipe-separated syntax.
// 6be5d216e95d58b1065723dbea670849: Ensure that module member names and aliases are unique within each namespace.
// d0ec17a6fc0c2d88253ae1421a56465b: Write match expressions with multiple arms in your Move code.
