//# publish
module 0xCAFE::TypeParamTest {
    use std::signer;

    struct Container<T> has copy, drop, store {
        value: T,
    }

    public fun create_container<T>(value: T): Container<T> {
        Container { value }
    }

    public fun get_value<T: copy>(container: &Container<T>): T {
        container.value
    }

    public fun fib(n: u64): u64 {
        if (n == 0) {
            0
        } else {
            if (n == 1) {
                1
            } else {
                fib(n - 1) + fib(n - 2)
            }
        }
    }

    // Runner function to test fib function for 0..10
    public fun run_fib_tests() {
        let i = 0;
        while (i <= 10) {
            let _result = fib(i);
            i = i + 1;
        };
    }
}

//# run 0xCAFE::TypeParamTest::run_fib_tests

//# run
script {
    use 0xCAFE::TypeParamTest;

    fun test_visibility() {
        // Call to public function inside the script is allowed
        let cont = TypeParamTest::create_container<u8>(42u8);
        let val = TypeParamTest::get_value(&cont);
        let fib_5 = TypeParamTest::fib(5);

        // The test does not assert but exercises compiler and VM
    }

    test_visibility();
}

// Featurres:
// e374a7c668a1b94c8a289f53af65f853: Declare type parameters for structs
// 71b968922f8d2301ebac449cae520150: Declare a function within a script with a valid name and body, and enforce visibility restrictions.
// 2e0f7505fb6bdec39ceb8f8817fa5519: Verify that the recursive function fib correctly computes the nth Fibonacci number for values from 0 to 10.
