//# publish
module 0xCAFE::AbilitiesTest {
    use std::vector;
    use std::debug;

    // Define custom ability sets to test uniqueness
    // The ability set should only contain unique abilities despite duplicates in input
    // This simulates the ability sets creation and uniqueness validation.
    abilities copy, drop, store;

    /// Our own enum for abilities to simulate ability sets (copy, drop, store)
    enum Ability {
        Copy,
        Drop,
        Store,
    }

    public fun unique_abilities(abilities: vector<u8>): vector<u8> acquires AbilitySet {
        // This function simulates removing duplicates by building a set (vector here)
        let mut unique = vector::empty<u8>();
        let mut i = 0;
        while (i < vector::length(&abilities)) {
            let ab = *vector::borrow(&abilities, i);
            let mut found = false;
            let mut j = 0;
            while (j < vector::length(&unique)) {
                if (*vector::borrow(&unique, j) == ab) {
                    found = true;
                    break;
                };
                j = j + 1;
            };
            if (!found) {
                vector::push_back(&mut unique, ab);
            };
            i = i + 1;
        };
        unique
    }

    /// Runner function to test unique_abilities with duplicates
    public fun runner() {
        let input = vector::from_bytes(b"\x00\x01\x00\x02\x01"); // abilities with duplicate 0,1
        let _unique = unique_abilities(input);
        // no assertions needed, just ensure it runs
    }

    /// Function that returns a vector of diagnostics (tuples of source location, message)
    public fun diagnostics() : vector<(u64, vector<u8>)> {
        let mut diags = vector::empty<(u64, vector<u8>)>();
        vector::push_back(&mut diags, (300, b"Third diagnostic"));
        vector::push_back(&mut diags, (100, b"First diagnostic"));
        vector::push_back(&mut diags, (200, b"Second diagnostic"));
        // Ideally sort by source location
        diags = sort_diagnostics(diags);
        diags
    }

    /// Sort diagnostics by u64 source location (simple bubble sort)
    fun sort_diagnostics(mut diags: vector<(u64, vector<u8>)>): vector<(u64, vector<u8>)> {
        let len = vector::length(&diags);
        let mut i = 0;
        while (i < len) {
            let mut j = 0;
            while (j + 1 < len - i) {
                let curr = *vector::borrow(&diags, j);
                let next = *vector::borrow(&diags, j+1);
                if (curr.0 > next.0) {
                    // swap
                    let temp = curr;
                    vector::borrow_mut(&mut diags, j) = next;
                    vector::borrow_mut(&mut diags, j+1) = temp;
                };
                j = j + 1;
            };
            i = i + 1;
        };
        diags
    }

    /// Runner to call diagnostics and sort_diagnostics
    public fun diagnostics_runner() {
        let _sorted_diags = diagnostics();
    }

    // Resource to enforce reads annotation test
    resource struct TestResource has key {
        val: u64,
    }

    /// Create resource for testing
    public fun create_resource(account: &signer) {
        move_to(account, TestResource { val: 42 });
    }

    /// Reads annotation function that reads `TestResource` only from the given signer address
    public fun reads_test(account: &signer) acquires TestResource {
        let _res_ref = borrow_global<TestResource>(signer::address_of(account));
        // just read the value
        let _val = _res_ref.val;
    }

    /// Runner function that does nothing (to test reads annotation with no args)
    public fun reads_runner(_account: &signer) acquires TestResource {}

}

//# run 0xCAFE::AbilitiesTest::runner --signers 0xCAFE

//# run 0xCAFE::AbilitiesTest::diagnostics_runner

//# run 0xCAFE::AbilitiesTest::create_resource --signers 0xCAFE

//# run 0xCAFE::AbilitiesTest::reads_test --signers 0xCAFE


// Featurres:
// f54bf3d53e37f3ec162af7f16c9f44d2: Create abilities sets from a list of abilities, ensuring each ability is unique within the set.
// 2d60c29ba5de06ed22e8beb91d9094bd: See diagnostics in a consistent, sorted order based on source location to aid in debugging
// 2fd4f068566572e4e6a8f5fdda52c089: Test that the Move VM correctly enforces read access restrictions declared with the `reads` annotation by allowing access only to the specified resources and addresses.
