//# publish
module 0x afuera::resource_manager {
    struct ResourceA(has key) {
        amount: u64,
    }

    public fun init_resource(s: &signer) {
        move_to(s, ResourceA { amount: 0 });
    }

    public fun increase(s: &signer, delta: u64) acquires ResourceA {
        let resource_ref = borrow_global_mut<ResourceA>(Signer::address_of(s));
        resource_ref.amount += delta;
    }
}

//# publish
module 0x afuera::complex_workflows {
    use 0x afuera::resource_manager;
    struct ResourceB(has key) {
        counter: u64,
    }

    public fun start_work(s: &signer) {
        resource_manager::init_resource(s);
        move_to(s, ResourceB { counter: 50 });
    }

    public fun nested_operations(cont: ||) acquires ResourceA, ResourceB {
        // Increment ResourceA twice
        resource_manager::increase(&signer, 5);
        resource_manager::increase(&signer, 10);
        // Call nested continuation
        cont();
        // Further update after nested call
        resource_manager::increase(&signer, 1);
    }

    public fun validate_resources(s: &signer): bool acquires ResourceA, ResourceB {
        let a = borrow_global<ResourceA>(Signer::address_of(s));
        let b = borrow_global<ResourceB>(Signer::address_of(s));
        a.amount >= 16 && b.counter == 50
    }

    public fun init(s: &signer) {
        start_work(s);
        nested_operations(|| {});
    }
}

//# publish
module 0x afuera::tests {
    use 0x afuera::complex_workflows;
    use 0x afuera::resource_manager;

    fun setup(s: &signer) {
        complex_workflows::init(s);
    }

    fun test_resource_increments(): bool {
        complex_workflows::nested_operations(|| {
            // Inside nested, attempt to decrease ResourceA (should be prohibited in test)
            // or perform some other operation to verify resource state
        });
        // After nested, check resource states
        complex_workflows::validate_resources(&signer)
    }

    fun abort_large_value(): u8 {
        abort (999u64);
    }
}

//# run 0x afuera::tests::setup --signers 0x afuera
//# run 0x afuera::tests::test_resource_increments --signers 0x afuera
//# run 0x afuera::tests::abort_large_value