//# publish
address 0x1 {
    module SpecModule {
        #[skip(unused_imports, dead_code)]
        spec const SOME_SPEC: bool = true;

        spec module {
            // marking this as a spec module for testing purposes
            // Aptos framework internally tracks this flag, here we simulate it by a const
            const IS_SPEC_MODULE: bool = true;
        }
    }
}

//# publish
address 0x2 {
    module RModule {
        struct R has key, store {
            value: u64,
        }

        public fun create_r(account: &signer, v: u64): R {
            R { value: v }
        }

        public fun modify_r(r: &mut R, v: u64) {
            // modifies R based on v
            r.value = r.value + v;
        }
    }
}

//# publish
address 0x3 {
    module DepModule {
        use 0x2::RModule;

        struct Container has key {
            r: RModule::R,
        }

        public entry fun init_container(account: &signer, v: u64) {
            let r = RModule::create_r(account, v);
            move_to(account, Container { r });
        }

        public fun do_it(container: &mut Container, v: u64) {
            if (v > 10) {
                RModule::modify_r(&mut container.r, v);
            } else {
                // For v <= 10, just set it to v
                container.r.value = v;
            }
        }

        public entry fun runner(account: &signer) {
            init_container(account, 5);
            let container_ref = borrow_global_mut<Container>(signer::address_of(account));
            do_it(container_ref, 20); // Should add 20 to 5 => 25
        }
    }
}
//# run 0x3::DepModule::runner --signers 0x3

//# run 0x2::RModule::modify_r --signers 0x2 --args 0x0 42u64

//# run 0x1::SpecModule::SOME_SPEC