
//# publish
module 0xCAFE::InlineAndMutRefTest {
    use std::signer;

    // Inline function that adds two numbers and returns their product plus sum as a tuple.
    public inline fun compute_values(x: u8, y: u8): (u8, u8) {
        let sum = x + y;
        let product = x * y;
        (sum, product + sum)
    }

    struct Container has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun test_mut_ref_on_temp_expr() {
        let container = Container {a: 2, b: 3};

        // Take mutable reference to a field of container through a block expression
        {
            let tmp = &mut container.a;
            // Mutate the temporary mutable reference; original container's 'a' should remain unchanged
            *tmp = 100;
        };

        // Take mutable reference to container's field with conditional expression and mutate through it;
        // This mutation should not affect the original container because it is a mutable reference to a temporary
        {
            let tmp = if (true) {
                &mut container.b
            } else {
                &mut container.a
            };
            *tmp = 200;
        };

        // The original container's fields should remain 2 and 3 if mutation on temporaries are ignored.
        // Just returning values to observe via call effects.
        let a_val = container.a;
        let b_val = container.b;

        // returning the fields in tuple to be observable
        (a_val, b_val)
    }

    public fun test_identifiers_ok() {
        let valid_identifier_1 = 1u8;
        let validIdentifier2 = 2u8;
        let valid_identifier_3a = 3u8;
        // No invalid identifier used; only letters, digits, underscores allowed
        valid_identifier_3a + validIdentifier2 + valid_identifier_1
    }
}


//# run 0xCAFE::InlineAndMutRefTest::compute_values --args 5u8 7u8


//# run 0xCAFE::InlineAndMutRefTest::test_mut_ref_on_temp_expr


//# run 0xCAFE::InlineAndMutRefTest::test_identifiers_ok


// Featurres:
// 800f1506e1b2392621616a643d3141bb: Use inline functions without creating cyclic recursion chains.
// 3497bb6cfac0ff6bb6fc5865570f2421: Test that taking mutable references to complex temporary expressions, including conditionals, block expressions, and field accesses, does not affect the original variable bindings and that mutations to such temporaries are ignored as expected.
// 5009b27db2ca66c066078f1b8fca02b2: Ensure that identifiers in your code do not contain invalid characters outside the allowed set of letters, digits, and underscores.
