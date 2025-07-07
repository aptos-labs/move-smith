//# publish
address 0x1 {
    module LinterControl {
        #[skip(lint1, lint2)]
        public fun noop() {}
    }
}

//# publish
address 0x2 {
    module ResourceModule {
        use std::signer;

        struct R has key {
            value: u64,
        }

        public fun create_r(account: &signer, init_value: u64) {
            move_to(account, R { value: init_value });
        }

        public fun read_r(r: &R): u64 {
            r.value
        }

        // modifies R based on the input value v
        public fun do(r: &mut R, v: u64) {
            if (v == 0) {
                r.value = r.value + 1;
            } else if (v == 1) {
                r.value = r.value * 2;
            } else {
                r.value = r.value - v;
            }
        }

        public fun runner(account: &signer) {
            create_r(account, 10);
            let r_ref = borrow_global_mut<R>(signer::address_of(account));
            do(&mut r_ref, 1);
            do(&mut r_ref, 0);
            do(&mut r_ref, 5);
        }
    }
}
//# run 0x2::ResourceModule::runner --signers 0x2

//# publish
address 0x3 {
    module Uint128Arithmetic {
        use std::u128;

        public fun add(a: u128, b: u128): u128 {
            a + b
        }

        public fun sub(a: u128, b: u128): u128 {
            a - b
        }

        public fun mul(a: u128, b: u128): u128 {
            a * b
        }

        public fun div(a: u128, b: u128): u128 {
            // Note: division by zero will abort automatically
            a / b
        }

        public fun mod_(a: u128, b: u128): u128 {
            a % b
        }

        public fun overflow_add() {
            let max = u128::MAX;
            let _ = max + 1; // should fail with overflow
        }

        public fun overflow_sub() {
            let zero = 0u128;
            let _ = zero - 1; // should fail with underflow
        }

        public fun overflow_mul() {
            let max = u128::MAX;
            let _ = max * 2; // should fail with overflow
        }

        public fun overflow_div() {
            let x = 1u128;
            let zero = 0u128;
            let _ = x / zero; // division by zero abort
        }

        public fun runner() {
            let a = 10u128;
            let b = 3u128;
            let sum = add(a, b);
            let diff = sub(a, b);
            let prod = mul(a, b);
            let quot = div(a, b);
            let modv = mod_(a, b);
            // no asserts, just run through normal operations
        }
    }
}
//# run 0x3::Uint128Arithmetic::runner

//# publish
address 0x4 {
    module ReturnValues {
        public fun return_const(): u64 {
            42
        }

        public fun return_param(x: u64): u64 {
            x
        }

        public fun main() {
            let c = return_const();
            assert!(c == 42, 1);

            let v = return_param(123);
            assert!(v == 123, 2);
        }
    }
}
//# run 0x4::ReturnValues::main

//# run
script {
    use 0x2::ResourceModule;
    use std::signer;

    fun main(account: signer) {
        ResourceModule::create_r(&account, 5);
        let r_ref = borrow_global_mut<ResourceModule::R>(signer::address_of(&account));
        ResourceModule::do(&mut r_ref, 0);
        ResourceModule::do(&mut r_ref, 1);
        ResourceModule::do(&mut r_ref, 4);
    }
}