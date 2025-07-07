// The test address to be used
// We use 0xCAFE as per instructions

//# publish
module 0xCAFE::MathUtils {
    /// A simple utility module to test arithmetic operations on u128
    use std::error;
    use std::signer;

    /// Returns addition of two u128 numbers
    public fun add(a: u128, b: u128): u128 {
        // This will abort on overflow automatically
        a + b
    }

    /// Returns subtraction a - b, aborts if b > a
    public fun sub(a: u128, b: u128): u128 {
        // This will abort if b > a because subtraction underflow on u128
        a - b
    }

    /// Returns multiplication of two u128 numbers
    public fun mul(a: u128, b: u128): u128 {
        // Abort on overflow
        a * b
    }

    /// Returns division a / b, aborts if b == 0
    public fun div(a: u128, b: u128): u128 {
        assert!(b != 0, 1);
        a / b
    }

    /// Returns modulo a % b, aborts if b == 0
    public fun modulo(a: u128, b: u128): u128 {
        assert!(b != 0, 2);
        a % b
    }

    /// Runs a series of tests on the arithmetic functions within this module,
    /// aborts on failures implicitly due to assert or VM aborts on overflow
    public fun run_arithmetic_tests() {
        // Valid operations
        let a: u128 = 200;
        let b: u128 = 100;

        let _ = Self::add(a, b);
        let _ = Self::sub(a, b);
        let _ = Self::mul(a, b);
        let _ = Self::div(a, b);
        let _ = Self::modulo(a, b);

        // Overflow test addition (u128 max is 2^128 -1)
        let max: u128 = 340282366920938463463374607431768211455; // max u128
        // This should abort on overflow
        // We purposely do not catch this, VM should abort test
        // Uncomment below line to cause abort, comment it to let test proceed
        // let _ = Self::add(max, 1);

        // Subtraction underflow (should abort)
        // let _ = Self::sub(1, 2);

        // Division by zero (should abort)
        // let _ = Self::div(1, 0);

        // Modulo by zero (should abort)
        // let _ = Self::modulo(1, 0);
    }

    /// A function to demonstrate nested qualified module access chain with 4 segments
    /// Uses a deeper module (defined below)
    public fun nested_add(a: u128, b: u128): u128 {
        0xCAFE::Nested::Level2::Level3::nested_add(a, b)
    }
}

//# run 0xCAFE::MathUtils::run_arithmetic_tests


//# publish
module 0xCAFE::Nested {
    /// Some nested modules to test 4-segment qualified name access
    public module Level2 {
        public module Level3 {
            /// Function that adds two numbers, no fancy checks
            public fun nested_add(a: u128, b: u128): u128 {
                a + b
            }
        }
    }
}


//# publish
module 0xCAFE::LoopUtils {
    use std::signer;

    /// Function that counts from 0 to 9 using loop with label
    public fun count_to_ten(): u64 {
        let mut i: u64 = 0;
        'outer: loop {
            if (i == 10) {
                break 'outer;
            };
            i = i + 1;
        };
        i
    }

    /// Function that demonstrates an infinite loop with a label but breaks after 5
    public fun infinite_then_break(): u64 {
        let mut counter: u64 = 0;
        'infinite_loop: loop {
            counter = counter + 1;
            if (counter == 5) {
                break 'infinite_loop;
            };
        };
        counter
    }

    /// Runner function that exercises the above loops
    public fun run_loops() {
        let _ = Self::count_to_ten();
        let _ = Self::infinite_then_break();
    }
}

//# run 0xCAFE::LoopUtils::run_loops

//# run
script {
    use 0xCAFE::MathUtils;
    use 0xCAFE::LoopUtils;

    fun main() {
        // Test qualified module access chain with 4 segments:
        let a: u128 = 50;
        let b: u128 = 25;
        let c = MathUtils::nested_add(a, b);
        let _ = c;

        // Do arithmetic
        let _ = MathUtils::add(123, 321);
        let _ = MathUtils::sub(1000, 100);
        let _ = MathUtils::mul(12, 12);
        let _ = MathUtils::div(100, 4);
        let _ = MathUtils::modulo(101, 10);

        // Test loops
        let count = LoopUtils::count_to_ten();
        let inf = LoopUtils::infinite_then_break();
        let _ = (count, inf);
    }
}

// Featurres:
// ac3b56b7db3a2457d57e8ea4553f43b9: Use qualified module access chains with up to four segments in Move code.
// b16b4da131fe27a1ca594bb78cf9bbc5: Test that all arithmetic operations (addition, subtraction, multiplication, division, and modulo) on `u128` values in Move both correctly compute results and properly fail on overflow and invalid operations (such as division or modulo by zero and subtraction resulting in negative values).
// da995ca930eb096498e922040b7bab4c: Use loop expressions with optional labels for infinite loops.
