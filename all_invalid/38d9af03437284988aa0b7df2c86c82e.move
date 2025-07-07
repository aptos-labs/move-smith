
//# publish
module 0xCAFE::TestModule {
    use std::debug;

    // Define a struct to represent a spec condition with optional additional expressions
    struct Condition {
        condition_expr: bool,
        additional_exprs: vector<bool>,
    }

    public fun new_condition(condition_expr: bool, additional_exprs: vector<bool>): Condition {
        Condition {
            condition_expr,
            additional_exprs,
        }
    }

    // Function with explicitly specified type parameters and parameters
    public fun process_conditions<T: copy + drop>(
        cond1: Condition,
        cond2: Condition,
        cond3: Condition,
    ): bool {
        // Check if the main condition and at least one additional condition are all true
        let main_and = cond1.condition_expr && cond2.condition_expr && cond3.condition_expr;
        let or_additional = false;
        let i = 0;
        while (i < vector::length(&cond1.additional_exprs)) {
            or_additional = or_additional || vector::borrow(&cond1.additional_exprs, i);
            i = i + 1;
        }
        main_and && or_additional
    }

    // Tester function for logical AND, OR combined, and updates local var `x`
    public fun tester(input1: bool, input2: bool): u8 {
        let x: u8 = 0;
        let cond1 = new_condition(input1, vector::singleton(true));
        let cond2 = new_condition(input2, vector::singleton(false));
        let cond3 = new_condition(input1 && input2, vector::singleton(!input1));

        let result = process_conditions<copy u8>(cond1, cond2, cond3);

        // Update x based on logical OR of input1 and input2
        if (input1 || input2) {
            x = 1;
        }
        // Further update x based on logical AND of input1 and input2
        if (input1 && input2) {
            x = 2;
        }
        // Final return value based on last update
        x
    }
}


//# run 0xCAFE::TestModule::tester --args true false

// Featurres:
// 096995bf2c4c8caed00d42a8669cb5a5: Define specification condition expressions within spec blocks using 'Condition' with an expression and optional additional expressions.
// 88780a25fcdc495a06545d1cbd51852d: Define functions with explicitly specified type parameters and parameters.
// 9b2b83316c4d9030a1ebaf98f4dbe4c7: Test that the `tester` function correctly updates a local variable `x` based on logical AND and OR expressions involving boolean inputs, resulting in the expected numeric output.
