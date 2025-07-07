//# publish
module 0x1::TestModule {
    // Struct for singleton layout
    struct SingletonStruct has copy, drop, store {
        value: u64,
    }

    // Variant layout using enum
    enum Variants {
        VariantA { data: u128 },
        VariantB,
    }

    // Function to create singleton
    public fun create_singleton(val: u64): SingletonStruct {
        SingletonStruct { value: val }
    }

    // Function to get singleton value
    public fun get_singleton_value(s: &SingletonStruct): u64 {
        s.value
    }

    // Function to create a variant
    public fun create_variant_a(data: u128): Variants {
        Variants::VariantA { data }
    }

    // Function to match on variant
    public fun match_variant(v: &Variants): u64 {
        match v {
            Variants::VariantA { data } => *data as u64,
            Variants::VariantB => 0,
        }
    }

    // Runner function to test module functions
    public fun run() {
        let s = create_singleton(42);
        let val = get_singleton_value(&s);
        let v = create_variant_a(1234567890);
        let matched_value = match_variant(&v);
    }
}

//# run 0x1::TestModule::run

//# run 0x1::TestModule::create_singleton --args 999u64
// Since create_singleton is inside the module, invoking via the runner is preferable, or direct invocation in script.



//# publish
module 0x1::MutationTest {
    // Function to test sequence expressions with variables
    public fun sequence_expression_test() {
        let mut a = 10;
        let mut b = 20;
        // Sequence expression with same variables on both sides (disallowed in some modes)
        // To test cautious behavior, combine in a block
        let c = {
            a = a + b;
            b = a - b;
            a + b
        };
        // Use the variables to prevent dead code elimination (No assertions needed)
    }

    // Function referencing module functions
    public fun module_function_reference() {
        // Assign function to a variable
        let creator = create_and_return;
        // Call via variable (closure call)
        let s = creator(55);
        // Call the function directly
        let s2 = create_and_return(66);
        // Call via module function name
        let val = get_value(&s);
    }

    // Helper functions
    public fun create_and_return(val: u64): (u64, u64) {
        (val, val + 1)
    }

    public fun get_value(s: & (u64, u64)): u64 {
        let (v, _) = *s;
        v
    }

    // Runner function encapsulating tests
    public fun run() {
        sequence_expression_test();
        module_function_reference();
    }
}

//# run 0x1::MutationTest::run

//# publish
module 0x1::InvokerTests {
    use 0x1::MutationTest;

    // Define a function that calls other functions
    public fun test_calls() {
        MutationTest::sequence_expression_test();
        MutationTest::module_function_reference();
    }

    // Function that creates a closure and invokes it
    public fun closure_invocate() {
        let closure = |x: u64| {
            let y = x + 100;
            y
        };
        let result = closure(50);
    }

    // Runner function
    public fun run() {
        test_calls();
        closure_invocate();
    }
}

//# run 0x1::InvokerTests::run

// Featurres:
// c347692df41aca17e427fb072735ebdb: Be cautious when sequence expressions in binary operations use or modify the same variables on both sides or introduce control flow redirections, as this is disallowed in some compiler modes.
// 24b151c1a740aa8b796667ce9b1836a7: Define struct types with singleton or variant layouts in Move modules.
// e07fcd3da542c36b5b34359b50bb09b9: Test that module functions can be referenced and invoked directly, assigned to variables, and called via closures in scripts.
