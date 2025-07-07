//# publish
address 0x1 {
    module M {

        use std::signer;

        #[skip(unused_variables, dead_code)]
        struct R has key {
            value: u64,
        }

        #[LifetimeAnnotation("'a")]
        public fun do<'a>(r: &mut R, v: u64) {
            if (v > 10) {
                r.value = r.value + v;
            } else {
                r.value = 0;
            }
        }

        /// Runner function that initializes R, modifies it by calling do(), and returns the final value
        public fun runner(s: &signer) {
            let r = R { value: 5 };
            move_to(s, r);
            let r_ref = borrow_global_mut<R>(signer::address_of(s));
            // Using an expression to unblock and handle unbound name 'v' by providing a value
            let v = 15u64;
            do<'static>(r_ref, v);
        }
    }
}
//# run 0x1::M::runner --signers 0x1


//# run
script {
    use 0x1::M;
    use std::signer;

    fun main(s: signer) {
        let r = M::R { value: 3 };
        move_to(&s, r);

        let r_ref = borrow_global_mut<M::R>(signer::address_of(&s));
        // Use an expression to unblock unbound name 'v'
        let v = 5u64;
        M::do<'static>(r_ref, v);
    }
}