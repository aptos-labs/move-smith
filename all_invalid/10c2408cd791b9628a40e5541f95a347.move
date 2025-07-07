
//# publish
module 0xCAFE::EnumFieldAccessTest {
    use std::signer;
    use std::event;

    // Enum with fields to test field access across variants
    enum Data has copy, drop {
        V1 { x: u8, y: u8 },
        V2(u8, u8),
        V3 { x: u8, y: u8 }
    }

    // Event type and handle for tracking side effects in short-circuit tests
    struct SideEffectEvent has copy, drop, store {
        label: u8,
    }

    struct EventHolder has key {
        handle: event::EventHandle<SideEffectEvent>,
    }

    public fun init_event_holder(s: &signer) {
        assert!(!exists<EventHolder>(signer::address_of(s)), 1);
        let eh = event::new_event_handle<SideEffectEvent>(s);
        move_to<EventHolder>(s, EventHolder { handle: eh });
    }

    fun emit_side_effect(label: u8, addr: address) {
        if (exists<EventHolder>(addr)) {
            let holder_ref = borrow_global_mut<EventHolder>(addr);
            event::emit_event(&mut holder_ref.handle, SideEffectEvent { label });
        };
    }

    // Accessor functions for each variant to validate correct field reads

    public fun access_v1(data: Data): (u8, u8) {
        match (data) {
            Data::V1 { x, y } => (x, y),
            _ => (0, 0),
        }
    }

    public fun access_v2(data: Data): (u8, u8) {
        match (data) {
            Data::V2(x, y) => (x, y),
            _ => (0, 0),
        }
    }

    public fun access_v3(data: Data): (u8, u8) {
        match (data) {
            Data::V3 { x, y } => (x, y),
            _ => (0, 0),
        }
    }

    // === Boolean Short-Circuit Semantics Test ===
    // We'll track side effects by emitting events.

    // Returns true and does not emit side effect
    public fun true_without_effect(): bool {
        true
    }

    // Emits event with label 1, returns true
    public fun true_with_effect(s: signer): bool {
        emit_side_effect(1u8, signer::address_of(&s));
        true
    }

    // Emits event with label 2, returns false
    public fun false_with_effect(s: signer): bool {
        emit_side_effect(2u8, signer::address_of(&s));
        false
    }

    // Short-circuit OR: lhs true means rhs not evaluated; no event emitted
    public fun test_short_circuit_or(s: signer): bool {
        // Left side true, right side side-effect function
        let lhs = true_without_effect();
        let rhs = false_with_effect(s); // Should NOT be called

        // short-circuit OR prevents rhs; use '||' operator
        let result = lhs || rhs;
        // result expected true
        result
    }

    // Short-circuit AND: lhs false means rhs not evaluated; no event emitted
    public fun test_short_circuit_and(s: signer): bool {
        // Left side false, right side side-effect function
        let lhs = false_with_effect(s); // This emits event, result false
        let rhs = true_with_effect(s);  // Should NOT be called

        // short-circuit AND prevents rhs; use '&&' operator
        let result = lhs && rhs;
        // result expected false
        result
    }

    // Non short-circuit OR: lhs false means rhs evaluated; event emitted
    public fun test_no_short_circuit_or(s: signer): bool {
        let lhs = false_with_effect(s); // emits
        let rhs = true_with_effect(s);  // emits

        let result = lhs || rhs;
        result
    }

    // Non short-circuit AND: lhs true means rhs evaluated; event emitted
    public fun test_no_short_circuit_and(s: signer): bool {
        let lhs = true_without_effect(); // does not emit
        let rhs = false_with_effect(s);  // emits

        let result = lhs && rhs;
        result
    }

    // Runner to do all tests for field access on enum variants
    public fun runner_enum_field_access_tests() {
        let v1 = Data::V1 { x: 42u8, y: 24u8 };
        let v2 = Data::V2(1u8, 2u8);
        let v3 = Data::V3 { x: 100u8, y: 200u8 };

        let (x1, y1) = access_v1(v1);
        assert!(x1 == 42u8, 100);
        assert!(y1 == 24u8, 101);

        let (x2, y2) = access_v2(v2);
        assert!(x2 == 1u8, 102);
        assert!(y2 == 2u8, 103);

        let (x3, y3) = access_v3(v3);
        assert!(x3 == 100u8, 104);
        assert!(y3 == 200u8, 105);
    }

    // Runner for short-circuit boolean tests
    public fun runner_short_circuit_tests(s: signer) {
        init_event_holder(&s);

        // Before tests, event count should be zero; no direct query, but logically.

        // test short-circuit OR: rhs should NOT be called -> no events with label 1 or 2
        let or_result = test_short_circuit_or(s);
        assert!(or_result == true, 200);

        // test short-circuit AND: rhs should NOT be called -> no event with label 1
        let and_result = test_short_circuit_and(s);
        assert!(and_result == false, 201);

        // test no short-circuit OR: rhs called -> events with label 1 and 2 emitted
        let or_non_sc_result = test_no_short_circuit_or(s);
        assert!(or_non_sc_result == true, 202);

        // test no short-circuit AND: rhs called -> event with label 2 emitted
        let and_non_sc_result = test_no_short_circuit_and(s);
        assert!(and_non_sc_result == false, 203);
    }

    // This function uses newer language features
    // For demonstration, we'll use a function with explicit visibility modifiers and explicit abilities on structs/enums
    // Also usage of advanced resource manipulations

    struct NewFeatureResource has key, store, drop, copy {
        value: u64,
    }

    public(friend) fun create_new_feature_resource(s: signer, v: u64): NewFeatureResource {
        NewFeatureResource { value: v }
    }

    public(friend) fun publish_new_feature_resource(s: signer, v: u64) {
        let r = create_new_feature_resource(s, v);
        move_to<NewFeatureResource>(&s, r);
    }

    public(friend) fun read_and_destroy_resource(s: signer): u64 {
        let r = move_from<NewFeatureResource>(signer::address_of(&s));
        r.value
    }

    public fun runner_min_language_version_tests(s: signer) {
        // Publish resource
        publish_new_feature_resource(s, 999u64);
        // Read and destroy
        let v = read_and_destroy_resource(s);
        assert!(v == 999u64, 300);
    }
}


//# run 0xCAFE::EnumFieldAccessTest::runner_enum_field_access_tests


//# run 0xCAFE::EnumFieldAccessTest::runner_short_circuit_tests --signers 0xF00D


//# run 0xCAFE::EnumFieldAccessTest::runner_min_language_version_tests --signers 0xD00D


// Featurres:
// 4d4818b370cd8102dd79ae5fffeaf3fc: Test that accessing the `x` and `y` fields of each variant (`V1`, `V2`, `V3`) of the `Data` enum correctly retrieves the expected values.
// 0ff2b719bdeba11c8287d54d14c82eeb: Verify that the Move language correctly implements short-circuit evaluation for boolean operators (|| and &&) so that the right-hand side expressions are not executed when the left-hand side determines the result.
// 81d7b796a8282833827611e111ad9db6: Use language constructs that require a minimum Move language version.
