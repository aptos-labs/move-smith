//# publish
address 0x1 {
    module LintSkippedModule {
        // This module uses skip to avoid some lint errors intentionally
        #[skip(unused_variable, dead_code)]
        public fun do(): bool {
            let x = 10;  // unused variable but skipped lint
            true
        }

        #[skip()]
        fun internal_do(v: u64, r: &mut R) {
            if (v > 10) {
                r.count = r.count + 1;
            } else {
                r.count = r.count - 1;
            }
        }

        struct R has key {
            count: u64,
        }

        public fun new_r(): R {
            R { count: 0 }
        }

        public fun do_wrapper(v: u64, r: &mut R) {
            internal_do(v, r);
        }

        public fun runner() {
            let mut r = new_r();
            internal_do(20, &mut r);
            internal_do(5, &mut r);
        }
    }
}
//# run 0x1::LintSkippedModule::runner

//# publish
address 0x2 {
    module Caller {
        use 0x1::LintSkippedModule;

        public fun run_do() {
            let mut r = LintSkippedModule::new_r();
            LintSkippedModule::do_wrapper(42, &mut r);
            LintSkippedModule::do_wrapper(1, &mut r);
        }
    }
}
//# run 0x2::Caller::run_do

//# run
script {
    use 0x1::LintSkippedModule;
    use 0x2::Caller;

    fun main() {
        // Test direct call
        let mut r = LintSkippedModule::new_r();
        LintSkippedModule::do_wrapper(50, &mut r);
        LintSkippedModule::do_wrapper(0, &mut r);

        // Test indirect via caller module
        Caller::run_do();

        // Test the do function with skipped lints
        let _ = LintSkippedModule::do();
    }
}