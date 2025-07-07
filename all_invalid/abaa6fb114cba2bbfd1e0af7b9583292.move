//# publish
address 0x1 {
    module Dep {
        struct R has key {
            val: u64,
        }

        public fun new_r(v: u64): R {
            R { val: v }
        }
    }
}

//# publish
address 0x2 {
    use 0x1::Dep;

    #[skip(lint_mod_usage, lint_unused_import)]
    module Target {
        struct RHolder has key {
            r: Dep::R,
        }

        public fun new_holder(v: u64): RHolder {
            let r = Dep::new_r(v);
            RHolder { r }
        }

        /// This function will modify or interact with the R resource based on value v inside R.
        public fun do(holder: &mut RHolder) {
            if (holder.r.val % 2 == 0) {
                // even val: double the value
                holder.r.val = holder.r.val * 2;
            } else {
                // odd val: increment by 1
                holder.r.val = holder.r.val + 1;
            }
        }

        public fun runner() {
            let mut h = new_holder(3);
            do(&mut h);
            let mut h2 = new_holder(4);
            do(&mut h2);
        }
    }
}
//# run 0x2::Target::runner

//# run
script {
    use 0x2::Target;
    use 0x1::Dep;

    fun main(account: signer) {
        let mut holder = Target::new_holder(5);
        Target::do(&mut holder);
        let mut holder2 = Target::new_holder(6);
        Target::do(&mut holder2);
    }
}