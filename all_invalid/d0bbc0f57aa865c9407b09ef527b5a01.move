
//# publish
module 0xDEAD::DeepFieldAccess {
    use std::vector;

    struct InnerStruct has copy, drop, store {
        a: u64,
        b: u64,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        c: u64,
    }

    public fun get_nested_access(s: &OuterStruct): u64 {
        s.inner.a
    }

    public fun get_inner_b(s: &OuterStruct): u64 {
        s.inner.b
    }
}


//# publish
module 0xBADD::ScopeTest {
    resources struct ResourceWithScope has copy, drop, store {
        val: u64,
    }

    public fun create_resource(addr: address, val: u64) {
        move_to<ResourceWithScope>(&signer::borrow_global_mut(addr), ResourceWithScope {val});
    }

    public fun test_scopes() {
        let outer_var = 100u64;

        let i = 0;
        while (i < 3) {
            let inner_var = i + 10;
            // Shadow outer_var inside loop
            let outer_var = i + 200;
            let _ = outer_var; // Should be outer_var from inner scope
            let _ = inner_var; // inner_var inside loop
            i = i + 1;
        };
        // After loop, outer_var should remain unchanged
        outer_var
    }
}


//# publish
module 0xC0FFEE::InternalFunctions {
    // Internal function, should not be callable outside
    fun internal_add(x: u64, y: u64): u64 {
        x + y
    }

    // External public function calling internal function
    public fun externally_accessible_add(x: u64, y: u64): u64 {
        internal_add(x, y)
    }
}


//# publish
module 0xFACE::SpecCheck {
    // Function with spec; no side effects
    public fun pure_function(a: u64, b: u64): u64
        //@ pure
        //@ verifies result >= a
        //@ verifies result >= b
    {
        a + b
    }

    // Function that violates spec (should be caught if checked)
    public fun violated_spec(a: u64): u64 {
        //@ invariant false
        a - 1
    }
}


//# publish
module 0xBABE::CurryingTest {
    // Curried function with conditional
    public fun make_adder(flag: bool): |u64|u64 {
        if (flag) {
            |x: u64| { x + 10 }
        } else {
            |x: u64| { x + 20 }
        }
    }

    // Closure with nested if
    public fun complex_closure(val: u64): u64 {
        let f = if (val % 2 == 0) {
            |x: u64| { x + 1 }
        } else {
            |x: u64| { x + 2 }
        };
        f(val)
    }
}


//# run 0xDEAD::DeepFieldAccess::get_nested_access --args 0xDEAD

//# run 0xDEAD::DeepFieldAccess::get_inner_b --args 0xDEAD


//# run 0xBADD::ScopeTest::test_scopes --args


//# run 0xC0FFEE::InternalFunctions::externally_accessible_add --args 5 6


//# run 0xFACE::SpecCheck::pure_function --args 3 4


//# run 0xBABE::CurryingTest::make_adder --args true

//# run 0xBABE::CurryingTest::make_adder --args false

//# run 0xBABE::CurryingTest::complex_closure --args 3


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
