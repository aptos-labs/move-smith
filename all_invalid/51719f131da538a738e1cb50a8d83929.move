//# publish
module 0xDEAD::ComplexFlowInteraction {
    use std::debug;

    const LIMIT: u8 = 20;

    // 1. Create a loop with nested if-continue statements that depend on multiple conditions.
    public fun complex_loop_behavior(start: u8): u8 {
        let counter = start;
        while (counter < LIMIT) {
            if (counter % 2 == 0) {
                if (counter % 3 == 0) {
                    // Continue if divisible by 2 and 3
                    counter = counter + 1;
                    continue;
                } else {
                    // Break if divisible by 2 but not by 3
                    break;
                }
            } else {
                // For odd numbers, just increment
                counter = counter + 2;
            };
        };
        counter
    }

    // 2. Functions that extract specific u8 fields from enum variants with nested structures.
    enum NestedEnum has copy, drop {
        VariantA,
        VariantB {
            a: u8,
            b: u8,
        },
        VariantC {
            inner: VariantCInner,
        }
    }

    struct VariantCInner has copy, drop {
        x: u8,
        y: u8,
    }

    public fun get_variant_b_a(e: NestedEnum): u8 {
        match (e) {
            NestedEnum::VariantB { a, b: _ } => a,
            _ => 0,
        }
    }

    public fun get_variant_c_inner_x(e: NestedEnum): u8 {
        match (e) {
            NestedEnum::VariantC { inner } => inner.x,
            _ => 0,
        }
    }

    // 3. Call private and public functions from inline functions within the same module.
    private fun private_helper(val: u8): u8 {
        val + 10
    }

    public fun public_helper(val: u8): u8 {
        val + 20
    }

    public inline fun call_inner_helpers(x: u8): u8 {
        let a = private_helper(x);
        let b = public_helper(x);
        a + b
    }

    // 4. Use update expressions inside spec blocks.
    //@ update x := x + 1;
    public fun increment_x(x: u8): u8 {
        // For testing, just return x after increment
        x + 1
    }

    // 5. Reassign variables within functions multiple times.
    public fun reassignments(): u8 {
        let val = 5;
        // Reassignment
        let _ = { val = val + 3; };
        // Reassignment again
        let _ = { val = val * 2; };
        val
    }

    // 6. Declare variables before if-else so all branches assign; validate no errors.
    public fun predeclare_assign(cond: bool): u8 {
        let res: u8;
        if (cond) {
            res = 10;
        } else {
            res = 20;
        };
        res
    }

    // 7. Script logic assigning variable inside if-else and returning the value.
    public fun assign_in_if_else(is_true: bool): u8 {
        let val: u8 = if (is_true) {
            let _x = 1;
            100
        } else {
            let _x = 2;
            200
        };
        val
    }
}


//# run 0xDEAD::ComplexFlowInteraction::complex_loop_behavior --args 0u8

//# run 0xDEAD::ComplexFlowInteraction::get_variant_b_a --args ("NestedEnum::VariantA")  // Pass as string literal

//# run 0xDEAD::ComplexFlowInteraction::get_variant_b_a --args ("NestedEnum::VariantB { a: 42, b: 0 }")  // Pass as string literal

//# run 0xDEAD::ComplexFlowInteraction::get_variant_c_inner_x --args ("NestedEnum::VariantC { inner: VariantCInner { x: 7, y: 8 } }")  // Pass as string literal

//# run 0xDEAD::ComplexFlowInteraction::call_inner_helpers --args 15u8

//# run 0xDEAD::ComplexFlowInteraction::increment_x --args 25u8

//# run 0xDEAD::ComplexFlowInteraction::reassignments

//# run 0xDEAD::ComplexFlowInteraction::predeclare_assign --args true

//# run 0xDEAD::ComplexFlowInteraction::predeclare_assign --args false

//# run 0xDEAD::ComplexFlowInteraction::assign_in_if_else --args true

//# run 0xDEAD::ComplexFlowInteraction::assign_in_if_else --args false
