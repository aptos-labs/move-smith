//# publish
module 0xCAFE::U128Math {
    use std::signer;

    /// Add two u128 numbers
    public fun add_(a: u128, b: u128): u128 {
        a + b
    }

    /// Subtract b from a
    public fun sub_(a: u128, b: u128): u128 {
        a - b
    }

    /// Multiply two u128 numbers
    public fun mul_(a: u128, b: u128): u128 {
        a * b
    }

    /// Divide a by b
    public fun div_(a: u128, b: u128): u128 {
        assert!(b != 0, 1);
        a / b
    }

    /// Modulus a by b
    public fun mod_(a: u128, b: u128): u128 {
        assert!(b != 0, 2);
        a % b
    }

    /// Runner function with no args to exercise valid operations
    public fun runner(): u128 {
        let a = 123456789012345678901234567890u128;
        let b = 98765432109876543210987654321u128;
        // add, sub, mul, div, mod in sequence
        let sum = add_(a, b);
        let diff = sub_(a, b);
        let prod = mul_(a, b);
        let quot = div_(a, 123456789u128);
        let rem = mod_(a, 12345u128);
        sum + diff + prod + quot + rem
    }
}

//# run 0xCAFE::U128Math::runner

//# publish
module 0xCAFE::OverflowTest {
    /// Function that deliberately triggers addition overflow (which aborts)
    public fun add_overflow(): u128 {
        let max = 340282366920938463463374607431768211455u128; // max u128 = 2^128 - 1
        // This addition must overflow and abort
        max + 1
    }

    /// Function that deliberately triggers subtraction underflow (which aborts)
    public fun sub_underflow(): u128 {
        // underflow: 0 - 1 aborts
        0u128 - 1u128
    }

    /// Function that deliberately triggers division by zero abort
    public fun div_zero(): u128 {
        10u128 / 0u128
    }

    /// Function that deliberately triggers modulus by zero abort
    public fun mod_zero(): u128 {
        10u128 % 0u128
    }

    /// Runner function to invoke all failing cases (will abort on first)
    public fun runner(): bool {
        // We cannot catch aborts, so just call in sequence to test compiler and VM
        let _ = add_overflow();
        let _ = sub_underflow();
        let _ = div_zero();
        let _ = mod_zero();
        true
    }
}

//# run 0xCAFE::OverflowTest::add_overflow

//# run 0xCAFE::OverflowTest::sub_underflow

//# run 0xCAFE::OverflowTest::div_zero

//# run 0xCAFE::OverflowTest::mod_zero

//# publish
module 0xCAFE::NamedAddressTest {
    use std::vector;
    use std::string;

    // function to just return a vector of addresses passed in, no args required
    public fun runner(): vector<u8> {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 0xCAu8);
        vector::push_back(&mut v, 0xFEu8);
        vector::push_back(&mut v, 0xBAu8);
        vector::push_back(&mut v, 0xBEu8);
        v
    }
}

//# run 0xCAFE::NamedAddressTest::runner

//# run 0xCAFE::U128Math::add_ --args 100u128 200u128

//# run 0xCAFE::U128Math::sub_ --args 1000u128 500u128

//# run 0xCAFE::U128Math::mul_ --args 1234u128 5678u128

//# run 0xCAFE::U128Math::div_ --args 1000u128 10u128

//# run 0xCAFE::U128Math::mod_ --args 1000u128 7u128

// Named addresses used in script syntax:
//# run <Named=0xCAFE>  // Demonstrate named address assignment syntax for scripts

// Featurres:
// 71f6838867cd49cfda14b3b0fd4c527d: Verify an individual compiled unit for correctness.
// 073f9fa50702d32afd0553da145c72b6: Test the correct handling of 128-bit unsigned integer arithmetic operations, including addition, subtraction, multiplication, division, and modulus, ensuring proper behavior for normal cases, edge cases, and invalid/overflow scenarios that should cause failures.
// a2b70d38fcc1dd9baefb9e9fce56ae0a: Define named addresses in Move scripts using the syntax `<name>=<address>`.
