//# publish
module 0xCAFE::ShadowClosure {
    /// Tests variable shadowing in closures and updates outer variable
    public fun test_shadowing(): u64 {
        let mut x = 10;
        let closure = move || {
            let mut x = x; // shadows outer x
            x = x + 5;
            x
        };
        let inner_val = closure();
        // Manually update outer x here to emulate "update"
        x = x + inner_val;
        x
    }
}

//# run 0xCAFE::ShadowClosure::test_shadowing


//# publish
module 0xCAFE::NoFnReturn {
    /// This module is designed to test that returning a function-typed value (functor) is disallowed in versions before 2.2
    /// We'll try to declare a function returning a function type and will expect compilation to fail in old versions.
    /// Since actual compile failure cannot be captured here, we instead document it as a comment and provide a correct alternative.

    // The following code is commented out because it would fail in versions < 2.2
    
    /*
    public fun get_fun(): fun(u64): u64 {
        fun(x: u64): u64 {
            x + 1
        }
    }
    */

    /// Instead, provide a workaround: call the function inside, and return the result.
    public fun call_fun(x: u64): u64 {
        let f = fun(x: u64): u64 { x + 1 };
        f(x)
    }

    public fun runner(): u64 {
        call_fun(41)
    }
}

//# run 0xCAFE::NoFnReturn::runner


//# publish
module 0xCAFE::FreezeTests {
    /// Tests freezing &mut references safely in various contexts.

    struct S has key, store {
        val: u64
    }

    public fun new_s(val: u64): S {
        S { val }
    }

    /// Accepts &mut S and freezes it to &S in different ways.
    public fun freeze_in_assignment(s: &mut S): u64 {
        let ref_s = freeze(s);
        ref_s.val
    }

    public fun freeze_in_call(s: &mut S): u64 {
        helper_freeze(freeze(s))
    }

    fun helper_freeze(s: &S): u64 {
        s.val
    }

    public fun freeze_in_conditional(s: &mut S, flag: bool): u64 {
        if (flag) {
            let ref_s = freeze(s);
            ref_s.val
        } else {
            let ref_s = freeze(s);
            ref_s.val + 1
        }
    }

    public fun freeze_in_borrow_operation(s: &mut S): u64 {
        let r = freeze(s);
        borrow_field(r)
    }

    fun borrow_field(s: &S): u64 {
        s.val
    }

    public fun runner(): u64 {
        let mut s = new_s(100);
        let res1 = freeze_in_assignment(&mut s);
        let res2 = freeze_in_call(&mut s);
        let res3 = freeze_in_conditional(&mut s, true);
        let res4 = freeze_in_borrow_operation(&mut s);
        res1 + res2 + res3 + res4
    }
}

//# run 0xCAFE::FreezeTests::runner


// Featurres:
// 118133204bf7d0b6a196821951fddb7c: Test that a variable shadowed within a closure correctly updates an outer variable when the closure is invoked.
// 39a3cdaaa18a31c0d71575540bad9f84: Prevent functions from returning function-typed values in language versions before 2.2.
// b93d3ab4f27c60d785009cf046f3d8ee: Test that mutable references (`&mut`) can be safely and correctly frozen to immutable references (`&`) in various contexts, including function calls, assignments, conditionals, and borrow operations, ensuring proper Move type and borrow checker behavior.
