
//# publish
module 0xCAFE::ComprehensiveTest {
    use std::signer;
    use std::debug;

    // Resource to keep internal state for testing scope and access control
    struct InternalResource {
        counter: u64,
        shadowed_value: bool,
    }

    // Initialize the resource with default values
    public fun init(s: signer) {
        move_to<InternalResource>(&s, InternalResource { counter: 0, shadowed_value: false });
    }

    // Internal function with internal visibility
    fun internal_increment_counter(resource_ref: &mut InternalResource) {
        resource_ref.counter = resource_ref.counter + 1;
    }

    // Function to attempt external access (should fail) - not called externally
    fun external_access_test() acquires InternalResource {
        // Not callable externally; used for internal test only
        abort(0);
    }

    // Function that uses local variables, shadowing, and while loop
    public fun compute_value_and_shadow(s: &signer): u64 {
        let outer_var = 100u64; // outer variable
        let resource_ref: &mut InternalResource = borrow_global_mut<InternalResource>(signer::address_of(&s));
        // Use a local variable with same name to shadow
        let shadowed_value = false;

        // local variable inside while loop scope
        while (outer_var > 90) {
            let inner_shadowed = true; // shadowing within loop
            // modify resource
            internal_increment_counter(resource_ref);
            // update outer variable
            outer_var = outer_var - 2;
        };
        // After loop, check that outer_var has been updated
        let final_value = outer_var;
        // Check that shadowed_value and inner_shadowed do not affect outer scope
        final_value
    }

    // Function to verify that variables are assigned properly with expression binding
    public fun expression_binding_test(s: &signer): u64 {
        let a = 5u64;
        let b = 10u64;
        // Bind result of arithmetic expression
        let sum = a + b;
        // Bind result of a boolean expression
        let condition = (sum > 10);
        // Use condition in assertions/logic
        if (condition) {
            sum
        } else {
            0
        }
    }

    // Function to test short-circuit evaluation and side effects
    struct SideEffect {
        eval_order: vector<bool>,
    }

    // Helper for side effect: returns true and logs evaluation
    fun eval_side_effect(logs: &mut vector<bool>, index: u8): bool {
        vector::push_back(logs, true);
        true
    }

    // Helper for side effect: returns false and logs evaluation
    fun eval_side_effect_false(logs: &mut vector<bool>, index: u8): bool {
        vector::push_back(logs, false);
        false
    }

    // Function to test complex boolean expressions with side effects
    public fun short_circuit_test(s: &signer): bool {
        let logs = vector::empty<bool>();
        move_to<SideEffect>(&s, SideEffect { eval_order: logs });    

        // Example of short-circuit OR: second operand not evaluated if first is true
        let side_effect_ref: &mut SideEffect = borrow_global_mut<SideEffect>(signer::address_of(&s));
        let result = eval_side_effect(side_effect_ref, 1u8) || eval_side_effect_false(side_effect_ref, 2u8);
        // After evaluation, only first should be evaluated
        let logs_ref = &mut side_effect_ref.eval_order;
        let len = vector::length(logs_ref);
        let first_eval = if (len > 0) { *vector::borrow(logs_ref, 0) } else { false };
        let second_eval_index = 1;
        let second_eval = if (len > second_eval_index) { *vector::borrow(logs_ref, second_eval_index) } else { false };

        // Clean up resource
        move_from<SideEffect>(signer::address_of(&s)); 

        // The result of or should be true due to first operand
        result && first_eval && !second_eval
    }

    // Script entry point: runs the comprehensive tests
//# run
    script {
        /// Initialize
        let s = signer::borrow_as_signer(signer::path()); 
//# assumes existence of signer in context
        0xCAFE::ComprehensiveTest::init(&s);

        // Call compute_value_and_shadow and verify updates
        let final_counter = 0xCAFE::ComprehensiveTest::compute_value_and_shadow(&s);
        // Call expression_binding_test and verify
        let sum = 0xCAFE::ComprehensiveTest::expression_binding_test(&s);
        // Call short_circuit_test, verify the boolean result
        let sc_result = 0xCAFE::ComprehensiveTest::short_circuit_test(&s);
    }
}


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// caa4ab8a3e36141117c8c50d0a12748d: Specify global or local variables in specifications.
// b97f161fc46919e92f4e2b88ea9444ff: Bind variables to the result of expressions
// 82f755af6a64ca1b7520a8282c6064dc: Define scripts using the 'script' keyword in Move files.
// e0e68c3cb67e1c48fdf914afc3bed004: Test that short-circuit evaluation in boolean expressions executes side effects in the correct order and only as needed.
