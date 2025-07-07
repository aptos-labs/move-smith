//# publish
module 0xabcde::counter {
    fun inc(x: &mut u64, y: u64): u64 {
        *x = *x + y;
        *x
    }

    public fun test(): u64 {
        let mut total = 10;
        let first_call = inc(&mut total, 3);
        let second_call = inc(&mut total, 4);
        let third_call = inc(&mut total, 5);
        // Return the sum of all updated values to verify in-place mutations
        first_call + second_call + third_call
    }
}

//# run 0xabcde::counter::test