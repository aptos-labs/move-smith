//# publish
module 0xABC::nested_control {
    // Module to test nested control flow with nested loops and conditionals
    fun initialize_counter(): u64 {
        0
    }

    fun increment(): u64 {
        1
    }

    public fun run_nested_loops(): u64 {
        let total = initialize_counter();

        // Outer for loop from 0 to 3
        for (i in 0..4) {
            total = total + increment();

            // Inner while loop, runs until total reaches 10
            while (total < 10) {
                total = total + 2;
            }
        }

        // After loops, total should be 10 or more
        total
    }

    // Runner function to execute the nested flow
    public fun execute(): u64 {
        run_nested_loops()
    }
}

//# run 0xABC::nested_control::execute

//# publish
module 0xDEF::control_flow_test {
    // Module to test complex nested control flow with multiple level interactions
    fun start_value(): u64 {
        2
    }

    fun add_value(x: u64): u64 {
        x + 4
    }

    public fun perform_operations(): u64 {
        let val = start_value();
        let counter = 0;

        // while loop to run 3 times
        while (counter < 3) {
            val = add_value(val); // val increases by 4 each iteration
            // nested for loop inside while
            for (j in 0..3) {
                if (j == 2) {
                    // break early if j==2
                    break;
                }
                // do nothing, just to test execution
            }
            counter = counter + 1;
        }

        // After loops, val should be 2 + 4*3 = 14
        assert!(val == 14, 100);
        val
    }

    // Runner to call main logic
    public fun run(): u64 {
        perform_operations()
    }
}

//# run 0xDEF::control_flow_test::run

//# publish
module 0x123::bitwise_arith {
    // Module to test 256-bit arithmetic operations
    fun max_value(): u256 {
        115792089237316195423570985008687907853269984665640564039457584007913129639935u256
    }

    fun one(): u256 {
        1u256
    }

    public fun test_addition(): bool {
        let max = max_value();
        max + 0u256 == max
    }

    public fun test_subtraction(): bool {
        let max = max_value();
        max - 0u256 == max
    }

    public fun test_multiplication(): bool {
        let two = 2u256;
        two * two == 4u256
    }

    public fun test_division(): bool {
        let num = 100u256;
        let denom = 4u256;
        num / denom == 25u256
    }

    public fun test_modulus(): bool {
        let num = 10u256;
        let denom = 3u256;
        num % denom == 1u256
    }
}

//# run 0x123::bitwise_arith::test_addition
//# run 0x123::bitwise_arith::test_subtraction
//# run 0x123::bitwise_arith::test_multiplication
//# run 0x123::bitwise_arith::test_division
//# run 0x123::bitwise_arith::test_modulus

//# publish
module 0x456::overflow_tests {
    // Module to verify overflow behavior
    fun get_one(): u256 {
        1u256
    }

    public fun test_overflow_add(): bool {
        let max = 115792089237316195423570985008687907853269984665640564039457584007913129639935u256;
        // Adding 1 should overflow, but in Move this should trap or revert
        max + get_one() == /* expecting revert or trap */
        // Not reached, so no assertion here
        false
    }

    public fun test_overflow_mul(): bool {
        let max = 115792089237316195423570985008687907853269984665640564039457584007913129639935u256;
        // Multiplying max by 2 should overflow
        max * 2u256 == /* expecting revert or trap */
        false
    }

    // These tests are expected to cause revert/trap, script to verify behavior
}

//# run 0x456::overflow_tests::test_overflow_add --args
//# run 0x456::overflow_tests::test_overflow_mul --args

//# publish
module 0x789::public_function_return {
    // Module to test returning value after variable assignment
    public fun assign_and_return(): u64 {
        let v = 5;
        v = 10;
        v
    }
}

//# run 0x789::public_function_return::assign_and_return
