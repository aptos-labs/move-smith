//# publish
module 0xCAFE::SpecTest {
    /// Mutable variable stored in global storage.
    struct Data has key {
        x: u64,
    }

    /// Initializes data under the sender's account with a given value.
    public fun init(signer: &signer, value: u64) {
        move_to(signer, Data { x: value });
    }

    /// Increment the stored `x` field by the given value.
    public fun inc(addr: address, value: u64) acquires Data {
        let data_ref = borrow_global_mut<Data>(addr);
        data_ref.x = data_ref.x + value;
    }

    /// Returns the current value of x.
    public fun get(addr: address): u64 acquires Data {
        let data_ref = borrow_global<Data>(addr);
        data_ref.x
    }

    /// Public runner to test mutable updates through multiple increments, then get.
    public fun test(addr: address): u64 acquires Data {
        Self::inc(addr, 2);
        Self::inc(addr, 3);
        Self::get(addr)
    }

    ///////////////
    // Spec area //
    ///////////////

    // Spec block for Data struct
    spec Data {
        /// Invariant ensuring x is always non-negative (u64, always true here, for demo).
        invariant x >= 0;
    }

    // Spec block for module itself
    spec module {
        /// A spec constant, not used in code but generated.
        const INIT_DEFAULT: u64 = 42;
    }

    // Spec function using a lambda.
    spec fun is_even(input: u64): bool {
        // Example of inline lambda: |y: u64| y % 2 == 0
        (|y: u64| y % 2 == 0)(input)
    }

    // Another example: sum with a lambda, auto inlined.
    spec fun add_5(input: u64): u64 {
        (|y: u64| y + 5)(input)
    }

    // Use the is_even lambda in property for demonstration.
    spec get {
        ensures is_even(result) ==> result % 2 == 0;
    }

    // Use the add_5 lambda as well, even though not called at runtime.
    spec test_lambda_expansion {
        let x: u64 = 13;
        let res: u64 = add_5(x);
        // ensures that the transformation through lambda works
        ensures res == x + 5;
    }
}

//# run
script {
    use 0xCAFE::SpecTest;

    fun main(account: &signer) {
        SpecTest::init(account, 10);
    }
}

//# run 0xCAFE::SpecTest::inc --signers 0xCAFE --args 0xCAFE 5u64

//# run 0xCAFE::SpecTest::test --signers 0xCAFE --args 0xCAFE

//# run
script {
    use 0xCAFE::SpecTest;

    fun main(addr: address) {
        let val = SpecTest::get(addr);
    }
}

// Featurres:
// 0d69a082e67405f49fd062fefa73e547: Write Move spec functions using lambda expressions and have them automatically expanded and generated during compilation and inlining.
// 3f13ce440f07cbea3618b56d96c806bc: Add specification constructs such as invariants and other specs within modules.
// 3ec81caac0abb53d66246c0ca58d1ffe: Test that calling the `test` function correctly updates and aggregates the mutable variable `x` through multiple calls to `inc`, demonstrating proper in-place mutation and accumulation.
