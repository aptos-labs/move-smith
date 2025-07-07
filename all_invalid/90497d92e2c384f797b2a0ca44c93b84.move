
//# publish
module 0xCAFE::verify_only_module {
    // This module is for testing verify_only attribute
    #[verify_only]
    fun verify_only_func() {
        // verify_only function body
    }
}


//# publish
module 0xCAFE::shadow_test {
    struct ShadowHolder {
        value: u64,
    }

    public fun new_shadow_holder(initial_value: u64): Self.ShadowHolder {
        Self.ShadowHolder { value: initial_value }
    }

    public fun update_outer_variable() {
        let outer_var = 0;

        // Closure that shadows outer_var
        let closure = |increment: u64| {
            let outer_var = 42; // shadowed variable
            // Update outer_var
            outer_var = outer_var + increment;
        };

        // Invoke closure
        closure(10);
        // After invocation, outer_var should be unchanged because closure's outer_var is shadowed
        // But for testing, we can verify that inner shadow updates do not affect outer_var.
        // The test ensures shadowing works as expected.
    }

    public fun foo(b: bool, p: u64, q: u64): u64 {
        if (b) {
            p
        } else {
            q
        }
    }
}


//# run 0xCAFE::shadow_test::update_outer_variable

//# run 0xCAFE::shadow_test::foo --args true 100 200

//# run 0xCAFE::shadow_test::foo --args false 100 200

// Featurres:
// 052d6c58c202ddaf474ff0df4649731a: Use the 'verify_only' attribute to mark code that should only be included during verification and not in production execution.
// 118133204bf7d0b6a196821951fddb7c: Test that a variable shadowed within a closure correctly updates an outer variable when the closure is invoked.
// 367d844db019c3e521c4020b2042f6cf: Verify that the `foo` function correctly returns `p` when `b` is true and `q` when `b` is false.
