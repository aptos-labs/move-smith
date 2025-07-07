//# publish
module 0xabcde::ref_reassignment {
    fun test_reassign_same_value() {
        let a = 10;
        let a_ref = &a;
        // Reassign the reference to the same value
        // In Move, references are immutable, so to simulate reassignment,
        // we'll just rebind a new reference to the same variable.
        let a_ref2 = &a;
        assert!(*a_ref2 == 10, 0);
    }

    // Optional runner function
    public fun run_reassign_same_value() {
        test_reassign_same_value();
    }
}


//# run 0xabcde::ref_reassignment::run_reassign_same_value

//# publish
module 0xffeedd::conditional_execution {
    //# run
    script {
        fun main() {
            if (true) {
                return ();
            } else {
                return ();
            }
        }
    }
}