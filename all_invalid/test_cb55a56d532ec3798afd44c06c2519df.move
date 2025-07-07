//# publish
module 0x99::pattern_tests {

    // Define an enum with nested enums and abilities
    enum NestedEnum has copy, drop, store {
        VariantA,
        VariantB{x: u64},
        VariantC{sub: InnerEnum}
    }

    enum InnerEnum has copy, drop, store {
        Inner1,
        Inner2{ y: u128 },
    }

    // Function to test pattern matching with nested enums and references
    public fun match_nested_enum(e: &NestedEnum): u64 {
        match (e) {
            NestedEnum::VariantA => 0,
            NestedEnum::VariantB{x} => x,
            NestedEnum::VariantC{sub} => match (sub) {
                InnerEnum::Inner1 => 100,
                InnerEnum::Inner2{ y } => y as u64,
            }
        }
    }

    // Function to test pattern matching with ref and wildcard
    public fun is_variant_b(e: &NestedEnum): bool {
        match (e) {
            NestedEnum::VariantB{x: _} => true,
            _ => false
        }
    }

    // Function to test matching with condition & ability
    public fun inner_value_with_condition(e: &InnerEnum): u128 {
        match (e) {
            InnerEnum::Inner1 => 0,
            InnerEnum::Inner2{ y } if y > 10 => y,
            InnerEnum::Inner2{ y } => y / 2,
        }
    }

    // Supporting enum with abilities
    enum InnerEnum has copy, drop, store {
        Inner1,
        Inner2{ y: u128 },
    }

    // Function with condition checking abilities and nested matching
    public fun check_and_return(e: &InnerEnum): u128 {
        match (e) {
            InnerEnum::Inner1 => 1,
            InnerEnum::Inner2{ y } if *y > 50 => *y,
            InnerEnum::Inner2{ y } => *y / 2,
        }
    }

    // Function with generics and nested matching
    public fun generic_match<T: store + copy + drop>(opt: &Option<T>): bool {
        match (opt) {
            Option::None => false,
            Option::Some{value} => {
                // For demonstration: check if value is equal to default (requires T: == T::default())
                // but Move doesn't have default, so just return true
                true
            }
        }
    }

    // Function to test matching with enum variant with fields and referencing data
    public fun select_value(e: &OuterSelect): u64 {
        match (e) {
            OuterSelect::ValA{x} => *x,
            OuterSelect::ValB{y} => *y,
        }
    }

    // Enum with data fields, variants
    enum OuterSelect {
        ValA{x: u64},
        ValB{y: u64}
    }

    //# run 0x99::pattern_tests::match_nested_enum

    //# run 0x99::pattern_tests::is_variant_b

    //# run 0x99::pattern_tests::inner_value_with_condition

    //# run 0x99::pattern_tests::check_and_return

    //# run 0x99::pattern_tests::generic_match --signers 0x1 --args &Option::Some{value: 5}

    //# run 0x99::pattern_tests::select_value --signers 0x1 --args &OuterSelect::ValB{y: 42}
