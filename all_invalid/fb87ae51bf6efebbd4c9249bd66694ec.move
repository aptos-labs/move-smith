
//# publish
module 0xCAFE::ParamShadowTest {
    use std::string;

    // test_case(priority = 1)]
    public fun test_shadowing_inside_closure() {
        let closure = |x: u8| {
            let x = x + 1;
            let x = x * 2;
            x // finally should be (original x + 1) * 2
        };
        let result = closure(3u8);
        let _ = result;
    }

    // test_case(priority = 2)]
    public fun test_reassign_param_in_closure() {
        let closure = |mut x: u8| {
            x = x + 5;
            x = x * 3;
            x // (original x + 5) * 3
        };
        let result = closure(2u8);
        let _ = result;
    }

    // test_case(priority = 3, note = "shadowing parameter with local variable")]

    public fun test_parameter_shadowing_and_assignment() {
        let lambda = |x: u64| {
            let x = 10u64;
            let x = x + 5;
            let y = x;
            y = y + 3;
            y
        };
        let val = lambda(1u64);
        let _unused = val;
    }

    // test_case(priority = 4, note = "multiple parameters shadowed and reassigned")]
    public fun test_multi_param_shadowing() {
        let f = |a: u8, b: u8| {
            let a = a + 1;
            let b = b * 2;
            let a = a + b;
            a
        };
        let out = f(3u8, 4u8);
        let _v = out;
    }

    // test_case(priority = 5, note = "nested closures with shadowing")]
    public fun test_nested_closures_shadowing() {
        let outer = |x: u8| {
            let x = x + 1;
            let inner = || {
                let x = x * 2;
                x
            };
            inner()
        };
        let val = outer(4u8);
        let _ = val;
    }

    // test_case(priority = 6)]
    public fun test_param_rename_and_shadow_mix() {
        let f = |x: u8| {
            let y = x + 1;
            let x = y * 3;
            x
        };
        let res = f(7u8);
        let _ = res;
    }

    // test_case(priority = 7)]
    public fun test_assign_to_param_not_shadowed() {
        let f = |x: u8| {
            let x = x;
            x = x + 10;
            x
        };
        let res = f(5u8);
        let _ = res;
    }

    // test_case(priority = 8)]
    public fun empty_test() {
        // Empty test to test attribute parsing
    }
}


//# run 0xCAFE::ParamShadowTest::test_shadowing_inside_closure


//# run 0xCAFE::ParamShadowTest::test_reassign_param_in_closure


//# run 0xCAFE::ParamShadowTest::test_parameter_shadowing_and_assignment


//# run 0xCAFE::ParamShadowTest::test_multi_param_shadowing


//# run 0xCAFE::ParamShadowTest::test_nested_closures_shadowing


//# run 0xCAFE::ParamShadowTest::test_param_rename_and_shadow_mix


//# run 0xCAFE::ParamShadowTest::test_assign_to_param_not_shadowed


//# run 0xCAFE::ParamShadowTest::empty_test


// Featurres:
// a4db3138872d2df958d438f31f72a8ac: Use parameterized attributes with parentheses and a comma-separated list of arguments (e.g., #[foo(arg1, arg2)]).
// ff8b56e9c55ebf08e7edfef4e331cd40: Write Move module test functions that can be automatically collected and executed by the compiler's test framework.
// 061fadf74953f74c4f90eec9d94e5870: Test that variable shadowing and assignment within closures work correctly, ensuring that parameters can be renamed and assigned as expected inside inline function calls.
