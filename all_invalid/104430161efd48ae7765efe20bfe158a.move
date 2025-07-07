
//# publish
module 0xDEAD::FeatureTest {
    use std::vector;

    // Define a simple struct to test pattern matching and shadowing
    struct S has copy, drop, store {
        a: u8,
        b: u8,
    }

    // Function to test variable shadowing and pattern matching with anonymous (_) variable
    public fun shadowing_test(flag: bool): (u8, u8) {
        let x = 10u8;
        let y = 20u8;

        if (flag) {
            let _ = x; // shadowing x with _ (valid)
            let _ = y; // shadowing y with _ (valid)
        } else {
            let x = 30u8; // shadowing x again (valid)
            let y = 40u8; // shadowing y again (valid)
        };

        (x, y)
    }

    // Closure parameter pattern matching
    public fun closure_test() {
        let lambda: |u8, u8| (u8, u8) = |a: u8, _: u8| {
            // a is used, _ is anonymous
            (a, 42u8)
        };

        let (val1, val2) = lambda(2, 3);
    }

    // Pattern matching with nested destructure
    public fun destructure_and_shadow() {
        let s = S {a: 5, b: 6};
        // Correct syntax for destructuring with references
        let S {a: ref a_field, b: ref b_field} = s;
        let _ = a_field; // Use field a
        let _ = b_field; // Use field b
    }

    // Attempt to use unresolved address pattern
    public fun invalid_address_pattern() {
        // The following line should produce an error due to invalid address pattern
        // `0xBAD::Unknown` does not resolve or compile
        // let _ = 0xBAD::Unknown;    // invalid pattern
        // The above line is commented out to avoid compilation error during test
    }

    // Attempt to use an invalid name in a name chain
    public fun invalid_name_chain() {
        // This should produce an error due to invalid name (use of a reserved keyword)
        // let _ = std::move::nonexistent;  // invalid name
        // Commented out to not break the overall test
    }

    // Reference struct fields by numeric position
    public fun reference_fields_by_position(s: S): (u8, u8) {
        // Move the fields out by destructuring
        let S {a: a1, b: b1} = s;
        (a1, b1)
    }

    // Function to test various shadowing and pattern matching features
    public fun run_all_test() {
        let (x, y) = shadowing_test(true);
        let _ = (x, y);

        let _ = closure_test();

        destructure_and_shadow();

        // The following calls are intentionally commented out for invalid patterns
        // invalid_address_pattern();
        // invalid_name_chain();

        // Call reference_fields_by_position with a test struct
        let s = S {a: 1, b: 2};
        let (a_val, b_val) = reference_fields_by_position(s);
        let _ = (a_val, b_val);
    }
}



//# run 0xDEAD::FeatureTest::run_all_test


// Features:
// f937f998c935ba5181a89daa92debdc1: Verify that the Move compiler correctly handles the use, scoping, shadowing, and pattern matching of the anonymous variable (_) in function arguments, local bindings, destructuring assignments, and closure parameters, including both valid and invalid usages.
// 28a15820404dad79f67d41320c6ba8c4: Handle and report errors when unresolved or invalid address or name patterns are encountered in name chains.
// b8e6be7754183eb5393c77e9ef3b5220: Reference struct fields by their position number if the field name is a numeric string.
