// Named addresses definition for testing named address resolution and generics
#define TEST_ADDR1 0xCAFE
#define TEST_ADDR2 0xBEEF
#define TEST_ADDR3 0xDEAD



//# publish
module 0xCAFE::NamedGeneric {
    /// A generic resource with key ability
    struct Container<T> has key {
        val: T
    }

    /// Publishes a Container<some_type> under signer's account
    public fun publish_container<T>(account: &signer, value: T) acquires Container<T> {
        let c = Container<T> { val: value };
        move_to<Container<T>>(account, c);
    }

    /// Generic method to return the inner value by reference
    public fun borrow_val<T>(c: &Container<T>): &T {
        &c.val
    }

    /// Generic method to update the inner value
    public fun update_val<T>(c: &mut Container<T>, new_val: T) {
        c.val = new_val;
    }

    /// Generic method with abort annotated states for testing abort state annotation formatting
    /// Aborts with code 100 if value == zero (u64) with annotated state, else returns value
    public fun check_and_abort<T: copy+drop+store + core::ops::Drop>(value: T) acquires Container<T> {
        // For simplicity, we require T = u64 in actual calls to trigger abort.
        // The abort_state annotation is custom for testing.
        abort 100 if value == 0, "Aborted because value was zero, value=", value;
    }

    /// Runner to trigger abort with value zero (u64), annotate abort with variable states
    public fun runner_abort() {
        let v = 0u64;
        // This abort's custom abort_state is expected to be formatted and displayed by VM & test infra
        check_and_abort<u64>(v);
    }
}



//# run 0xCAFE::NamedGeneric::publish_container<u64> --signers 0xCAFE --args 42u64



//# run 0xCAFE::NamedGeneric::runner_abort



//# publish
module 0xBEEF::GenericMethodCaller {
    use std::signer;
    use std::vector;
    use 0xCAFE::NamedGeneric;

    /// Calls publish_container from NamedGeneric with explicit generic argument
    public fun call_publish(account: &signer) {
        NamedGeneric::publish_container<u64>(account, 77u64);
    }

    /// Calls update_val method by borrowing mutable Container instance with generic method syntax (Move 2.2+ style)
    public fun call_update(account: &signer) {
        let addr = signer::address_of(account);
        let container_ref: &mut NamedGeneric::Container<u64> = borrow_global_mut<NamedGeneric::Container<u64>>(addr);
        // call generic method with explicit type argument after dot
        NamedGeneric::update_val<u64>(container_ref, 100u64);
    }

    /// Calls generic method without explicit type argument relying on type inference
    public fun call_borrow(account: &signer): u64 {
        let addr = signer::address_of(account);
        let container_ref: &NamedGeneric::Container<u64> = borrow_global<NamedGeneric::Container<u64>>(addr);
        // calls generic method; type inferred automatically as u64
        *NamedGeneric::borrow_val(container_ref)
    }

    /// Calls runner_abort in NamedGeneric to test abort with annotated state
    public fun call_abort() {
        NamedGeneric::runner_abort();
    }
}



//# run 0xBEEF::GenericMethodCaller::call_publish --signers 0xBEEF



//# run 0xBEEF::GenericMethodCaller::call_update --signers 0xBEEF



//# run 0xBEEF::GenericMethodCaller::call_borrow --signers 0xBEEF



//# run 0xBEEF::GenericMethodCaller::call_abort




//# publish
module 0xDEAD::CombinedTest {
    use std::signer;
    use 0xBEEF::GenericMethodCaller;
    use 0xCAFE::NamedGeneric;

    /// Publishes a Container<u8> with value 10 at signer's address
    public fun setup_u8(account: &signer) {
        NamedGeneric::publish_container<u8>(account, 10u8);
    }

    /// Invokes generic update_val<u8> method to update value to 20u8 using new generic method call syntax
    public fun update_container_u8(account: &signer) {
        let addr = signer::address_of(account);
        let container_ref: &mut NamedGeneric::Container<u8> = borrow_global_mut<NamedGeneric::Container<u8>>(addr);
        NamedGeneric::update_val<u8>(container_ref, 20u8);
    }

    /// Calls GenericMethodCaller::call_abort to trigger abort with annotated states
    public fun trigger_abort() {
        GenericMethodCaller::call_abort();
    }

    /// Calls GenericMethodCaller call_borrow to verify generic method call on a different account/address
    public fun call_borrow_from_other(addr: address): u64 {
        let container_ref: &NamedGeneric::Container<u64> = borrow_global<NamedGeneric::Container<u64>>(addr);
        *NamedGeneric::borrow_val(container_ref)
    }
}



//# run 0xDEAD::CombinedTest::setup_u8 --signers 0xDEAD



//# run 0xDEAD::CombinedTest::update_container_u8 --signers 0xDEAD



//# run 0xDEAD::CombinedTest::trigger_abort



//# run 0xDEAD::CombinedTest::call_borrow_from_other --args 0xBEEF
