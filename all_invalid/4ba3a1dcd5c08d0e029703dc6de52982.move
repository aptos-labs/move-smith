
//# publish
module 0xCAFE::AssignmentTests {
    use std::vector;

    struct Inner has copy, drop, store {
        val: u8,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        data: u8,
    }

    // Store a resource at signer's addr, for inspection in tests
    struct Stored has key, store {
        outer: Outer,
    }

    public fun init_store(s: &signer) {
        let inner = Inner { val: 10u8 };
        let outer = Outer { inner, data: 20u8 };
        move_to<Stored>(s, Stored { outer });
    }

    public fun read_data(s: &signer): (u8, u8) {
        let stored_ref = borrow_global<Stored>(signer::address_of(s));
        (stored_ref.outer.inner.val, stored_ref.outer.data)
    }

    // Valid field write assignments: update inner.val and outer.data
    public fun update_fields(s: &signer, new_inner_val: u8, new_data: u8) {
        let stored_mut_ref = borrow_global_mut<Stored>(signer::address_of(s));
        stored_mut_ref.outer.inner.val = new_inner_val;
        stored_mut_ref.outer.data = new_data;
    }

    // Nested field write inside a loop for mutating state multiple times
    public fun field_write_in_loop(s: &signer, n: u8) {
        let stored_mut_ref = borrow_global_mut<Stored>(signer::address_of(s));
        let i = 0u8;
        while (i < n) {
            stored_mut_ref.outer.inner.val = stored_mut_ref.outer.inner.val + 1;
            stored_mut_ref.outer.data = stored_mut_ref.outer.data + 1;
            i = i + 1;
        };
    }

    // Invalid assignment examples as comments for explanation:
    // The following lines WOULD NOT COMPILE and are intentionally left commented:
    // let x = 1;
    // x + 1 = 2;  // invalid LHS, not simple variable nor allowed field write
    // vector::borrow(&v, 0) = 5;  // invalid LHS, cannot assign to vector borrow

    // To verify syntax validation and error reporting,
    // separate tests should try compiling these invalid assignments.

    // Infinite loop with no state change but consumes gas
    public fun infinite_loop() {
        loop {
            // no state mutation
        };
    }

    // Combined test: assign fields inside infinite loop, expect gas consumption
    public fun infinite_loop_field_write(s: &signer) {
        let stored_mut_ref = borrow_global_mut<Stored>(signer::address_of(s));
        loop {
            stored_mut_ref.outer.inner.val = stored_mut_ref.outer.inner.val + 1;
        };
    }
}


//# run 0xCAFE::AssignmentTests::init_store --signers 0xBEEF


//# run 0xCAFE::AssignmentTests::read_data --signers 0xBEEF


//# run 0xCAFE::AssignmentTests::update_fields --signers 0xBEEF --args 42u8 43u8


//# run 0xCAFE::AssignmentTests::read_data --signers 0xBEEF


//# run 0xCAFE::AssignmentTests::field_write_in_loop --signers 0xBEEF --args 5u8


//# run 0xCAFE::AssignmentTests::read_data --signers 0xBEEF


//# run 0xCAFE::AssignmentTests::infinite_loop


//# run 0xCAFE::AssignmentTests::infinite_loop_field_write --signers 0xBEEF


// Featurres:
// c489a6fe47f33556439ac9db32ee9dc2: Detect and report invalid assignment syntax outside of allowed patterns.
// 672648ae28d823ed2b04a70242c4f3bc: Use field writes (e.g., assign to a field of a struct) as a left-hand side of assignment.
// 2b95d63253347d971b7a478f76be295d: Test that executing an infinite loop consumes gas until it runs out and causes a transaction failure.
