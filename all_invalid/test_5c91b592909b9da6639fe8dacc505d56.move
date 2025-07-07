//# publish
module 0xabcde::nested_calls {
    public fun multiply(a: u64, b: u64): u64 {
        a * b
    }

    public fun subtract(a: u64, b: u64): u64 {
        a - b
    }

    public fun compute(): u64 {
        let base = 5;
        let step1 = multiply({ base = base + 2; base }, { base = base - 1; base });
        let step2 = subtract({ base = step1 + 4; base }, { base = step1 / 2; base });
        let step3 = multiply({ base = step2 * 3; base }, { base = step2 + 1; base });
        step3
    }
}

//# run 0xabcde::nested_calls::compute

    //# publish
module 0xabcde::assignment_in_expressions {
    public fun nested_assignments(): u64 {
        let result = 0;
        let temp = 10;
        // assign temp to result after modifying it in nested expressions
        result = { let temp_value = temp + 5; temp_value };
        // reassign temp based on previous value
        temp = { let temp_value = temp * 2; temp_value };
        // final calculation involving previous variables
        let final_result = result + temp;
        final_result
    }
}

//# run 0xabcde::assignment_in_expressions::nested_assignments

    //# publish
module 0xabcde::complex_variable_management {
    public fun test_assignments(p: u64): u64 {
        let a = p;
        let b = a + 3;
        let c = b * 2;

        let mut d = c;
        // Reassign d multiple times
        d = d - 4;
        d = d + 7;

        // Final computation: sum all variables
        let total = a + b + c + d;
        total
    }
}

//# run 0xabcde::complex_variable_management::test_assignments --signers 0x1 --args 15u64
