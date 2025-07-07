//# publish
module 0xabc::incrementor {
    fun inc(x: &mut u64, by: u64): u64 {
        *x = *x + by;
        *x
    }

    // This function runs multiple increments and returns the final value
    public fun perform_increments(): u64 {
        let mut total = 10;
        total = inc(&mut total, 5);
        total = inc(&mut total, 10);
        total = inc(&mut total, 20);
        total
    }
}

//# publish
module 0xabc::calculator {
    use 0xabc::incrementor;

    // Computes the total sum after multiple increments
    public fun compute_sum(): u64 {
        let base = 15;
        base + incrementor::inc(&mut base, 5) + incrementor::inc(&mut base, 10)
    }

    // Runner function to test perform_increments
    public fun run_perform_increments(): u64 {
        incrementor::perform_increments()
    }
}

//# run 0xabc::incrementor::perform_increments
//# run 0xabc::calculator::compute_sum --signers 0x1 --args
// Note: Arguments for compute_sum are internal, so no args needed here.
// Also, invoking the run_perform_increments to verify sequential updates.