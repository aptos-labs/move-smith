// Directory: modules/
//# publish
module 0xCAFE::TestQuantifiers<T: copy + store> {
    use std::signer;
    use std::vector;

    struct Wrapper has key {
        values: vector<T>,
    }

    public fun initialize(account: &signer, val: T) {
        let data = vector::empty<T>();
        vector::push_back(&mut data, val);
        move_to(account, Wrapper { values: data });
    }

    public fun add_value(account: &signer, val: T) {
        let wrapper = borrow_global_mut<Wrapper>(signer::address_of(account));
        vector::push_back(&mut wrapper.values, val);
    }

    // A function using quantifiers (forall & exists).
    public fun check_all<F: copy + store>(
        addr: address,
        f: F,
    ) acquires Wrapper {
        let wrapper = borrow_global<Wrapper<F>>(addr);
        // All numbers are even
        axiom forall i in 0..vector::length(&wrapper.values): vector::borrow(&wrapper.values, i) % 2 == 0;
        // At least one element exists and equals 4
        axiom exists x in &wrapper.values: *x == 4;
        // Choose an element (demonstration, not parametrizing condition)
        axiom choose i in 0..vector::length(&wrapper.values): vector::borrow(&wrapper.values, i) > 2;
    }

    // Runner function for test
    public fun runner(account: &signer) {
        Self::initialize(account, 4);
        Self::add_value(account, 6);
        Self::check_all<integer>(signer::address_of(account), 0);
    }
}
//# run 0xCAFE::TestQuantifiers::runner --signers 0xBEEF

// Directory: scripts/
//# run
script {
    use 0xCAFE::TestQuantifiers;

    fun main(account: &signer) {
        TestQuantifiers::initialize(account, 12);
        TestQuantifiers::add_value(account, 16);
        TestQuantifiers::check_all<u8>(signer::address_of(account), 0);
    }
}