//# publish
module 0xabcde::increment_test {
    // This module contains functions to test incrementing and complex value manipulations
    public fun inc(x: &mut u64): u64 {
        *x = *x + 1;
        *x
    }

    public fun combined_increment(): u64 {
        let mut counter = 0;
        let first = inc(&mut counter);
        let second = inc(&mut counter);
        let total = first + second + counter;
        total
    }

    public fun run_combined(): u64 {
        combined_increment()
    }

    public fun modify_and_test(): bool {
        let mut a = 10;
        let b = inc(&mut a);
        let c = inc(&mut a);
        let sum = a + b + c;
        // after increments, a should be 12, b=11, c=12
        sum == 12 + 11 + 12
    }
}

//# run 0xabcde::increment_test::run_combined

//# run 0xabcde::increment_test::modify_and_test

//# publish
module 0xfedcb::complex_manipulation {
    // Function that manipulates nested structures and arithmetic to verify complex interactions
    public fun test(): u64 {
        let x = 5;
        let y = {x = x * 2; x + 3};
        let z = {x = y + 4; x};
        let w = {x = z - 2; x};
        // w = (( (x*2)+3)+4 ) - 2
        w
    }
}

//# run 0xfedcb::complex_manipulation::test

//# publish
module 0x12345::variable_reassignment {
    // Test that reassigning a variable invalidates previous copies and affects comparison
    public fun test(p: u64): bool {
        let a = p;
        let _b = a;
        let c = _b;

        _b = p + 2; // reassign to break the copy chain
        // check if a remains equal to c (it should, as a is unchanged)
        a == c
    }

    public fun main() {
        assert!(test(42), 0);
        assert!(test(100), 0);
    }
}

//# run 0x12345::variable_reassignment::main