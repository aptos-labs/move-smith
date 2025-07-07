//# publish
module 0xCAFE::GlobalResource {
    use std::signer;

    struct R has store, key {
        value: u64,
    }

    // Private inline getter because the field is private and cannot be accessed outside the module
    friend inline fun get_value_internal(r: &R): u64 {
        r.value
    }

    public inline fun get_value(r: &R): u64 {
        get_value_internal(r)
    }

    public fun borrow_and_read(s: &signer): u64 {
        let r = borrow_global<R>(signer::address_of(s));
        get_value_internal(r)
    }

    public fun publish_resource(s: &signer, val: u64) {
        move_to<R>(s, R { value: val });
    }

    public fun runner(s: &signer) {
        // Just borrow and read using the internal inline + public fn combo to test
        let _ = borrow_and_read(s);
    }
}
//# run 0xCAFE::GlobalResource::runner --signers 0xCAFE

//# run
script {
    fun main(s: signer) {
        // publish resource with some value
        0xCAFE::GlobalResource::publish_resource(&s, 123u64);

        // call public function which calls the internal inline function
        let v = 0xCAFE::GlobalResource::borrow_and_read(&s);

        // v should be 123u64 (no assertion needed as per instructions)
    }
}