// We test the requested features in one module and a script


//# publish
module 0xCAFE::ComplexUtilities {
    use std::signer;

    // We define a nested struct variant, top-level in the module
    struct Outer has store {
        inner: Inner,
    }

    struct Inner has store {
        value: u64,
    }

    public inline fun inline_calling_private(x: u64): u64 {
        // Call to private function from inline function is allowed inside the module
        helper_double(x)
    }

    fun helper_double(x: u64): u64 {
        x * 2
    }

    public fun create_outer(value: u64): Outer {
        Outer { inner: Inner { value } }
    }

    public fun get_inner_value(o: &Outer): u64 {
        // Access nested field through qualified names
        o.inner.value
    }

    // We demonstrate use of signer parameter and nested struct usage
    public fun store_outer(s: signer, value: u64) {
        let o = create_outer(value);
        move_to<Outer>(&s, o);
    }

    public fun borrow_outer_value(s: signer): u64 {
        let o_ref = borrow_global<Outer>(signer::address_of(&s));
        get_inner_value(o_ref)
    }

    // Runner with no arguments (inline calls private function as well)
    public fun runner(): u64 {
        inline_calling_private(21u64)
    }
}


//# run 0xCAFE::ComplexUtilities::runner


//# run 0xCAFE::ComplexUtilities::store_outer --signers 0xA11CE --args 42u64


//# run 0xCAFE::ComplexUtilities::borrow_outer_value --signers 0xA11CE


// Featurres:
// 71a2dc4a89a5e061d52106eb579ef278: Use custom named address mappings in your Move packages.
// 7cc4440f5a0fcc67cf1f70523cd9069a: Call other functions from inline functions, respecting their visibility constraints.
// 98b08bffbf4c4031ab88abac91ee7fce: Access nested struct variants or schemas via qualified name chains.
