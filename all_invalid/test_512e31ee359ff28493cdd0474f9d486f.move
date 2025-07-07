//# publish
module 0xdead::OverflowDivisionShift {
    use std::vector;

    fun test_overflow_u8(): bool {
        let v = vector<u8>[1 << 8, 255 + 1, 1 << 4 + 4];
        // The first should abort due to overflow in shift.
        // The second should abort due to addition overflow.
        // The third is valid (16)
        // We won't reach here if abort happens, but for compile correctness:
        true
    }

    fun test_division_by_zero(): bool {
        let v = vector<u16>[1 / 0, 12345 % 0];
        // Should abort due to division/modulo by zero.
        true
    }

    fun test_out_of_range_shift(): bool {
        let value: u32 = 1;
        let shift_amount = 32; // shifting by full width
        // Should abort due to out-of-range shift
        value << shift_amount
        true
    }

    fun main() {
        // These vector element expressions should abort during execution.
        // Testing overflow in u8 shift
        let _ = test_overflow_u8();
        // Testing division/modulo by zero
        let _ = test_division_by_zero();
        // Testing out-of-range shift
        let _ = test_out_of_range_shift();

        // Additional nested block test: verify order of operations
        let sum = {
            let mut total = 0;
            { total = total + 1; } // inner block
            { total = total + 10; }
            total
        };
        assert!(sum == 11, 1);
    }
}
//# run 0xdead::OverflowDivisionShift::main