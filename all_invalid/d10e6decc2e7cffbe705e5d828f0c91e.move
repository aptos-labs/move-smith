
//# publish
module 0xCAFE::InlineAndMutRefTest {
    // Removed unused `use std::signer;`

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

    // Added return type : (u8, u8) to fix error of returning a tuple without specifying return type
    public fun test_mut_ref_on_temp_expr(): (u8, u8) {
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

    // Added return type : u8 as function returns value. Also fixed function body to end with an expression.
    public fun test_identifiers_ok(): u8 {
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
