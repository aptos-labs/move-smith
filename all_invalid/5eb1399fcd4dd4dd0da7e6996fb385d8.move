//# publish
address 0x1 {
    module Dep {
        resource struct R { val: u64 }

        public fun new_r(): R {
            R { val: 0 }
        }

        public fun update(r: &mut R, v: u64) {
            if (v == 0) {
                r.val = 100; // modify r if v == 0
            } else {
                r.val = v; // else set to v directly
            }
        }

        public fun read(r: &R): u64 {
            r.val
        }

        // runner to create R, update with 0 and 42, and read values.
        public fun do(): u64 {
            let mut r = new_r();
            update(&mut r, 0);
            update(&mut r, 42);
            read(&r)
        }
    }
}

//# run 0x1::Dep::do

//# publish
module DefaultAddress {
    use std::vector;

    // Define an enum inside this module.
    enum E {
        A,
        B(u64),
        C { x: u64 }
    }

    // Resource holding a vector of E
    resource struct Store { es: vector<E> }

    public fun new_store(): Store {
        // Construct vector with literals via vector::empty + vector::push_back 
        let v = vector::empty<E>();
        let v = vector::push_back(v, E::A);
        let v = vector::push_back(v, E::B(42));
        let v = vector::push_back(v, E::C { x: 100 });
        Store { es: v }
    }

    // A function that matches on enum E and sums data inside
    public fun sum(es: &Store): u64 {
        let mut acc = 0;
        let len = vector::length(&es.es);
        let mut i = 0;
        while (i < len) {
            let e = *vector::borrow(&es.es, i);
            // match only inside the defining module
            acc = acc + match e {
                E::A => 1,
                E::B(v) => v,
                E::C { x } => x,
            };
            i = i + 1;
        };
        acc
    }

    // Runner function that creates store and returns sum
    public fun do(): u64 {
        let s = new_store();
        sum(&s)
    }
}

//# run 0x1::DefaultAddress::do

//# publish
address 0xABCD {
    module Main {
        use 0x1::Dep;
        use 0x1::DefaultAddress;

        public fun test_dep() {
            let mut r = Dep::new_r();
            Dep::update(&mut r, 10);
        }

        public fun test_store() {
            let s = DefaultAddress::new_store();
            ignore(DefaultAddress::sum(&s));
        }

        public fun runner() {
            test_dep();
            test_store();
        }
    }
}

//# run 0xABCD::Main::runner --signers 0xABCD