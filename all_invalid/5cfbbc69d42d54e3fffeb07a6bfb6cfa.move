//# publish
address 0x1 {
    module Dependency {
        struct R has key, store {
            val: u64,
        }

        #[skip(lint_unfriend_struct_fields, lint_unused_structs)]
        struct Dummy has copy, drop, store {
            dummy_val: u8,
        }

        public fun create_r(val: u64): R {
            R { val }
        }

        public fun modify_r(r: &mut R, new_val: u64) {
            r.val = new_val;
        }

        public fun get_r_val(r: &R): u64 {
            r.val
        }
    }
}

//# publish
address 0x2 {
    module Target {
        use 0x1::Dependency;

        #[skip(lint_unused_functions)]
        struct DummyStruct has copy, drop, store {
            data: u8,
        }
        
        struct Container has key {
            r: Dependency::R,
            v: u64,
        }

        public fun new_container(val: u64): Container {
            Container {
                r: Dependency::create_r(val),
                v: val,
            }
        }

        public fun do_mutate(cont: &mut Container) {
            if (cont.v % 2 == 0) {
                // For even v, increment r.val by v
                let old_val = Dependency::get_r_val(&cont.r);
                Dependency::modify_r(&mut cont.r, old_val + cont.v);
            } else {
                // For odd v, decrement r.val by v (if possible)
                let old_val = Dependency::get_r_val(&cont.r);
                if (old_val >= cont.v) {
                    Dependency::modify_r(&mut cont.r, old_val - cont.v);
                }
            }
        }

        public fun get_val(cont: &Container): u64 {
            Dependency::get_r_val(&cont.r)
        }

        public fun runner_no_args() {
            let mut c = new_container(10);
            do_mutate(&mut c);
            let _ = get_val(&c);

            let mut c1 = new_container(7);
            do_mutate(&mut c1);
            let _ = get_val(&c1);
        }
    }
}
//# run 0x2::Target::runner_no_args

//# publish
address 0x3 {
    module NamedAddresses {
        // Intentionally refer to named addresses that are unassigned 
        use Dep = 0x1;
        use Tar = 0x2;
        use Unassigned = 0xEF;

        public fun caller() {
            // Create container from Target module
            let cont = Tar::new_container(42);
            let val = Tar::get_val(&cont);
            // Use Dependency functions directly
            let r = Dep::create_r(100);
            let v = Dep::get_r_val(&r);
            // No mutations here, just accesses to test named address references
            let _ = val + v;
        }
    }
}
//# run 0x3::NamedAddresses::caller


//# run
script {
    use 0x2::Target;
    use 0x1::Dependency;

    fun main() {
        let mut cont = Target::new_container(4);
        Target::do_mutate(&mut cont);
        let val = Target::get_val(&cont);

        // mutate again
        Target::do_mutate(&mut cont);
        let val2 = Target::get_val(&cont);

        let mut cont_odd = Target::new_container(9);
        Target::do_mutate(&mut cont_odd);
        let val_odd = Target::get_val(&cont_odd);

        // Just use values to touch both code paths
        let _ = val + val2 + val_odd;
    }
}