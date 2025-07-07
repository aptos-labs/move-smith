//# publish
address 0x1 {
    module M {
        // Define a resource `R` with a single u64 field `value`.
        resource struct R { value: u64 }

        // Constructor to create an R resource with initial value.
        public fun create_r(initial: u64): R {
            R { value: initial }
        }

        // A function that modifies or interacts with R based on the value `v`.
        #[skip(lint_arithmetic, lint_unused_variable)]
        public fun do_(r: &mut R, v: u64) {
            // If v is zero, reset value to zero.
            if (v == 0) {
                r.value = 0;
            } else if (v % 2 == 0) {
                // If even, add v.
                r.value = r.value + v;
            } else {
                // If odd, subtract v but not below 0.
                if (v > r.value) {
                    r.value = 0;
                } else {
                    r.value = r.value - v;
                }
            }
        }

        // Runner function to exercise `do_` function logic without arguments.
        // Create resource with value 10, run do_ with 5 and 8.
        public fun runner() {
            let mut r = create_r(10);
            // Call with odd number, subtract 5 => 5
            do_(&mut r, 5);
            // Call with even number, add 8 => 13
            do_(&mut r, 8);
            // Call with 0, reset => 0
            do_(&mut r, 0);
            // Dummy usage of r to avoid warnings
            let _ = &r;
        }
    }
}

//# run 0x1::M::runner

//# run 0x1::M::do_ --signers 0x1 --args 10u64

//# publish
address 0x2 {
    module Dep {
        // A dummy dependency module with a helper function.
        // The helper just returns sum of two u64s.
        public fun add(a: u64, b: u64): u64 {
            a + b
        }
    }
}

//# run
script {
    use 0x1::M;
    use 0x2::Dep;

    fun main(account: signer) {
        // Instantiate resource R with initial value 100.
        let mut r = M::create_r(100);

        // Use the dependency's add function.
        let sum = Dep::add(40, 2);

        // Modify r with the sum (42, even number: should add).
        M::do_(&mut r, sum);

        // Another modification with an odd number 11.
        M::do_(&mut r, 11);

        // Zero value: reset r.value.
        M::do_(&mut r, 0);

        // Dummy use of variable to suppress warnings.
        let _ = &r;
    }
}