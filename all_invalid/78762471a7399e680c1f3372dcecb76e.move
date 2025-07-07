
//# publish
module 0xCAFE::test_module {
    use std::vector;

    // Enum with a single variant for destructuring test
    public enum SingleVariant {
        OnlyVariant,
    }

    // Function to destructure enum and assign to a function type variable
    public fun destructure_enum(): (|() -> ()) {
        let e = SingleVariant::OnlyVariant;
        let func: |() -> ();

        match e {
            SingleVariant::OnlyVariant => {
                func = |()| {
                    // do nothing
                };
            }
        };
        return func;
    }

    // Inline function for mutation test
    public inline fun inc(x: u64): u64 {
        let result = x + 1;
        result
    }

    // Constant vectors for initialization
    public fun boolean_vector_true(): vector<bool> {
        vector::singleton(true)
    }

    public fun boolean_vector_false(): vector<bool> {
        vector::singleton(false)
    }

    // Function to compare vectors and boolean expressions
    public fun vector_bool_comparisons(): bool {
        let v_true = boolean_vector_true();
        let v_false = boolean_vector_false();

        // Compare vector with itself
        let comparison_self = vector::equals(&v_true, &v_true);
        // Compare empty vector with non-empty vector
        let empty_vec: vector<u8> = vector::empty();
        let non_empty_vec: vector<u8> = b"hello";

        let comparison_empty_nonempty = vector::equals(&empty_vec, &non_empty_vec);

        // Logical expressions
        let bool_expr1 = true && false;
        let bool_expr2 = true || false;

        comparison_self && !comparison_empty_nonempty && (bool_expr1 == false) && (bool_expr2 == true)
    }
}


//# run 0xCAFE::test_module::destructure_enum

//# run 0xCAFE::test_module::inc --signers 0x123 --args 41u64

//# run 0xCAFE::test_module::vector_bool_comparisons

// Featurres:
// 310916a0f698ccc355a4905152575d15: Test that destructuring an enum with a single variant inside a match and assigning to a variable of a function type works correctly.
// 0d0379a1bb3df24eb05d04a4c28c0842: Test that the inline function `inc` correctly mutates a variable and returns the incremented value within the module.
// 092351c6b4a90869158551a330f9f94f: Test that vector constants with boolean values, including logical expressions, and equality comparisons between empty and non-empty byte vectors, are correctly initialized and compared.
