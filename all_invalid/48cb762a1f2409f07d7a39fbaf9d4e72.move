//# publish
module 0x1::UnitTypeExample {
    // Define a unit struct type with no fields
    struct UnitType has copy, drop, store {}

    // Define another unit struct type, test that it's treated properly
    struct Marker has copy, drop, store {}

    // Function that returns a UnitType instance
    public fun create_unit(): UnitType {
        UnitType {}
    }

    // Function that takes a reference to UnitType and returns a reference to Marker
    // to test reference safety and annotations
    public fun ref_test(u: &UnitType): &Marker acquires Marker {
        // We create a local marker to return a reference to
        // Normally this would be unsafe, but this is just a test for reference checking
        // So we do a reference to a global resource we create for this example

        // Let's create a global Marker resource under signer 0x1 to have a reference
        // But we do not have signer, so changing approach:
        // We'll store a static Marker in a global resource and reference that

        // For test purposes, return a reference to a static stored Marker resource that we create below
        borrow_marker()
    }

    // Storage for Marker, simulated as a single global resource
    struct MarkerStore has key {
        marker: Marker
    }

    // Initializes MarkerStore under 0x1
    public fun init_marker_store(account: &signer) {
        assert!(!exists<MarkerStore>(signer::address_of(account)), 1);
        move_to(account, MarkerStore { marker: Marker {} });
    }

    // Borrow a reference to the Marker in MarkerStore under 0x1
    public fun borrow_marker(): &Marker {
        &borrow_global<MarkerStore>(@0x1).marker
    }

    // A runner function that will init MarkerStore and do a reference safety test
    public fun runner(account: &signer) {
        init_marker_store(account);
        let unit_instance = create_unit();
        let unit_ref = &unit_instance;
        let _marker_ref = ref_test(unit_ref);
        // Just consume variables to prevent optimization away
        let _ = _marker_ref;
    }
}
//# run 0x1::UnitTypeExample::runner --signers 0x1

//# publish
module 0x1::RefSafetyTest {
    use std::signer;

    // Define a resource type to test borrowing and reference safety
    struct ResourceType has key {
        value: u64,
    }

    // Publish a resource under account
    public fun publish_resource(account: &signer, val: u64) {
        assert!(!exists<ResourceType>(signer::address_of(account)), 1);
        move_to(account, ResourceType { value: val });
    }

    // A function to test safe mutable and immutable borrow. It borrows immutable then mutable refs
    // to test ref safety rules.
    public fun test_borrows(addr: address) {
        let res_ref = borrow_global<ResourceType>(addr);
        let _v = res_ref.value; // read, immutable borrow

        let mut_ref = borrow_global_mut<ResourceType>(addr);
        mut_ref.value = mut_ref.value + 1;

        // Dropping references here to test ref safety via annotations
    }

    // Runner that publishes resource and runs borrow test
    public fun runner(account: &signer) {
        publish_resource(account, 42);
        test_borrows(signer::address_of(account));
    }
}
//# run 0x1::RefSafetyTest::runner --signers 0x1

//# run
script {
    use std::signer;
    use 0x1::UnitTypeExample;
    use 0x1::RefSafetyTest;

    fun main(account: signer) {
        // Run UnitTypeExample runner
        UnitTypeExample::runner(&account);

        // Run RefSafetyTest runner
        RefSafetyTest::runner(&account);
    }
}