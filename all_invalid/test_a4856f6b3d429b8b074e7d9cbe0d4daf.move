//# publish
module 0x1::test_mut_ref {
    fun identity_mut<'a>(r: &mut u64): &mut u64 {
        r
    }

    public fun run_test() {
        let mut local_var = 100u64;
        // Create a mutable reference to local_var
        let mut_ref = &mut local_var;

        // Call the function with a mutable reference, should return the same mutable reference
        let returned_ref = identity_mut(mut_ref);

        // Modify through the returned reference
        *returned_ref = 200;

        // Create an immutable reference to local_var to verify the value
        let shared_ref: &u64 = &local_var;

        assert (*shared_ref == 200, 0);
    }
}

//# run 0x1::test_mut_ref::run_test