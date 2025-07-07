//# publish
module 0xCAFE::GlobalResource {
    use std::signer;
    use std::vector;

    struct R has store, key {
        value: u64,
    }

    public inline fun get_value(r: &R): u64 {
        r.value
    }

    public fun borrow_and_read(s: &signer): u64 {
        let r = borrow_global<R>(signer::address_of(s));
        get_value(&r)
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
    use std::signer;
    use 0xCAFE::GlobalResource;

    fun main(s: signer) {
        // publish resource with some value
        GlobalResource::publish_resource(&s, 123u64);

        // call public function which calls the inline function
        let v = GlobalResource::borrow_and_read(&s);

        // v should be 123u64 (no assertion needed as per instructions)
    }
}

// Featurres:
// 5088acc417798600c0e061ae3cd83653: Use 'use' declarations to import modules or items into the current scope
// adcc48dd1c169a1ada209210842c1dc8: Declare Move scripts directly in the source.
// c64d4c4c120027053db915b639944508: Verify that a public function calling an inline function, which in turn borrows and reads a global resource, correctly retrieves the integer value stored in the resource.
