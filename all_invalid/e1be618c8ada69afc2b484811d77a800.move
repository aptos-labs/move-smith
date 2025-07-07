//# publish
module 0x1::test_module {
    // Define a struct with optional visibility modifier only if language v2 is enabled
    // (This is a compile-time check: In actual Move, Visibility modifiers are part of the language syntax.
    // For the purpose of this test, we assume the existence of a feature flag check.)
    // If language v2 is enabled, then the following struct can have optional visibility.
//# if language_v2
    struct OptionalVisibility { value: u64 }
    public struct PublicStruct { value: u64 }
    // The following line would be invalid if language v2 not enabled, so we assume the feature toggle.
    //# endif

    // Function to test add2 and add3 logic
    public fun test(): u64 {
        let local_var1 = 10;
        let local_var2 = 20;
        let sum2 = add2(local_var1, local_var2);
        let result = add3(sum2, 5);
        result
    }

    fun add2(x: u64, y: u64): u64 {
        x + y
    }

    fun add3(z: u64, w: u64): u64 {
        z + w
    }

    // Abstract 'axiom' as a comment (since Move does not support axioms directly)
    // axiom: For all x, y: add2(x, y) == x + y
    // axiom: For all z, w: add3(z, w) == z + w

    // Optional: Runner function to test behavior
    public fun run_tests(): u64 {
        Self::test()
    }
}

//# run 0x1::test_module::run_tests