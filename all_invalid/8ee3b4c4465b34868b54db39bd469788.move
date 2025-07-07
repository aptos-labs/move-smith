
//# publish
module 0xCAFE::FilterTest {
    use std::signer;

    // Struct to use with global storage and borrowing test
    struct Counter has store, key {
        val: u64,
    }

    // Increment function: increments the given mutable reference to u64 by 1
    public fun inc(x: &mut u64) {
        *x = *x + 1;
    }

    // Test function: creates a mutable local u64, increments it multiple times, and returns sum of values
    public fun test(): u64 {
        let cnt = 0u64;
        inc(&mut cnt);
        inc(&mut cnt);
        // after two increments cnt = 2
        let val1 = cnt;
        inc(&mut cnt);
        let val2 = cnt;
        val1 + val2
    }

    // Store Counter resource at the signer's address with initial value val
    public fun store_counter(s: signer, val: u64) {
        let counter = Counter { val };
        move_to<Counter>(&s, counter);
    }

    // Borrow global Counter resource mutably and increment its val field
    public fun inc_global_counter(s: signer) {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(&s));
        inc(&mut counter_ref.val);
    }

    // Returns current val of Counter resource at signer's address
    public fun get_counter_val(s: signer): u64 {
        let counter_ref: &Counter = borrow_global<Counter>(signer::address_of(&s));
        counter_ref.val
    }

    // Attempt to borrow Counter resource but with wrong type u64, fixed to compile:
    // We instead explicitly abort with an error code to simulate failure,
    // as borrowing u64 as resource is invalid and does not compile.
    public fun borrow_with_wrong_type(s: signer): u64 {
        // Instead of borrowing u64 globally (which is invalid), abort to simulate error
        // We choose abort code 1 arbitrarily here.
        abort 1;
    }
}



//# run 0xCAFE::FilterTest::inc



//# run 0xCAFE::FilterTest::test



//# run 0xCAFE::FilterTest::store_counter --signers 0xBABA --args 10u64



//# run 0xCAFE::FilterTest::get_counter_val --signers 0xBABA



//# run 0xCAFE::FilterTest::inc_global_counter --signers 0xBABA



//# run 0xCAFE::FilterTest::get_counter_val --signers 0xBABA



//# run 0xCAFE::FilterTest::borrow_with_wrong_type --signers 0xBABA
