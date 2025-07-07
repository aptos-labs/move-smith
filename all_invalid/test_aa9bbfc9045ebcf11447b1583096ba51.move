//# publish
module 0xabcde::test_cyclic_ref {
    fun cyclic_ref(p: u64): u64 {
        let a = p;
        let b = &a;
        // Reassigning the reference to point to the same value
        let c = b;
        // Access the value via reference and return it
        *c
    }
}

 //# run 0xabcde::test_cyclic_ref::cyclic_ref --args 99

//# publish
module 0xabcde::test_nested_loops {
    fun complex_control_flow() {
        let count = 0;
        let mut sum = 0;

        for (i in 0..3) {
            sum = sum + i;
            let mut j = 0;
            while (j < 4) {
                sum = sum + j;
                j = j + 1;
            };
        };

        assert!(sum >= 0, 100);

        // Additional nested structures
        let mut k = 0;
        while (k < 5) {
            for (m in 0..2) {
                k = k + m;
            };
            k = k + 1;
        };
        // Final assertion to check loop execution
        assert!(k >= 0, 101);
    }

    public fun run_tests() {
        complex_control_flow();
    }
}

//# run 0xabcde::test_nested_loops::run_tests