//# publish
module 0x1::pattern_matching_test {
    // Top-level spec block (could be a doc comment, but using a module for test grouping)
    // For illustration, we define a spec function
    public fun spec_top_level() {
        // Just a placeholder for a top-level spec
    }

    // Define nested enums with variants, some with named fields
    enum OuterEnum {
        VariantA,
        VariantB { field1: u64, field2: bool },
        VariantC(Box<InnerEnum>),
    }

    enum InnerEnum {
        InnerVariantX,
        InnerVariantY { x: u8, y: u8 },
        InnerVariantZ { guard: bool, value: u64 },
    }

    // Function to test matching over nested enums
    public fun match_nested_enum(oe: OuterEnum, ie: InnerEnum) {
        // OuterEnum match
        match oe {
            OuterEnum::VariantA => {
                // do nothing
            },
            OuterEnum::VariantB { field1, field2 } => {
                // pattern matching with destructured named fields
                // do something
            },
            OuterEnum::VariantC(inner_box) => {
                // Match over inner Box<InnerEnum>
                match *inner_box {
                    InnerEnum::InnerVariantX => {
                        // do something
                    },
                    InnerEnum::InnerVariantY { x, y } if x > y => {
                        // handle case with guard
                    },
                    InnerEnum::InnerVariantY { x, y } => {
                        // handle other case
                    },
                    InnerEnum::InnerVariantZ { guard, value } => {
                        if guard {
                            // handle guarded variant
                        } else {
                            // unreachable code if guard always true or false definitively
                        }
                    }
                }
            },
        }
    }

    // Function to test pattern matching with wildcards and unreachable branches
    public fun match_with_unreachable(input: u8) {
        match input {
            1 => { /* handle 1 */ },
            2 => { /* handle 2 */ },
            _ => {
                // Catch-all
            }
        }
    }

    // Function to test literal address specifier with byte sequence
    public fun literal_address_specifier() {
        // Specifying an address as a literal byte sequence (e.g., 0x1234)
        let addr: vector<u8> = vector[0x12, 0x34];
        // The rest of the logic could involve using this address, but omitted here
    }

    // Runner function to invoke other functions for VM testing
    public fun run_all() {
        // Call match_nested_enum with various variants
        match_nested_enum(
            OuterEnum::VariantA,
            InnerEnum::InnerVariantX
        );

        match_nested_enum(
            OuterEnum::VariantB { field1: 42, field2: true },
            InnerEnum::InnerVariantY { x: 5, y: 3 }
        );

        // InnerEnum with guard true
        match_nested_enum(
            OuterEnum::VariantC(box InnerEnum::InnerVariantZ { guard: true, value: 100 }),
            InnerEnum::InnerVariantZ { guard: true, value: 100 }
        );

        // InnerEnum with guard false
        match_nested_enum(
            OuterEnum::VariantC(box InnerEnum::InnerVariantZ { guard: false, value: 200 }),
            InnerEnum::InnerVariantZ { guard: false, value: 200 }
        );

        // Call match_with_unreachable with values
        match_with_unreachable(1);
        match_with_unreachable(2);
        match_with_unreachable(5);

        // Call literal address specifier handling
        literal_address_specifier();
    }
}
 //# run 0x1::pattern_matching_test::run_all --signers 0x1 --args