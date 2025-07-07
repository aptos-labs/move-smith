//# publish
address 0x1 {
    module LintDep {
        #[skip(lint_a, lint_b)]
        struct R has key {
            val: u64,
        }

        public fun new_r(): R {
            R { val: 0 }
        }

        public fun set_val(r: &mut R, new_val: u64) {
            r.val = new_val;
        }
    }
}

//# publish
address 0x2 {
    module TargetModule {
        use 0x1::LintDep;

        #[skip(lint_c)]
        struct Container has key {
            resource: LintDep::R,
        }

        public fun new_container(): Self {
            let r = LintDep::new_r();
            Container { resource: r }
        }

        public fun do(resource: &mut LintDep::R, v: u64) {
            if (v == 0) {
                LintDep::set_val(resource, 42);
            } else {
                LintDep::set_val(resource, v);
            }
        }

        public fun runner() {
            let mut r = LintDep::new_r();
            do(&mut r, 0);
            do(&mut r, 5);
        }
    }
}
//# run 0x2::TargetModule::runner

//# run
script {
    use 0x1::LintDep;
    use 0x2::TargetModule;

    fun main(acct: signer) {
        let mut r = LintDep::new_r();
        TargetModule::do(&mut r, 0);
        TargetModule::do(&mut r, 100);
    }
}