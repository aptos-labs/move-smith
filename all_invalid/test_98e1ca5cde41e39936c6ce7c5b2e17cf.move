//# publish
module ConstantRefMutableTest {
    use 0x1::Debug;

    public fun run() {
        // Constants, references, and mutable borrows
        const CONST_NUM: u64 = 100;
        const CONST_BYTES: vector<u8> = b"constant";

        // Check initial values via assertions
        assert!(CONST_NUM == 100, 42);
        assert!(CONST_BYTES == b"constant", 42);

        // Borrow constants by reference
        let ref_num = &CONST_NUM;
        let ref_bytes = &CONST_BYTES;

        // Verify borrowed values are correct
        assert!(*ref_num == 100, 42);
        assert!(*ref_bytes == b"constant", 42);

        // Attempt mutable borrow on constant (should fail compile, so simulate via local variable)
        // Instead, create local mutable variables initialized from constants
        let mut local_num = CONST_NUM;
        let mut local_bytes = copy CONST_BYTES; // copying the vector

        // Mutate local variables
        local_num = 200;
        local_bytes = b"changed".to_vec();

        // Verify that original constants are unchanged
        assert!(CONST_NUM == 100, 42);
        assert!(CONST_BYTES == b"constant", 42);

        // Verify local mutable variables have been updated
        assert!(local_num == 200, 42);
        assert!(local_bytes == b"changed", 42);

        // Borrow local mutable variables mutably
        let mut_ref_num = &mut local_num;
        let mut_ref_bytes = &mut local_bytes;

        *mut_ref_num = 300;
        *mut_ref_bytes = b"mutated".to_vec();

        // Confirm mutation
        assert!(*mut_ref_num == 300, 42);
        assert!(*mut_ref_bytes == b"mutated", 42);

        // Final check that constants remain unaffected
        assert!(CONST_NUM == 100, 42);
        assert!(CONST_BYTES == b"constant", 42);
    }
}
  
//# run
script {
    ConstantRefMutableTest::run();
}

//# run 0x1::ConstantRefMutableTest::run