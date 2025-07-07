
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

        let c = if exists_assigned(assign_value) {
            let v = match assign_value {
                AssignEnum::Assigned(val) => val,
                _ => 0u8,
            };
            Container {value: c.value, assigned_val: v}
        } else {
            c
        };
        c
    }

    public fun exists_assigned(assign_value: AssignEnum): bool {
        let res = match assign_value {
            AssignEnum::Assigned(_) => true,
            _ => false,
        };
        res
    }

    public fun while_false_condition(): u64 {
        let counter = 100u64;
        while false {
            counter = 0;
        };
        counter
    }

    public fun destructure_with_range_pattern(): u8 {
        let v = vector[10u8, 20u8, 30u8, 40u8, 50u8];
        let len = vector::length(&v);
        let a = *vector::borrow(&v, 0);
        let b = *vector::borrow(&v, 1);
        let sum_rest = 0u8;
        let i = 2;
        while i < len {
            sum_rest = sum_rest + *vector::borrow(&v, i);
            i = i + 1;
        };
        a + b + sum_rest
    }
}
