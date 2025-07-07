//# publish
address 0x1 {
    module LintSkips {
        #[skip(type_warnings, unused_variables)]
        public fun skipped_lint_example() {
            let _x = 1;
            let _y = 2;
        }

        public fun lambda_example(): u64 {
            // Define a lambda that takes a u64 and returns u64 by increment.
            let f = lambda (a: u64): u64 { a + 1 };
            f(10)
        }

        struct R has key { val: u64 }

        public fun new_r(val: u64): R {
            R { val }
        }

        // do() modifies or interacts with R based on v.
        public fun do(r: &mut R, v: u64) acquires R {
            if (v % 2 == 0) {
                r.val = r.val + v;
            } else {
                let closure = lambda (x: u64): u64 { x * x }; // anonymous function
                r.val = closure(v);
            }
        }

        // runner function that exercises do()
        public fun run_do() {
            let mut r = new_r(10);
            do(&mut r, 2);
            do(&mut r, 3);
        }
    }
}
//# run 0x1::LintSkips::run_do --signers 0x1

//# run
script {
    use 0x1::LintSkips;

    fun main(account: &signer) {
        LintSkips::skipped_lint_example();
        let result = LintSkips::lambda_example();
        // We just run it, no assert needed.

        let mut r = LintSkips::new_r(5);
        LintSkips::do(&mut r, 4);
        LintSkips::do(&mut r, 7);
    }
}