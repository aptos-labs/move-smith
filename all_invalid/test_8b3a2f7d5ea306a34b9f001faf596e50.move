//# publish
module 0x01::InlineFunctionTest {
    // Define an inline function that applies a passed-in function to a value, similar to previous example but with different logic
    inline fun apply_and_increment(f: |u64| u64, x: u64): u64 {
        f(x) + 1
    }

    // Main function that tests apply_and_increment with a lambda returning 2
    public fun calculate(): u64 {
        apply_and_increment(|_: u64| 2, 5)
    }

    // Main function with assertion to verify the correct behavior
    public fun main() {
        assert!(calculate() == 3, 6);
    }
}

//# run 0x01::InlineFunctionTest::main

//# publish
module 0x01::RecursivePower {
    // Recursive function to compute power, e.g., base^exponent
    public fun power(base: u64, exponent: u64): u64 {
        if (exponent == 0) {
            1
        } else {
            base * power(base, exponent - 1)
        }
    }

    // Function to test that power computes correct values for 2^0..2^4
    public fun test_power() {
        assert!(power(2, 0) == 1, 0);
        assert!(power(2, 1) == 2, 1);
        assert!(power(2, 2) == 4, 2);
        assert!(power(2, 3) == 8, 3);
        assert!(power(2, 4) == 16, 4);
    }
}

//# run 0x01::RecursivePower::test_power

//# publish
module 0x01::HigherOrder {
    // Higher-order function that takes a function and a value, applies the function multiple times
    fun repeat_apply(f: |u64| u64, x: u64, times: u64): u64 {
        if (times == 0) {
            x
        } else {
            repeat_apply(f, f(x), times - 1)
        }
    }

    // Function to test that applying increment multiple times yields the expected value
    public fun test_repeat() {
        let increment = |v: u64| v + 1;
        assert!(repeat_apply(increment, 0, 5) == 5, 0);
        assert!(repeat_apply(increment, 10, 0) == 10, 0);
        assert!(repeat_apply(increment, 3, 4) == 7, 0);
    }
}

//# run 0x01::HigherOrder::test_repeat
