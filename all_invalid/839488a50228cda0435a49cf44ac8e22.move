//# publish
module 0xCAFE::Arithmetic {
    const CONST_A: u64 = 100;
    const CONST_B: u64 = 25;

    public fun add_constants(): u64 {
        CONST_A + CONST_B
    }

    public fun subtract_consts(): u64 {
        CONST_A - CONST_B
    }

    public fun multiply_consts(): u64 {
        CONST_A * CONST_B
    }

    public fun divide_consts(): u64 {
        CONST_A / CONST_B
    }

    public fun conditional_arithmetic(x: u64): u64 {
        if (x < CONST_B) {
            CONST_A + x
        } else {
            CONST_A - x
        };
    }

    public fun nested_conditions(x: u64): u64 {
        if (x == 0) {
            CONST_A
        } else if (x < CONST_B) {
            CONST_A * x
        } else {
            CONST_A / x
        };
    }
}

//# run 0xCAFE::Arithmetic::add_constants

//# run 0xCAFE::Arithmetic::subtract_consts

//# run 0xCAFE::Arithmetic::multiply_consts

//# run 0xCAFE::Arithmetic::divide_consts

//# run 0xCAFE::Arithmetic::conditional_arithmetic --args 10u64

//# run 0xCAFE::Arithmetic::conditional_arithmetic --args 30u64

//# run 0xCAFE::Arithmetic::nested_conditions --args 0u64

//# run 0xCAFE::Arithmetic::nested_conditions --args 10u64

//# run 0xCAFE::Arithmetic::nested_conditions --args 50u64

// Featurres:
// 402a5cea3a9bcbf7b8a81f642d55d439: Define constants in Move modules.
// c6e96d7bf91d8c8b134eca57e52c7e79: Write binary operations (e.g., +, -, *, /) between two expressions.
// 1854f7c2e94b456ca6c705bfa967e2a4: Include specific code blocks with conditions and expressions in your Move code
