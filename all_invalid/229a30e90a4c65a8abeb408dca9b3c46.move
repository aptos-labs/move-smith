//# publish
address 0x1 {
    module M {
        #[skip(bytecode_complexity, naming_convention)]
        struct R has key { val: u64 }

        public fun new_r(value: u64): R {
            R { val: value }
        }

        spec module {
            invariant [100] {
                forall r: &R :: r.val >= 0
            }
        }

        public fun do(r: &mut R, v: u64) {
            if v > 10 {
                // If v > 10, increment val by v
                r.val = r.val + v;
            } else {
                // Otherwise decrement val by v
                r.val = r.val - v;
            }
        }

        public fun runner() {
            let mut r = new_r(20);
            do(&mut r, 15);
            do(&mut r, 5);
        }
    }
}
//# run 0x1::M::runner


//# publish
address 0x2 {
    module Target {
        #[skip(bytecode_size)]
        struct R has key { counter: u64 }

        public fun new(counter: u64): R {
            R { counter }
        }

        spec module {
            invariant [200] {
                forall r: &R :: r.counter >= 0
            }
        }

        public fun increment(r: &mut R) {
            r.counter = r.counter + 1;
        }

        public fun do(r: &mut R, v: u64) {
            if v % 2 == 0 {
                increment(r);
            } else {
                r.counter = r.counter + v;
            }
        }

        public fun runner() {
            let mut r = new(0);
            do(&mut r, 2);
            do(&mut r, 3);
        }
    }
}
//# run 0x2::Target::runner


//# run
script {
    use 0x1::M;
    use 0x2::Target;

    fun main(account: signer) {
        let mut r1 = M::new_r(50);
        M::do(&mut r1, 20);
        M::do(&mut r1, 5);

        let mut r2 = Target::new(10);
        Target::do(&mut r2, 4);
        Target::do(&mut r2, 7);
    }
}