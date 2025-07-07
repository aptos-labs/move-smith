//# publish
module 0xCAFE::GlobalResource {
    use std::signer;

    struct R has store, key {
        value: u64,
    }

    public inline fun get_value(r: &R): u64 {
        r.value
    }

    public fun borrow_and_read(s: &signer): u64 {
        let r = borrow_global<R>(signer::address_of(s));
        get_value(r)
    }

    public fun publish_resource(s: &signer, val: u64) {
        move_to<R>(s, R { value: val });
    }

    public fun runner(s: &signer) {
        // Just borrow and read using the inline + public fn combo to test
        let _ = borrow_and_read(s);
    }
}
//# run 0xCAFE::GlobalResource::runner --signers 0xCAFE

//# run
script {
    fun main(s: signer) {
        // publish resource with some value
        0xCAFE::GlobalResource::publish_resource(&s, 123u64);

        // call public function which calls the inline function
        let v = 0xCAFE::GlobalResource::borrow_and_read(&s);

        // v should be 123u64 (no assertion needed as per instructions)
    }
}