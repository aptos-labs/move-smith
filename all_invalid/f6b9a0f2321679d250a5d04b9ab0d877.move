//# publish
address 0x1 {
    module LintSkipped {
        // Use skip attribute on a function with a list of lint names
        #[skip(lint_invalid_signer, lint_shadow_unrelated)]
        public fun skipped_function() {
            // empty on purpose
        }

        struct R has key, store {
            val: u64,
        }

        public fun new_r(): R {
            R { val: 0 }
        }

        /// do() function which manipulates R based on v
        public fun do(r: &mut R, v: u64) {
            if (v == 0) {
                r.val = 1;
            } else if (v == 1) {
                r.val = 2;
            } else {
                r.val = 3;
            }
        }

        /// A runner function calling do with each value
        public fun runner() {
            let mut r = new_r();
            do(&mut r, 0);
            do(&mut r, 1);
            do(&mut r, 2);
        }
    }
}
//# run 0x1::LintSkipped::runner

//# publish
address 0x2 {
    module OperatorPrecedence {
        /// Returns true if logical and bitwise ops give expected results
        public fun check_logic() : bool {
            let a = true;
            let b = false;
            let c = true;

            let res1 = a && (b || c);    // true && (false || true) => true
            let res2 = (a || b) && c;    // (true || false) && true => true
            let res3 = !a || b;          // !true || false => false
            res1 && res2 && !res3
        }

        /// Check arithmetic precedence and correctness
        public fun check_arithmetic(): bool {
            let x = 2 + 3 * 4;       // 2 + 12 = 14
            let y = (2 + 3) * 4;     // 5 * 4 = 20
            let z = 5 >> 1 + 1;      // 5 >> (1+1) = 5 >> 2 = 1
            let w = (5 >> 1) + 1;    // (5 >> 1)=2 + 1=3

            let comp = x < y && z == 1 && w == 3;
            comp
        }

        public fun runner(): bool {
            check_logic() && check_arithmetic()
        }
    }
}
//# run 0x2::OperatorPrecedence::runner

//# run
script {
    use 0x1::LintSkipped;
    use 0x2::OperatorPrecedence;

    fun main() {
        // Test the skipped lint function by calling it (should compile fine)
        LintSkipped::skipped_function();

        // Create mutable R and call do with various values
        let mut r = LintSkipped::new_r();
        LintSkipped::do(&mut r, 0);
        LintSkipped::do(&mut r, 1);
        LintSkipped::do(&mut r, 2);

        // Assert operator precedence functions return true (no assertions needed)
        let _ok1 = OperatorPrecedence::check_logic();
        let _ok2 = OperatorPrecedence::check_arithmetic();

        // Combined runner invocations
        0x1::LintSkipped::runner();
        assert!(0x2::OperatorPrecedence::runner());
    }
}