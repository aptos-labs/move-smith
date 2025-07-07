//# publish
module 0x1::AccessTest {
    // Public module with different access level functions and constants

    // Public constant
    public const PUB_CONST: u64 = 100;

    // Private constant
    const PRIV_CONST: u64 = 200;

    // Public function
    public fun public_func(): u64 {
        PUB_CONST
    }

    // friend function (no friend support in Aptos Move currently, emulate with private)
    fun private_func(): u64 {
        PRIV_CONST
    }

    // Internal function (private)
    fun internal_func(): u64 {
        42
    }

    // Public function calling internal function
    public fun call_internal(): u64 {
        internal_func()
    }

    // Runner function with no arguments
    public fun run() {
        let a: u64 = public_func();
        let b = private_func();
        let c = call_internal();
        let _sum = a + b + c;
    }
}
//# run 0x1::AccessTest::run

//# publish
module 0x1::LocalBindings {
    use std::vector;

    public fun test_let_bindings() {
        // let without type annotation, with initializer
        let a = 10u64;

        // let with type annotation and initializer
        let b: u64 = 20;

        // let with type annotation without initializer (must provide initializer in Move)
        let c: u64 = 30;

        // let with complex type
        let v: vector<u8> = vector::empty<u8>();

        // let without type and no initializer is invalid in Move, so skip that case.

        // dummy usage to avoid warnings
        let _sum = a + b + c + (vector::length(&v) as u64);
    }

    // Runner function
    public fun run() {
        test_let_bindings();
    }
}
//# run 0x1::LocalBindings::run

//# publish
module 0x1::LoopInvariantTest {
    /// This function demonstrates a while loop with a loop invariant:
    /// the variable counter is always less or equal to max.
    public fun while_with_invariant(max: u64) {
        let mut counter: u64 = 0;

        // Loop invariant: counter <= max
        while (counter < max) 
        /* invariant counter <= max */
        {
            counter = counter + 1;
        }
    }

    /// Run a loop with invariant zero times, then nonzero times.
    public fun run() {
        while_with_invariant(0);
        while_with_invariant(5);
    }
}
//# run 0x1::LoopInvariantTest::run

//# run
script {
    use 0x1::AccessTest;
    use 0x1::LocalBindings;
    use 0x1::LoopInvariantTest;

    fun main(account: &signer) {
        // Call public functions from AccessTest module
        let val = AccessTest::public_func();
        let val2 = AccessTest::call_internal();

        // Call LocalBindings test function
        LocalBindings::test_let_bindings();

        // Call LoopInvariantTest with some value
        LoopInvariantTest::while_with_invariant(3);
    }
}