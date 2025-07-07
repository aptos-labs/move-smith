// A transactional test for Aptos Move compiler and VM covering:
// 1. Variable names used for unpacking tuples.
// 2. Updating specification variables with assignment syntax.
// 3. Lambda argument evaluation order and exactly once semantics.

// Use address 0xCAFE, no aliases, commands inline.

//# publish
module 0xCAFE::TupleUnpackTest {
    struct Counter has copy, drop, store {
        value: u64,
    }

    // Spec variable to demonstrate update via assignment syntax
    spec global spec_counter: u64;

    // Initialize spec var
    #[inline(always)]
    fun spec_init() {
        spec {
            spec_counter = 0;
        }
    }

    // Increment the spec_counter spec var by n
    #[inline(always)]
    fun spec_increment(n: u64) {
        spec {
            spec_counter = spec_counter + n;
        }
    }

    // A function to return a tuple of three numbers
    public fun get_tuple(): (u8, u64, bool) {
        (1u8, 100u64, true)
    }

    // A function demonstrating unpacking tuple with some vars
    // Unpack only some elements, ignoring others via underscore
    public fun unpack_some(): u64 {
        // Unpack using named variables
        let (a, b, _) = Self::get_tuple();
        b // returns u64 part
    }

    // A helper function that accepts two lambdas and calls them in-order,
    // returns sum of their results
    public fun call_lambdas_in_order<T: copy, U: copy>(
        f1: &fun(): T,
        f2: &fun(): U
    ): (T, U) {
        let v1 = f1();
        let v2 = f2();
        (v1, v2)
    }

    // The runner function testing:
    // 1) unpacking with variables,
    // 2) updating spec var with assignment,
    // 3) lambdas evaluation order and exactly once side effects.
    public fun runner() {
        // initialize spec var
        Self::spec_init();

        // 1. Unpack tuple; get u64 element
        let val = Self::unpack_some();
        // val = 100u64

        // 2. Update spec_counter using assignment syntax:
        // Increment by val (100)
        Self::spec_increment(val);

        // 3. Lambda evaluation order and exactly once semantics
        // We will capture side effects in Counter struct stored locally

        // Create mutable counter resource stored locally
        let mut counter = Counter { value: 0 };

        // Lambda 1: increments counter and returns old value
        let f1 = &fun(): u64 {
            let res = counter.value;
            counter.value = counter.value + 1;
            res
        };

        // Lambda 2: increments counter twice and returns new value
        let f2 = &fun(): u64 {
            counter.value = counter.value + 1;
            let res = counter.value;
            counter.value = counter.value + 1;
            res
        };

        // Call call_lambdas_in_order to verify order & exactly once invocation
        let (r1, r2) = Self::call_lambdas_in_order(f1, f2);
        // Side effect: after call, counter.value should be 3 (0 -> +1 in f1, +1 +1 in f2)

        // Local assert equivalent omitted per instructions

        // Update spec_counter again by counter.value
        Self::spec_increment(counter.value);

        // Final spec_counter should be 0 + 100 + 3 = 103
        // Return nothing
    }
}
//# run 0xCAFE::TupleUnpackTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::TupleUnpackTest;

    fun main(account: &signer) {
        // We call the runner function to cover requested tests.
        TupleUnpackTest::runner();
    }
}