//# publish
module 0xabc::arith_tests {
    // Basic arithmetic functions for 256-bit unsigned integers.
    public fun add256(a: u256, b: u256): u256 {
        a + b
    }

    public fun sub256(a: u256, b: u256): u256 {
        a - b
    }

    public fun mul256(a: u256, b: u256): u256 {
        a * b
    }

    public fun div256(a: u256, b: u256): u256 {
        // The division by zero will revert automatically.
        a / b
    }

    public fun mod256(a: u256, b: u256): u256 {
        // The modulus by zero will revert automatically.
        a % b
    }

    // Function to test nested arithmetic operations involving local modifications.
    public fun run_tests(): () {
        let initial = 200u256;
        let x = initial;
        let y = initial;

        // Perform addition and subtraction with local variable modification
        let sum1 = add256({ x = sub256(x, 50u256); x + 25u256 }, { y = add256(y, 75u256); y - 25u256 });
        // After sub256, x = 150; after add256 y = 275
        // sum1 = (150 + 25) + (275 - 25) = 175 + 250 = 425

        // Multiply current x and y after modifications
        let product = mul256({ x = add256(x, 10u256); x * 2u256 }, { y = sub256(y, 100u256); y * 2u256 });
        // x = 160; y = 175
        // product = 2 * 160 * 2 * 175 = 2 * 160 * 350 = 112000

        // Final sum involving previous computations
        let final_result = add256(sum1, product);
        // final_result = 425 + 112000 = 112425

        // Return final result
        final_result
    }

    // Runner function to execute the test
    public fun run(): () {
        run_tests()
    }
}

 //# run 0xabc::arith_tests::run
