//# publish
module 0xCAFE::LoopSpecTest {
    use std::signer;
    use std::vector;
    use std::account;

    /// A simple struct to store the loop count in storage
    struct Counter has copy, drop, store, key {
        value: u64,
    }

    /// Save the counter resource under the signer
    public fun init_account(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    /// Function using a while loop to increment from 0 to 9
    public fun count_to_ten(): u64 {
        let mut i = 0u64;
        let mut sum = 0u64;
        while (i < 10) {
            sum = sum + i;
            i = i + 1;
        }
        sum
    }

    /// A function with an explicit specification snippet
    spec count_to_ten {
        ensures result >= 0;
    }

    /// Function that uses a block as the function body
    /// Counting down from n to 1 and summing the numbers
    public fun countdown_sum(n: u64): u64 {
        {
            let mut acc = 0u64;
            let mut i = n;
            while (i > 0) {
                acc = acc + i;
                i = i - 1;
            }
            acc
        }
    }

    /// Specification snippet with a loop invariant
    spec countdown_sum {
        ensures result >= 0;
    }

    /// Runner function that calls the two loop functions and returns their sum
    public fun runner(): u64 {
        // call count_to_ten and countdown_sum(5)
        let a = count_to_ten();
        let b = countdown_sum(5);
        a + b
    }
}
//# run 0xCAFE::LoopSpecTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::LoopSpecTest;

    fun main(account: signer) {
        // Initialize counter resource under signer to test move_to
        LoopSpecTest::init_account(&account);

        // Call count_to_ten and countdown_sum separately and ignore return values
        let _ = LoopSpecTest::count_to_ten();
        let _ = LoopSpecTest::countdown_sum(3);

        // Call runner to test combined logic and VM execution
        let _result = LoopSpecTest::runner();
    }
}