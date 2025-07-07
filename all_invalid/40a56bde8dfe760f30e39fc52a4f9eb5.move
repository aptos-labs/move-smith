//# publish
module 0xCAFE::FibModule {
    /// Computes the nth Fibonacci number recursively
    /// fib(0) = 0
    /// fib(1) = 1
    /// fib(n) = fib(n-1) + fib(n-2) for n >= 2
    public fun fib(n: u8): u64 {
        if (n == 0u8) {
            0u64
        } else if (n == 1u8) {
            1u64
        } else {
            // Recursive calls with reducing n
            fib(n - 1u8) + fib(n - 2u8)
        }
    }

    /// Runner function that tests fib from 0 to 10 inclusive.
    /// It just calls the function in a loop, no assertion needed.
    /// This exercises recursive calls and numeric literal usage with suffixes.
    public fun runner() {
        let i = 0u8;
        while (i <= 10u8) {
            let _result = fib(i); // intentionally ignore result
            i = i + 1u8;
        }
    }
}
//# run 0xCAFE::FibModule::runner

//# publish
module 0xCAFE::KeysModule {
    /// A simple struct with copy, drop, store abilities to be used as a module key
    struct MyKey has copy, drop, store, key {
        val: u64,
    }

    /// Publishes an instance of MyKey under sender's account
    public fun create_key(account: &signer) {
        let key = MyKey { val: 0u64 };
        move_to(account, key);
    }

    /// Runner function publishes a MyKey to test module address and name correctness
    public fun runner(account: &signer) {
        create_key(account);
    }
}
//# run 0xCAFE::KeysModule::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::FibModule;
    use 0xCAFE::KeysModule;

    fun main(account: &signer) {
        // Run fib for a few example values explicitly
        let fib_5 = FibModule::fib(5u8);
        let fib_10 = FibModule::fib(10u8);

        // Call KeysModule runner to publish MyKey resource under account 0xCAFE
        KeysModule::runner(account);

        // Just no-ops, no assertions required
        let _ = fib_5;
        let _ = fib_10;
    }
}

// Featurres:
// bf9d6723bbe3a98f8af6efcf0b0e836f: Write typed numeric literals directly as values, such as with a specific suffix.
// 2e0f7505fb6bdec39ceb8f8817fa5519: Verify that the recursive function fib correctly computes the nth Fibonacci number for values from 0 to 10.
// 017b6b6a632470501fba26c324c0fae5: Create module keys with a specific address and module name when both are available.
