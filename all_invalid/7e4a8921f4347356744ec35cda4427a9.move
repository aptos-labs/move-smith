
//# publish
module 0xCAFE::DeprecationTest {
    // Removed unused alias 'use std::signer;'

    // deprecated(reason = "Use new_val instead")]
    const OLD_CONST: u8 = 42;

    // deprecated(reason = "Use new_func instead")]
    public fun old_func(): u8 {
        7
    }

    // deprecated(reason = "Use field_new instead")]
    struct DeprecatedStruct has copy, drop, store {
        // deprecated(reason = "Old field deprecated")]
        field_old: u8,
        field_new: u8,
    }

    public struct FuncFieldStruct has copy, drop, store {
        func: fun(u8): u8,
    }

    public fun built_in_func(a: u8): u8 {
        a + 1
    }

    public fun new_func(): u8 {
        // this function replaces old_func, just return 8
        8
    }

    public fun test_deprecated_usage(): u8 {
        // using deprecated constant to get compiler warning
        let c = OLD_CONST;

        // using deprecated function to get warning
        let f = old_func();

        let s = DeprecatedStruct {
            field_old: 1,
            field_new: 2,
        };

        // using field_old is deprecated, but just read it here
        let _old_field_value = s.field_old;

        // use deprecated const, function and field to aggregate a value
        c + f + s.field_new
    }

    public fun test_function_field(x: u8): u8 {
        // instantiate struct with function field using a named function instead of a closure
        let ff = FuncFieldStruct {
            func: built_in_func
        };

        // call the function stored in struct field - wrap field access with ()
        (ff.func)(x)
    }
}



//# run 0xCAFE::DeprecationTest::test_deprecated_usage



//# run 0xCAFE::DeprecationTest::test_function_field --args 15u8



//# publish
module 0xCAFE::VariableStateTest {
    // We simulate initializing variables and changing them with prints
    // but since Move doesn't have prints, we do dummy usage to force state

    // Dummy function to simulate inspecting variable states by returning tuple snapshots
    // We test variable states before and after instructions by returning values stepwise

    public fun variable_states(): (u8, u8, u8) {
        let a = 1u8;
        let b = 2u8;
        let c = 3u8;

        // simulate "before" state by packing variables
        let before = a + b + c; // 6

        // instruction 1: update a
        let a = a + 5;

        // instruction 2: update b
        let b = b * 2;

        // instruction 3: update c
        let c = c + a;

        // simulate "after" state pack
        let after = a + b + c; // expect 6+4+9 = 19

        (before, after, c)
    }
}



//# run 0xCAFE::VariableStateTest::variable_states
