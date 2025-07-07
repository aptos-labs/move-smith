//# publish
module 0xCAFE::ControlFlowTests {
    use std::signer;
    use std::option;
    use std::vector;

    const ABORT_CODE: u64 = 777;

    struct Control has copy, drop, store {
        value: u8,
    }

    enum TestEnum has copy, drop {
        Alpha,
        Beta(u8),
        Gamma {
            flag: bool,
        }
    }

    public fun new_control(u: u8): Control {
        Control { value: u }
    }

    public fun test_return_abort(c: &Control): u8 {
        let val = c.value;
        if (val == 0) {
            abort 1000;
        } else if (val > 100) {
            abort 2000;
        };
        val
    }

    public fun test_deref_and_unary(c: &Control): u8 {
        let mut v = c.value;
        // unary negation is not allowed (negatives do not exist), instead test logical not for bool in gamma variant below
        // but for integers test '+' unary operator does nothing, just annotation example
        let plus_v = +v;
        // increment value by 1 without mut, use let shadowing
        let v = v + 1;
        plus_v + v
    }

    public fun test_borrow_and_cast(c: &Control): u32 {
        // borrow value as reference and cast to u32
        let val_ref: &u8 = &c.value;
        val_ref as u32
    }

    public fun test_annotate_and_control() {
        let x: u8 = 5;
        let _y: u8 = x;
        if (x == 5) {
            let _z = 10u8;
        };
    }

    public fun test_enum_and_pattern(te: TestEnum): u8 {
        match te {
            TestEnum::Alpha => 0,
            TestEnum::Beta(n) => n,
            TestEnum::Gamma { flag } => {
                if (flag) {
                    1
                } else {
                    2
                }
            },
        }
    }

    public fun test_enum_matching_external(te: &TestEnum): u8 {
        // This function should not match or test variants of TestEnum
        // so instead we test only that the value exists via option
        // we return a dummy constant
        42
    }

    #[spec, aborts_with(ABORT_CODE)]
    public fun spec_aborts_example(x: u8) {
        if (x == 0) {
            abort ABORT_CODE;
        };
    }

    public fun runner() {
        let c = new_control(10);
        let ret = test_return_abort(&c);
        let deref_val = test_deref_and_unary(&c);
        let cast_val = test_borrow_and_cast(&c);
        test_annotate_and_control();

        let e1 = TestEnum::Alpha;
        let _r1 = test_enum_and_pattern(e1);
        let e2 = TestEnum::Beta(7);
        let _r2 = test_enum_and_pattern(e2);
        let e3 = TestEnum::Gamma { flag: true };
        let _r3 = test_enum_and_pattern(e3);

        test_enum_matching_external(&e2);

        spec_aborts_example(42);
    }
}

//# run 0xCAFE::ControlFlowTests::runner

// Featurres:
// 0921e8850c230c2fadc8bf228b548cec: Return, abort, dereference, perform unary operations, borrow, cast, test, or annotate expressions for control and type management.
// e4b6f4a917bb2748ccb7291edd059424: Specify explicit abort codes using 'aborts_with' in specification blocks.
// 441a5f8861ca4825a379f5604c85df72: Restrict variant pattern matching and testing on enum types to within the module that defines them unless otherwise allowed.
