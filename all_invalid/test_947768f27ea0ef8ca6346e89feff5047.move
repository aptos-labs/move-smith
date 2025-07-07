//# publish
module 0x01::nested_loop_test {
    fun run_nested_break_test() {
        // Outer loop which will be broken out of
        let mut count = 0;
        loop {
            // Inner loop which breaks when count reaches 2
            let mut inner_count = 0;
            loop {
                if (inner_count >= 2) {
                    break; // Break inner loop
                };
                inner_count = inner_count + 1;
            };
            // After inner loop, increment outer count
            count = count + 1;
            if (count >= 3) {
                break; // Break outer loop after 3 iterations
            };
        };
    }
}

 //# run 0x01::nested_loop_test::run_nested_break_test --signers 0x01

//# publish
module 0x02::enum_access_test {
    enum Status has drop {
        Success(u8),
        Failure(u8),
    }

    fun get_first_code(s: Status): u8 {
        match s {
            Status::Success(code) => code,
            Status::Failure(code) => code,
        }
    }

    fun test_enum_access() {
        let s1 = Status::Success(10);
        let s2 = Status::Failure(20);
        let val1 = get_first_code(s1);
        let val2 = get_first_code(s2);
        // Use the values in some way to ensure code is exercised
        assert!(val1 == 10, 0);
        assert!(val2 == 20, 0);
    }
}

 //# run 0x02::enum_access_test::test_enum_access --signers 0x02

//# publish
module 0x03::function_apply_test {
    public inline fun multiply(x: u64, y: u64): u64 {
        x * y
    }

    public inline fun subtract(x: u64, y: u64): u64 {
        x - y
    }

    fun composite_apply(): u64 {
        // Apply multiply(3, 4) then subtract 2
        let result = apply(multiply, 3, 4);
        apply(subtract, result, 2)
    }

    public fun apply(f: |u64, u64|u64, x: u64, y: u64): u64 {
        f(x, y)
    }
}

//# run 0x03::function_apply_test::composite_apply --signers 0x03
