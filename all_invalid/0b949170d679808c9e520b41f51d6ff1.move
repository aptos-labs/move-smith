
//# publish
module 0xCAFE::AdvancedPatterns {
    use std::vector;

    struct Container has copy, drop, store {
        value: u8,
        assigned_val: u8,
    }

    enum AssignEnum has copy, drop {
        Unassigned,
        Assigned(u8),
    }

    public fun assign_variant_value(): Container {
        let c = Container {value: 0u8, assigned_val: 0u8};
        let assign_value = AssignEnum::Assigned(42u8);
        // Assign with pattern matching using enum variant
        // let is NOT allowed, so we shadow with let
        let c = if (matches!(assign_value, AssignEnum::Assigned(_))) {
            let AssignEnum::Assigned(v) = assign_value;
            Container {value: c.value, assigned_val: v}
        } else {
            c
        };
        c
    }

    public fun while_false_condition(): u64 {
        let counter = 100u64;
        // while false, so loop body never executes, counter keeps initial value
        while (false) {
            counter = 0;
        };
        counter
    }

    public fun destructure_with_range_pattern(): u8 {
        // Create vector of u8 values
        let v = vector[10u8, 20u8, 30u8, 40u8, 50u8];
        // Destructure array with slice pattern in LValue:
        // let [a, b, ..rest] = v;
        // In Move we only have vector, let's destructure manually
        // Using vector::pop_back multiple times to isolate end elements:
        let len = vector::length(&v);
        let a = *vector::borrow(&v, 0);
        let b = *vector::borrow(&v, 1);
        let sum_rest = 0u8;
        let i = 2;
        while (i < len) {
            sum_rest = sum_rest + *vector::borrow(&v, i);
            i = i + 1;
        };
        a + b + sum_rest
    }
}


//# run 0xCAFE::AdvancedPatterns::assign_variant_value


//# run 0xCAFE::AdvancedPatterns::while_false_condition


//# run 0xCAFE::AdvancedPatterns::destructure_with_range_pattern


// Featurres:
// f1bad3b8c140930e36c8363db664e2d5: Assign values to attributes using the Assigned variant.
// 51cf5acfd94ca60fc9bc9ae924d26101: Test that a while loop with a false condition does not execute and the variable retains its initial value.
// 6979f3dd022cb1cd7a48360a6df86d9c: Support destructuring assignment patterns with range (slice) elements in LValues for more flexible matching.
