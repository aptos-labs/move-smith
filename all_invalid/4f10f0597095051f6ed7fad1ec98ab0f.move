//# publish
address 0x1 {
    module NestedLoops {
        use std::debug;

        #[skip(lint_unnecessary_mut, lint_unused_var)]
        resource struct R has key {
            val: u64,
        }

        // Initialize the resource R for the signer
        public fun init(s: &signer) {
            let r = R { val: 0 };
            move_to<R>(s, r);
        }

        // The do() function modifies R.val based on the argument v
        public fun do(s: &signer, v: u64) {
            let r_ref = borrow_global_mut<R>(signer::address_of(s));
            // If v is even, add v to r.val; if odd subtract v, saturate to zero
            if (v % 2 == 0) {
                r_ref.val = r_ref.val + v;
            } else {
                if (r_ref.val > v) {
                    r_ref.val = r_ref.val - v;
                } else {
                    r_ref.val = 0;
                }
            }
        }

        // Runner function that initializes and calls do() with sample values
        public fun runner(s: &signer) {
            // Init resource
            init(s);

            // do with even and odd values
            do(s, 10);
            do(s, 3);
            do(s, 5);
            do(s, 8);
        }
    }
}
//# run 0x1::NestedLoops::runner --signers 0x1


//# run
script {
    use std::debug;
    use 0x1::NestedLoops;

    fun main(account: &signer) {
        // Prepare resource and run do()
        NestedLoops::runner(account);

        // Borrow R to validate updated value by iterating with nested loops

        let r_ref = borrow_global::<NestedLoops::R>(signer::address_of(account));

        let mut sum: u64 = 0;
        let mut i = 0u64;

        // Nested for-loop: i from 0 to 4, j from 0 to 9
        while (i < 5) {
            let mut j = 0u64;
            while (j < 10) {
                sum = sum + 1;
                j = j + 1;
            }
            i = i + 1;
        }

        // sum should be 5 * 10 = 50
        debug::print(&sum);

        // We expect sum to be 50 here.
        // Also the r.val after runner() calls:
        // Initial val=0
        // do(10) add 10 -> 10
        // do(3) subtract 3 -> 7
        // do(5) subtract 5 -> 2
        // do(8) add 8 -> 10
        debug::print(&r_ref.val);

        // Control-flow with for-like loop using while for demonstration
        let mut count = 0u64;
        let mut k = 0u64;
        while (k < 3) {
            if (k == 1) {
                count = count + 10;
            } else {
                count = count + 1;
            }
            k = k + 1;
        }
        debug::print(&count);
    }
}