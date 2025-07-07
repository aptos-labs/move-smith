// ###################################################
//# publish
module 0x1::closure_test {
    use std::error;
    use std::signer;

    /// A trait for function pointers accepting (u64) -> u64.
    public fun call_ptr(ptr: &mut fn(u64): u64, arg: u64): u64 {
        ptr(arg)
    }

    /// Struct holding a function pointer.
    struct Foo has copy, drop {
        f: fn(u64):u64,
    }

    /// Assigns a closure to Foo.f, executes it, and saves the result in resource.
    resource struct LastResult has key {
        value: u64
    }

    public fun runner(s: &signer) {
        // assign closure to struct
        let square = fun(x: u64): u64 { x * x };
        let foo = Foo { f: square };

        // call via function pointer
        let r = foo.f(3);
        // call via helper
        let mut fptr = foo.f;
        let r2 = call_ptr(&mut fptr, 4);

        // Save result to resource for inspection
        move_to(s, LastResult { value: r2 });
        assert!(r == 9, 10);
        assert!(r2 == 16, 11);
    }
}
//# run 0x1::closure_test::runner --signers 0x1



// ###################################################
//# publish
module 0x2::btreemap_test {
    use std::signer;
    use std::btreemap;
    use std::vector;

    resource struct Occurrences has key {
        map: btreemap::BTreeMap<u8, u64>,
    }

    public fun runner(s: &signer) {
        // classic histogram
        let map = btreemap::new<u8, u64>();
        let data = vector::from_bytes(b"banana");
        let len = vector::length(&data);
        let mut i = 0;
        while (i < len) {
            let k = *vector::borrow(&data, i);
            let counter = match btreemap::get_mut<u8, u64>(&mut map, k) {
                None => {
                    btreemap::insert<u8, u64>(&mut map, k, 1);
                    1
                },
                Some(v_ref) => {
                    *v_ref = *v_ref + 1;
                    *v_ref
                }
            };
            i = i + 1;
        };
        move_to(s, Occurrences { map });
    }
}
//# run 0x2::btreemap_test::runner --signers 0x2



// ###################################################
//# publish
module 0x3::logic_test {
    use std::signer;

    // Stores the result of logic to an on-chain resource for inspection.
    resource struct Result has key {
        r_and: bool,
        r_or: bool,
        r_not: bool,
        r_double: bool,
        r_complex: bool,
    }

    public fun runner(s: &signer) {
        let a = true;
        let b = false;

        let r_and = a && b;
        let r_or = a || b;
        let r_not = !a;
        let r_double = !!b;
        let r_complex = !(a && !b) || (b || !a);

        move_to(s, Result {
            r_and,
            r_or,
            r_not,
            r_double,
            r_complex,
        });
    }
}
//# run 0x3::logic_test::runner --signers 0x3



// ###################################################
//# run
script {
    fun main() {
        let t1 = (true && false);         // false
        let t2 = (true || false);         // true
        let t3 = !true;                   // false
        let t4 = !!false;                 // false
        let t5 = !((false || true) && !false); // false
        let t6 = !(false && true) || (true && !false); // true
        let t7 = !!((!true || false) && true); // false
    }
}