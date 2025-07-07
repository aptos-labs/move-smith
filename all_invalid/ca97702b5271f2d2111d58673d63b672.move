//# publish
module 0xCAFE::DestructuringBindings {
    // Test destructuring assignments in let bindings and function parameters

    struct Pair has copy, drop, store {
        first: u64,
        second: u64
    }

    struct Triple has copy, drop, store {
        a: u8,
        b: u8,
        c: u8
    }

    public fun destructure_let_bindings() {
        let (x, y) = (10u64, 20u64);
        let p = Pair {first: x, second: y};
        let Pair {first: a, second: b} = p;

        let t = Triple {a: 1, b: 2, c: 3};
        let Triple {a: a1, b: b1, c: c1} = t;
    }

    public fun destructure_function_parameter(pair: Pair) {
        let Pair {first: x, second: y} = pair;
        let _sum = x + y;
    }

    public fun destructure_param_in_function((a, b): (u8, u8)) {
        let _sum = (a as u64) + (b as u64);
    }

    // We test that parameters that are function types with function typed args is disallowed;
    // but since this is a test and compiler forbids them, we just show allowed function types.

    // Allowed: function type parameter that returns u8 and accepts u8
    public fun allowed_function_type_param(f: |u8|u8, x: u8): u8 {
        f(x)
    }

    // Allowed: function type param that accepts u8 and u16 and returns u16
    public fun allowed_function_type_param2(f: |u8, u16|u16, a: u8, b: u16): u16 {
        f(a, b)
    }

    // Prohibited example of function param that takes function type param is omitted,
    // because this is a compile error at language level < 2.2.
}

//# run 0xCAFE::DestructuringBindings::destructure_let_bindings

//# run 0xCAFE::DestructuringBindings::destructure_function_parameter --args 0xCAFE::DestructuringBindings::Pair { first: 5u64, second: 6u64 }

//# run 0xCAFE::DestructuringBindings::destructure_param_in_function --args (7u8, 8u8)

//# run 0xCAFE::DestructuringBindings::allowed_function_type_param --args 10u8

//# run 0xCAFE::DestructuringBindings::allowed_function_type_param2 --args 11u8 12u16

// Featurres:
// fbf6d074e8b73bdc6cd6271ed135c831: Bind variables to names in patterns using de-structuring assignments in let bindings or function parameters.
// 19bfa0cf41d8fc67ab2182ae166ce58a: Start parsing expressions when the next token is a number, byte string, identifier, or symbol like '@', '&', '*', '!'.
// f20a42ba428c3246ab635cc65010987f: Disallow parameters that are themselves function types where the function arguments are function-typed, unless the language version is at least 2.2.
