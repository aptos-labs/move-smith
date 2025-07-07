//# publish
module 0xabcde::nested_calls_test {
    public fun multiply(a: u64, b: u64): u64 {
        a * b
    }

    public fun subtract(x: u64, y: u64): u64 {
        x - y
    }

    public fun compute_value(): u64 {
        let result: u64;
        let temp1: u64;
        let temp2: u64;
        let temp3: u64;

        // Assign and evaluate nested functions with complex expressions
        temp1 = multiply({ // 2 * (3 + 4) => 2 * 7 = 14
            let inner_add = 3 + 4;
            multiply(2, inner_add)
        }, 5); // 14 * 5 = 70

        temp2 = subtract({ // (20 - (2 + 3)) * 2 => (20 - 5) * 2 = 15 * 2 = 30
            let inner_add = 2 + 3;
            subtract(20, inner_add)
        }, 0); // subtract 0 to test variable retention

        temp3 = multiply({ // (temp1 + temp2) * (temp2 + 1) => (70 + 30) * 31 = 100 * 31 = 3100
            let sum = temp1 + temp2;
            multiply(sum, temp2 + 1)
        };

        result = temp3;

        result
    }
}

//# run 0xabcde::nested_calls_test::compute_value