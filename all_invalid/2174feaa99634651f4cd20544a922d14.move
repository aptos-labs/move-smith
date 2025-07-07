
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    struct DummyStruct has copy, drop, store {
        value: u64
    }

    public fun test_function_args_order_and_scoping(
        x: u8,
        y: u8
    ): u8 {
        let trace: vector<u8> = vector::empty();

        // Inline nested functions in a separate scope block
        // Move nested functions outside to avoid syntax errors
        // because Move does not support defining functions inside functions

        // Call with assignment expressions passed as arguments
        let a_val = eval_a(&mut trace); // Should evaluate first
        let b_val = eval_b(&mut trace); // Should evaluate second

        // Check evaluation order captured in trace
        assert!(*vector::borrow(&trace, 0) == 1, 999);
        assert!(*vector::borrow(&trace, 1) == 2, 999);

        // Use in function call
        process_values(a_val, b_val)
    }

    // Define helper functions at module scope
    fun eval_a(trace: &mut vector<u8>): u8 {
        vector::push_back(trace, 1);
        10u8
    }

    fun eval_b(trace: &mut vector<u8>): u8 {
        vector::push_back(trace, 2);
        20u8
    }

    // Function to process two passed values
    public fun process_values(a: u8, b: u8): u8 {
        a + b
    }

    // Function to test ability checks and type correctness
    public fun test_abilities_on_structs() {
        // As `Drop` is not used, this should compile
        let obj = DummyStruct { value: 42 };
        // Ability check: drop
        assert!(true, 111);
    }

    // Function to test matching on enum variants
    public fun test_enum_matching(e: u8): u8 {
        let e_variant = match e {
            1 => E::V1,
            2 => E::V2(3, 4),
            3 => E::V3 { a: true },
            _ => E::V1,
        };
        match e_variant {
            E::V1 => 1,
            E::V2(x, y) => x + y,
            E::V3 { a } => if (a) {2} else {3},
        }
    }

    // Define the enum used for matching
    enum E {
        V1,
        V2 { x: u64, y: u64 },
        V3 { a: bool },
    }
}


//# run 0xDEAD::TestModule::test_function_args_order_and_scoping --args 0u8 0u8

//# run 0xDEAD::TestModule::test_abilities_on_structs

//# run 0xDEAD::TestModule::test_enum_matching --args 2u8
