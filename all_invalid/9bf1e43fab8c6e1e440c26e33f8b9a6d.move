
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Helper public function to run the test
    public fun run_tests() {
        // Test 1: Using assignment with curly braces as expression inside arithmetic operations
        let result_assign = test_assignment_in_expression(5u8);
        // Test 2: Run type checker implicitly by calling a function
        let _ = run_type_check();
        // Test 3: Pattern matching on nested enum variants involving drop semantics
        let nested_enum_variant = create_nested_enum_variant();
        let match_result = match_nested_enum(nested_enum_variant);
    }

    // 1. Test that the Move language supports using assignment with curly braces as an expression inside arithmetic operations
    public fun test_assignment_in_expression(x: u8): u8 {
        let result = {
            // Use block as expression
            let a = 10u8;
            let b = 20u8;
            let c = a + b;
            c
        } + x;
        result
    }

    // 2. Run the type checker by calling a function with explicit type conversions
    public fun run_type_check(): bool {
        // Type conversion and check
        let a: u8 = 1u8;
        let b: u8 = 2u8;
        let c = a + b;
        // return true if type is correct
        c >= 0u8
    }

    // Enums with nested variants involving drop semantics
    // Enums can be defined with the same semantics; for the test, assume enums that involve drop
    enum OuterEnum has copy, drop {
        InnerVariant(InnerEnum),
        OtherVariant,
    }

    enum InnerEnum has copy, drop {
        DeepVariant(u64),
        DropVariant {
            val: bool,
        },
    }

    // Function to create nested enum variants
    public fun create_nested_enum_variant(): OuterEnum {
        OuterEnum::InnerVariant(InnerEnum::DropVariant { val: true })
    }

    // Function to match on nested enum variant
    public fun match_nested_enum(e: OuterEnum): u8 {
        match e {
            OuterEnum::InnerVariant(inner) => {
                match inner {
                    InnerEnum::DeepVariant(n) => {
                        if (n > 10) { 1 } else { 0 }
                    };
                    InnerEnum::DropVariant { val } => {
                        if (val) { 2 } else { 3 }
                    };
                }
            };
            OuterEnum::OtherVariant => 4,
        }
    }
}



//# run 0xCAFE::TestModule::run_tests


// Features:
// 7fd39f3505c698761e67c33b0bbc8ac4: Test that the Move language correctly supports using assignment with curly braces as an expression inside arithmetic operations.
// 1f5ff922edbcdf6a2b9cb56eb0829fe6: Run the type checker on Move code.
// 4bb22676b955592fc645efbd305c704d: Test that the pattern matching correctly handles nested enum variants involving enums with drop semantics.
