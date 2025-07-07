
//# publish
module 0xCAFE::EnhancementsTest {
    use std::vector;

    const LOCAL_CONST: u8 = 42;
    const QUALIFIED_CONST: u64 = 0xDEAD;

    struct Data has copy, drop, store {
        value: u64
    }

    /// A function that returns a transformed value based on input and local constant
    public fun transform_with_local_const(x: u8): u8 {
        if (x < LOCAL_CONST) {
            x + 1
        } else {
            x - 1
        }
    }

    /// A function using an inline if in an expression involving qualified constant
    public fun transform_with_qualified_const(x: u64): u64 {
        if (x > QUALIFIED_CONST) {
            x - QUALIFIED_CONST
        } else {
            QUALIFIED_CONST - x
        }
    }

    /// Function that combines local and qualified constants in a conditional returning Data struct
    public fun combined_constants_conditional(x: u8): Data {
        let val: u64;
        if (x == LOCAL_CONST) {
            val = QUALIFIED_CONST;
        } else {
            val = (LOCAL_CONST as u64 + x as u64) * 2;
        };
        Data { value: val }
    }

    /// Function with rewritten spec that uses conditional code block referencing constants (simulated via assert)
    public fun run_spec_rewrite() {
        // This function simulates a rewritten specification with conditional logic referencing constants
        if (LOCAL_CONST < 100) {
            assert!(transform_with_local_const(LOCAL_CONST) > 0, 1234);
        } else {
            assert!(transform_with_local_const(LOCAL_CONST) == 0, 4321);
        };
        if (QUALIFIED_CONST > 0x100) {
            assert!(transform_with_qualified_const(QUALIFIED_CONST) == 0, 5678);
        };
    }

    /// Function to test conditional referencing constants with inline expression in spec (simulated)
    public fun inline_condition_spec(x: u8) {
        let cond = if (x > LOCAL_CONST) { true } else { false };
        assert!(cond || (x == LOCAL_CONST), 9999);
    }
}


//# run 0xCAFE::EnhancementsTest::transform_with_local_const --args 40u8


//# run 0xCAFE::EnhancementsTest::transform_with_local_const --args 50u8


//# run 0xCAFE::EnhancementsTest::transform_with_qualified_const --args 0xDEABu64


//# run 0xCAFE::EnhancementsTest::transform_with_qualified_const --args 0x1000u64


//# run 0xCAFE::EnhancementsTest::combined_constants_conditional --args 42u8


//# run 0xCAFE::EnhancementsTest::combined_constants_conditional --args 10u8


//# run 0xCAFE::EnhancementsTest::run_spec_rewrite


//# run 0xCAFE::EnhancementsTest::inline_condition_spec --args 41u8


//# run 0xCAFE::EnhancementsTest::inline_condition_spec --args 42u8


// Featurres:
// b55ad2e03b67074aa23a762dfdf31657: Rewrite specifications for Move modules and functions to improve or transform them
// 1854f7c2e94b456ca6c705bfa967e2a4: Include specific code blocks with conditions and expressions in your Move code
// e41df40c11331f9327feead28ff6e8d1: Reference constants with optional module qualification.
