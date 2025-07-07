//# publish
module 0xabcde::mutability_test {
    public fun run_test(): u64 {
        let counter = 10;
        let (counter_ref, frozen_ref) = Self::create_refs(&mut counter);
        // Sum the dereferenced values without triggering the v1 bug
        *counter_ref + *frozen_ref
    }

    fun create_refs(borrowed: &mut u64): (&mut u64, &u64) {
        let ref_mut = borrowed;
        let ref_freeze = freeze(ref_mut);
        (ref_mut, ref_freeze)
    }
}

//# run 0xabcde::mutability_test::run_test