//# publish
module 0xCAFE::TestShortCircuit {
    use std::debug;

    struct Counter has key {
        count: u64,
    }

    /// Increments the counter by 1 and returns true.
    public fun inc(counter: &mut Counter): bool {
        counter.count = counter.count + 1;
        true
    }

    /// Returns false and increments the counter.
    public fun inc_false(counter: &mut Counter): bool {
        counter.count = counter.count + 1;
        false
    }

    /// Run short-circuit tests on `&&` and `||`
    public fun runner() {
        let mut c = Counter { count: 0 };

        // Test '&&' where the first is false, second side-effect should be SKIPPED.
        if (false && inc(&mut c)) {
            debug::print(&b"should not execute this branch"[..]);
        }

        // c.count should remain 0 after above, but we ignore asserts here as per instructions.

        // Test '&&' where the first is true, second side-effect should RUN.
        if (true && inc(&mut c)) {
            debug::print(&b"did run inc (&& true)"[..]);
        }

        // c.count should be 1 now.

        // Reset counter
        c.count = 0;

        // Test '||' where first is true, second side-effect should be SKIPPED.
        if (true || inc(&mut c)) {
            debug::print(&b"short-circuit || first true"[..]);
        }

        // c.count should be 0 here.

        // Test '||' where first is false, second side-effect should RUN.
        if (false || inc(&mut c)) {
            debug::print(&b"did run inc (|| false)"[..]);
        }

        // c.count should be 1 now.

        // Also test functions that return false for && and true for ||
        // Using inc_false which increments then returns false.

        c.count = 0;
        // && with first true, second returns false and increments
        if (true && inc_false(&mut c)) {
            debug::print(&b"should not be true"[..]);
        }

        // c.count should be 1.

        c.count = 0;
        // || with first false, second returns false and increments
        if (false || inc_false(&mut c)) {
            debug::print(&b"should not be true"[..]);
        }

        // c.count should be 1.
    }
}


//# run 0xCAFE::TestShortCircuit::runner


//# publish
module 0xCAFE::TestCopyMove {
    /// Dummy empty struct W to test move semantics
    struct W has drop {}

    /// Takes a u64 by copy - should be preserved in caller.
    public fun take_u64(x: u64): u64 {
        x + 1
    }

    /// Takes W by move - ownership transferred to callee.
    public fun take_w(_w: W) {}

    /// Returns a fresh W
    public fun create_w(): W {
        W {}
    }

    /// Runner to test copy and move semantics
    public fun runner() {
        let x: u64 = 10;
        let y = take_u64(x);
        // x should still be valid after the call, no runtime error.

        let w1 = create_w();
        take_w(w1);
        // w1 is moved, should not be used anymore here.

        let w2 = create_w();
        let w3 = w2;
        take_w(w3);
        // w2 is also moved because w3 moved it, usage checks happen at compile time.
    }
}

//# run 0xCAFE::TestCopyMove::runner


//# publish
module 0xCAFE::TestStructConstructor {
    struct Foo has copy, drop {
        x: u64,
        y: u64,
    }

    struct Bar has copy, drop {
        foo: Foo,
        z: u64,
    }

    public fun make_foo(): Foo {
        Foo { x: 1, y: 2 }
    }

    public fun make_bar(): Bar {
        Bar {
            foo: Foo { x: 3, y: 4 },
            z: 5,
        }
    }

    public fun runner() {
        let a = make_foo();
        let b = make_bar();
        let c = Foo { x: a.x + b.foo.x, y: a.y + b.foo.y };
        let d = Bar { foo: c, z: b.z + 1 };
    }
}

//# run 0xCAFE::TestStructConstructor::runner


// Featurres:
// 4eed1d44c7a27e29c3c4204b709fb414: Test that short-circuit evaluation in boolean expressions correctly skips or executes side-effects within code blocks for '&&' and '||' operators.
// 52a81d03e41c5bbaaad10ea91fc12692: Test that copying and moving `u64` and `W` values correctly preserves or transfers ownership during function calls without runtime errors.
// e421a578cb88bf0c82f29b9c99ac86b7: Create struct constructor expressions by following a name with '{' and field expressions (e.g., Foo { x: 1, y: 2 }).
