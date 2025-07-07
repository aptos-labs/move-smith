//# publish
module 0xabcde::test_module {
    public fun check_negation(p: bool): bool {
        // Use negation and compound assignment to invert p, then evaluate combined expression
        (!p && {p = p && false; p}) || {p = !p; !p}
    }

    public fun verify_sum(): u64 {
        // Compute sum of local variables with updates
        let a = 4;
        let b = 5;
        let c = 6;
        a + {b = b + 10; b} + {c = c - 2; c}
    }

    public fun state_manipulation(): u64 {
        // Test updates within nested blocks
        let x = 10;
        (x + {x = x + 3; x - 2}) + {x = x * 2; x}
    }

    public fun complex_expression(p: bool): bool {
        // Combine negation, assignments, and nested blocks
        let result = (!p && {let temp = p || true; temp}) || {p = !p; p};
        result
    }

    public fun main() {
        // Call all functions to verify behavior
        assert!(check_negation(true) == false, 1);
        assert!(check_negation(false) == true, 2);
        assert!(verify_sum() == 15, 3);
        assert!(state_manipulation() == 26, 4);
        assert!(complex_expression(false) == true, 5);
    }
}

//# run 0xabcde::test_module::main