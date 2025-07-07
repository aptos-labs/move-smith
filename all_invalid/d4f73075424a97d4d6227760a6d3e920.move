//# publish
module 0xCAFE::AbilityTest {

    // Struct with Copy and Drop abilities, generic over types with specified abilities
    struct Data<T: copy + drop> {
        value: T,
    }

    public fun create_data<T: copy + drop>(val: T): Data<T> {
        Data { value: val }
    }

    // Function that takes a generic type with only Drop ability
    public fun create_drop_only<T: drop>(val: T): T {
        val
    }

    // Function that returns a Data struct with a copied value
    public fun get_copied_data<T: copy + drop>(d: &Data<T>): T {
        d.value
    }

    // Helper function for ability constraints test
    public fun test_ability_constraints() {
        // Create Data with a u8 value
        let data_u8 = create_data(42u8);
        // Copy value out
        let val: u8 = get_copied_data(&data_u8);
        // Create Data with a boolean
        let data_bool = create_data(true);
        // Drop only wrapper
        let t = create_drop_only(false);
    }
}

 //# run 0xCAFE::AbilityTest::test_ability_constraints

//# publish
module 0xCAFE::ClosureAbilityTest {

    use 0xCAFE::AbilityTest;

    // A local module function to be called within closure
    public fun compute_sum(a: u64, b: u64): u64 {
        a + b
    }

    public fun test_closure_invocations() {
        let counter = 0u64;

        // First closure capturing arguments and calling local function twice
        let closure1 = || {
            let res1 = AbilityTest::compute_sum(10, 20);
            let res2 = AbilityTest::compute_sum(30, 40);
            // sum of results
            res1 + res2
        };

        // Call closure multiple times
        let res_a = closure1();
        let res_b = closure1();

        // Use results to verify repeated closure invocations
        // No assertions, just calling to exercise the feature
    }

    // Define a second closure capturing different variables
    public fun test_closure_multiple() {
        let factor = 3u64;
        let offset = 5u64;

        let closure2 = || {
            // local calculations involving captured variables
            factor * offset
        };

        let val1 = closure2();
        let val2 = closure2();
        // Calling again to exercise repeated closure invocation
    }
}
