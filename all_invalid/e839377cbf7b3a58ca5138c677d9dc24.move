
//# publish
module 0xCAFE::ValueEqualityMatchTest {
    use std::vector;

    struct U64Wrapper has copy, drop, store, eq {
        val: u64,
    }

    public fun create_value_u64(x: u64): u64 {
        // make a copy of the literal u64 value using value expression
        let v = value<u64>(x);
        v
    }

    public fun create_value_bool(b: bool): bool {
        let v = value<bool>(b);
        v
    }

    public fun create_struct_with_value(x: u64): U64Wrapper {
        // create a struct with val = value<u64>(x)
        let w = U64Wrapper { val: value<u64>(x) };
        w
    }

    public fun eq_u64_literals(a: u64, b: u64): bool {
        a == b
    }

    public fun eq_struct_wrappers(a: U64Wrapper, b: U64Wrapper): bool {
        // rely on auto-generated eq for struct U64Wrapper
        a == b
    }

    public fun match_on_u64_val(x: u64): u64 {
        match (x) {
            0u64 => 10u64,
            1u64 => 11u64,
            _ => 42u64,
        }
    }

    public fun match_on_value_expr(x: u64): u64 {
        let v = value<u64>(x);
        match (v) {
            100u64 => 200u64,
            42u64 => 420u64,
            _ => 0u64,
        }
    }

    public fun match_on_struct_field(s: U64Wrapper): bool {
        match (s.val) {
            0u64 => false,
            1u64 => true,
            _ => false,
        }
    }

    public fun match_with_eq_in_arm(x: u64): u64 {
        match (x) {
            a => {
                if (a == 123u64) {
                    9u64
                } else {
                    8u64
                }
            }
        }
    }

    public fun integrated_test(x: u64): bool {
        let v = value<u64>(x);
        let w = U64Wrapper { val: v };
        match (w) {
            U64Wrapper { val } => {
                if (val == value<u64>(x)) {
                    true
                } else {
                    false
                }
            }
        }
    }

    public fun runner() {
        let _ = create_value_u64(123u64);
        let _ = create_value_bool(true);
        let s1 = create_struct_with_value(10u64);
        let s2 = create_struct_with_value(10u64);
        let s3 = create_struct_with_value(11u64);
        let _ = eq_u64_literals(10u64, 10u64);
        let _ = eq_u64_literals(10u64, 11u64);
        let _ = eq_struct_wrappers(s1, s2);
        let _ = eq_struct_wrappers(s1, s3);
        let _ = match_on_u64_val(1u64);
        let _ = match_on_u64_val(5u64);
        let _ = match_on_value_expr(42u64);
        let _ = match_on_value_expr(200u64);
        let _ = match_on_struct_field(s1);
        let _ = match_with_eq_in_arm(123u64);
        let _ = match_with_eq_in_arm(0u64);
        let _ = integrated_test(999u64);
        let _ = integrated_test(0u64);
    }
}


//# run 0xCAFE::ValueEqualityMatchTest::runner


// Featurres:
// ff513cd37aa928903aae1b007537a562: Create value expressions using literals with the `value` expression.
// 03c60ac174e683c8896c630039c7b951: Verify that the equality functions correctly compare u64 values and custom struct instances with a u64 field.
// dd45b96ea0255dd2bc3c9268e179045c: Write match expressions using the syntax `match (<exp>) { <arms> }` to perform pattern matching in Move code.
