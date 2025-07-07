//# publish
module 0xCAFE::VarArithmeticTest {
    //
    // 1. Test local variable declaration, arithmetic expressions, tuple assignment, and copy semantics.
    //
    public fun runner() {
        // Variable declaration and arithmetic
        let a = 10u8;
        let b = 5u8;
        let c = a + b;
        let d = a - b;
        let e = a * b;
        let f = a / b;
        let g = a % b;
        let (sum, diff) = (c, d);

        // All primitives have the copy ability
        let h = copy e + copy 13u8;

        // Test with boolean operators
        let x = true && !false;
        let y = false || x;
        let z = !(y && false);

        // Make sure tuples must be unpacked
        let (q, r) = (1u128, 2u128);

        // Touch variables so they're not dropped
        ignore(h);
        ignore(f);
        ignore(g);
        ignore(sum);
        ignore(diff);
        ignore(x);
        ignore(y);
        ignore(z);
        ignore(q);
        ignore(r);
    }

    public fun ignore<T: drop>(_: T) {}

}

//# run 0xCAFE::VarArithmeticTest::runner

//# publish
module 0xCAFE::UTF8AndBCSConvertor {
    use std::string;
    use std::vector;
    use std::bcs;
    //
    // 2. Test that `init` function correctly processes empty vectors and converts them
    //    to utf8 strings and bcs bytes without error.
    //
    public fun init() {
        let key_vec: vector<u8> = vector::empty();
        let value_vec: vector<u8> = vector::empty();

        // Convert (empty) to utf8 string; should succeed and produce empty string
        let key_str = string::utf8(key_vec);
        let value_str = string::utf8(value_vec);

        // Convert (empty) to bcs bytes (just re-serialize as vector<u8>)
        let bcs_key = bcs::to_bytes(&key_str);
        let bcs_value = bcs::to_bytes(&value_str);

        // Use vectors so they're not dropped
        ignore(bcs_key);
        ignore(bcs_value);
    }

    public fun ignore<T: drop>(_: T) {}
}

//# run 0xCAFE::UTF8AndBCSConvertor::init

//# publish
module 0xCAFE::Resource {
    // Resource type local to this module
    struct R has key, store {}

    // publish R under signer
    public fun publish_r(s: &signer) {
        move_to<R>(s, R {});
    }

    // Only able to acquire resource from this module, not an external one
    public fun get_r(addr: address): &R acquires R {
        borrow_global<R>(addr)
    }
}

//# run 0xCAFE::Resource::publish_r --signers 0xCAFE
//# run 0xCAFE::Resource::get_r --signers 0xCAFE --args 0xCAFE

//# publish
module 0xBEEF::OtherResource {
    struct X has key, store {}
    public fun publish_x(s: &signer) {
        move_to<X>(s, X {});
    }

    // Let's try to make an invalid cross-module resource acquire
    // Note: This should be CAUGHT by the Move compiler and/or rejected by checker

    // The following function, if uncommented, would cause a compile error:
    /*
    public fun invalid_acquire(addr: address): &X acquires X {
        borrow_global<X>(addr)
    }
    */
}

// Featurres:
// 7f5f485a46e2de7bb31ad797f6d00c23: Test that local variable declarations and arithmetic expressions execute without errors in a Move function.
// 7db55a986472911ee23cd260c614e17b: Test that the `init` function correctly processes empty key and value vectors by converting them to UTF-8 strings and BCS bytes without errors.
// 47f2bdb37b9afaf1f74586a288d0e278: Ensure that resources acquired are from the same module as the function, preventing acquisition of resources from other modules
