//# publish
module 0x1::LinterSkips {
    // Test skip attribute for lints
    #[skip(unused_imports, unused_variables)]
    native fun native_func(): u64;

    #[skip(unused_imports)]
    fun dummy(): u64 {
        42
    }

    spec Foo {
        let x: u64;
    }

    fun do_skip_test(_a: u8) {
        // nothing
    }
}

//# publish
module 0x1::ResourceMod {
    use std::signer;

    struct R has key, store {
        val: u64,
    }

    public fun new_r(account: &signer, val: u64) {
        move_to(account, R { val });
    }

    public fun do(r: &mut R, v: u64) {
        // Modify R.val based on value of v
        if v == 0 {
            r.val = 0;
        } else if v == 1 {
            r.val = r.val + 10;
        } else {
            r.val = r.val * v;
        }
    }

    public fun runner(_account: &signer) {
        let r = borrow_global_mut<R>(signer::address_of(_account));
        do(r, 5);
    }
}

//# run 0x1::ResourceMod::runner --signers 0x1

//# publish
module 0x1::Diagnostics {
    /// This module demonstrates generating formatted diagnostic messages into a buffer.

    struct DiagnosticBuffer has copy, drop, store {
        buf: vector<u8>,
    }

    public fun new_buffer(): DiagnosticBuffer {
        let b = b"Diagnostic start: "_copy();
        DiagnosticBuffer { buf: b }
    }

    public fun append_message(db: &mut DiagnosticBuffer, msg: &vector<u8>) {
        vector::append(&mut db.buf, msg);
    }

    public fun formatted_message(): vector<u8> {
        let mut buf = b"Error: invalid value"_copy();
        vector::push_back(&mut buf, 33u8); // !
        buf
    }

    public fun runner() {
        let mut db = new_buffer();
        let msg = formatted_message();
        append_message(&mut db, &msg);
        // db.buf now contains: "Diagnostic start: Error: invalid value!"
        // no assertions needed
    }
}

//# run 0x1::Diagnostics::runner

//# publish
module 0x1::SpecExample {
    spec module {
        invariant true;
    }

    spec struct S {
        x: u64;
    }

    struct S has store {
        x: u64,
    }

    public fun new_s(x: u64): S {
        S { x }
    }

    public fun use_spec(_s: S) {
        // use underscore wildcard pattern
        let _ = _s;
    }

    spec fun new_s(x: u64): S {
        ensures result.x == x;
    }
}

//# run 0x1::SpecExample::use_spec --args 10u64

//# run
script {
    use 0x1::ResourceMod;
    use std::signer;

    fun main(account: signer) {
        ResourceMod::new_r(&account, 7);
        let r = borrow_global_mut<ResourceMod::R>(signer::address_of(&account));
        ResourceMod::do(r, 1);
    }
}