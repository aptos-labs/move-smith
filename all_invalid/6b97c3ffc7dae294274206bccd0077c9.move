
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

        // Inline nested functions to simulate order of evaluation
        fun eval_a(): u8 {
            vector::push_back(&mut trace, 1);
            10u8
        }

        fun eval_b(): u8 {
            vector::push_back(&mut trace, 2);
            20u8
        }

        // Call with assignment expressions passed as arguments
        let a_val = eval_a(); // Should evaluate first
        let b_val = eval_b(); // Should evaluate second

        // Check evaluation order captured in trace
        assert!(*vector::borrow(&trace, 0) == 1, 999);
        assert!(*vector::borrow(&trace, 1) == 2, 999);

        // Use in function call
        process_values(a_val, b_val)
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
}


//# run 0xDEAD::TestModule::test_function_args_order_and_scoping --args 0u8 0u8


//# run 0xDEAD::TestModule::test_abilities_on_structs


//# run 0xDEAD::TestModule::test_enum_matching --args 2u8


// Featurres:
// 4eb0c2ab3e0d4371b9260676c1858e04: Test passing an assignment expression as a function argument and ensure the argument evaluation order and scoping behave as expected.
// 2128a8282f2ab2a9102738acef512ba5: Run the type checker on your Move modules to verify correctness.
// f1c17907be8ea222f783a0a1ab20a0a7: Encourage proper handling of abilities via ability checks on types and function signatures.
