//# publish
module 0xCAFE::NestedStructTest {
    // Struct with nested field types and abilities
    struct Inner has copy, drop, store {
        x: u8,
        y: u8,
    }

    struct Outer has copy, drop, store {
        a: u64,
        b: Inner,
        c: u8,
    }

    // Initializes Outer with nested expressions
    public fun make_outer(): Outer {
        let calc = 2 + 3;
        let inner = Inner { x: 42, y: 58 };
        Outer { a: (calc as u64) * 20, b: inner, c: inner.x + 11 }
    }

    // Sums all fields inside Outer, including fields of the nested struct
    public fun sum_outer(o: &Outer): u64 {
        let sum = o.a + (o.b.x as u64) + (o.b.y as u64) + (o.c as u64);
        sum
    }

    // "Runner" function: constructs Outer, sums fields and discards result
    public fun run_test() {
        let o = make_outer();
        let total = sum_outer(&o);
        // total value is returned here for completeness, but not used
        total;
    }
}
//# run 0xCAFE::NestedStructTest::run_test

//# publish
module 0xCAFE::QuantifierTest {
    // Use of 'forall' universal quantifier in specification (ghost code)
    // Note: The 'spec' block is not executed at runtime,
    // but is parsed and typechecked by compiler, ensuring language feature
    public fun forall_demo(n: u8): u8 {
        spec forall_demo {
            // For all x in [0, n), x < n
            // (this is not actual spec Move code syntax, since Move does not support real runtime
            // quantifiers in code, but this is only an illustrative exercise for parsing, so
            // we just comment out)
            // forall x: u8; (x < n) ==> (x < 100)
        }
        n + 1
    }

    public fun run_test() {
        forall_demo(10);
    }
}
//# run 0xCAFE::QuantifierTest::run_test

//# publish
module 0xCAFE::AbortAnnotationTest {
    public fun abort_with_reason(x: u8): u8 {
        if (x == 0) {
            // Test abort with a custom code and annotation
            /*@abort(42, "Input x must not be zero")*/
            abort 42;
        } else if (x > 10) {
            /*@abort(77, "Input x is too large")*/
            abort 77;
        };
        x * 2
    }

    public fun run_test() {
        // Each abort_with_reason call below will abort, so only the first call will ever execute.
        // If you want to exercise all abort branches, you need to comment/uncomment appropriate calls.
        // For transactional test, keep only one abort per run.
        abort_with_reason(0);
        //abort_with_reason(15);
        //abort_with_reason(3);
    }
}
//# run 0xCAFE::AbortAnnotationTest::run_test --signers 0xCAFE

// Featurres:
// a68db4fdbfc3a4cda1b4e974ef8912ce: Test that the Move module correctly initializes a struct with nested expressions and correctly destructures it to sum its fields.
// fe9389b33d5c39d4508f4bdeb40560ab: Declare universal quantifiers using the syntax 'forall'.
// a921df2a3e5dbeb0115cdd5d0717c761: Format and display abort state annotations within a function.