
//# publish
module 0xCAFE::TestNestedFields {
    // Access nested fields, assign new values, verify retrieval
    struct NestedStruct has copy, drop, store {
        inner: InnerStruct,
    }

    struct InnerStruct has copy, drop, store {
        value: u64,
    }

    public fun create_nested_struct(val: u64): NestedStruct {
        NestedStruct { inner: InnerStruct { value: val } }
    }

    public fun get_nested_value(nested: &NestedStruct): u64 {
        nested.inner.value
    }

    public fun set_nested_value(nested: &mut NestedStruct, new_val: u64) {
        nested.inner.value = new_val;
    }

    
//# run 0xCAFE::TestNestedFields::create_nested_struct --args 42u64
}

//# publish
module 0xCAFE::TestWhileLoopShadow {
    // Declare outer variable
    public fun test_shadowing_in_while(): u64 {
        let outer_var = 0u64;
        let _ = while (outer_var < 3) {
            let outer_var = outer_var + 1; // shadowing
            // Should not interfere with outer outer_var
            outer_var
        };
        // After loop, outer_var should remain unchanged
        outer_var
    }

    // Additional test for inner variable inside loop
    public fun test_inner_loop_variable(): u64 {
        let inner_var = 5u64;
        let result = while (inner_var > 0) {
            // Use inner_var
            inner_var - 1
        };
        result
    }
    
//# run 0xCAFE::TestWhileLoopShadow::test_shadowing_in_while
    
//# run 0xCAFE::TestWhileLoopShadow::test_inner_loop_variable
}

//# publish
module 0xCAFE::InternalFunAccess {
    struct OnlyWithin { dummy: bool }

    // Public function with internal visibility - must not be accessible outside
    fun internal_helper(x: u64): u64 {
        x + 1
    }

    public fun caller(): u64 {
        internal_helper(10)
    }
    // No external access to internal_helper outside this module
    // The test will attempt to call external, which should fail if tested outside
}

//# publish
module 0xCAFE::TestSpecs {
    // Specification annotations with pure assertion (simulate, as Move does not have built-in spec)
    // Here, we mock assertions with explicit code and comments

    public fun check_pure_condition(x: u64): bool {
        // @@assert_pure
        // We define that x should be less than 100
        if (x >= 100) {
            // diagnostics: error, not pure
            abort(1);
        }
        true
    }

    public fun test_spec_violation() {
        // Deliberate violation
        check_pure_condition(200)
    }

    
//# run 0xCAFE::TestSpecs::check_pure_condition --args 50u64
    
//# run 0xCAFE::TestSpecs::test_spec_violation
}

//# publish
module 0xCAFE::TestCurryingClosures {
    // Curried function with different closure paths
    public fun make_adder(offset: u64): |u64|u64 {
        |x: u64| {
            x + offset
        }
    }

    public fun conditional_closure(condition: bool): u64 {
        let add_f = if (condition) {
            // closure adds 10
            |x: u64| { x + 10 }
        } else {
            // closure adds 20
            |x: u64| { x + 20 }
        };
        add_f(5)
    }

    
//# run 0xCAFE::TestCurryingClosures::make_adder --args 15u64
    
//# run 0xCAFE::TestCurryingClosures::conditional_closure --args true
    
//# run 0xCAFE::TestCurryingClosures::conditional_closure --args false
}

//# publish
module 0xCAFE::DeprecatedUsage {
    // Deliberately use deprecated syntax/module API to verify diagnostics
    // (Assuming 'vector for 'vector' is deprecated here in this test context)
    public fun use_deprecated_vector() {
        let v: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);
        // The compiler should emit a warning about 'vector' usage if deprecated
        // This will also verify diagnostics together with the testing framework
        // no further action needed here
    }
    
//# run 0xCAFE::DeprecatedUsage::use_deprecated_vector
}

//# publish
module 0xCAFE::TestDestructuring {
    // Destructuring with tuples
    public fun tuple_destructuring() {
        let (a, b, c) = (1u64, 2u64, 3u64);
        // Fields assigned with tuple pattern
        let _sum = a + b + c;
    }

    // Destructuring with struct
    struct DataStruct has copy, drop {
        field1: u8,
        field2: u16,
    }

    public fun struct_destructuring(ds: DataStruct) {
        let DataStruct { field1: f1, field2: f2 } = ds;
        // Variables f1, f2 extracted correctly
        let _name_sum = f1 as u16 + f2;
    }

    
//# run 0xCAFE::TestDestructuring::tuple_destructuring
    
//# run 0xCAFE::TestDestructuring::struct_destructuring --args (DataStruct {field1: 4u8, field2: 1000u16})
}


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// cd5523a4f8e9e1d63e286b7f9b823328: Use deprecated modules with caution, as such usage will generate warnings or diagnostics.
// 46f8063873f510eab3d9bc331c3f5180: Avoid using the built-in 'vector' name for variables or identifiers unless in module or module alias contexts.
// a4b3cc025165969ecdb1d77431e80679: Test tuple pattern matching and variable binding order in struct destructuring assignments.
