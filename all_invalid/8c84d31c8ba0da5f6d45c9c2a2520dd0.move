
//# publish
module 0xCAFE::NativeWithVisibility {
    use std::address;

    // Native function with public visibility and entry attribute
    // native(public)]
    native public fun native_add(x: u64, y: u64): u64;

    // Native function with friend visibility and entry attribute
    // native(friend)]
    native friend fun native_multiply(x: u64, y: u64): u64;

    // Define a function callable as entry, calls native functions
    public entry fun call_native_functions(x: u64, y: u64): (u64, u64) {
        let add_res = native_add(x, y);
        let mul_res = native_multiply(x, y);
        (add_res, mul_res)
    }
}


//# publish
module 0xCAFE::UsingNativeWithVisibility {
    use 0xCAFE::NativeWithVisibility;

    // Public function calling the entry function from NativeWithVisibility
    public fun invoke_entry(x: u64, y: u64): (u64, u64) {
        NativeWithVisibility::call_native_functions(x, y)
    }
}


//# publish
module 0xCAFE::MatchWithIfGuard {
    use 0xCAFE::NativeWithVisibility;

    public enum Color has copy, drop {
        Red,
        Green,
        Blue,
        Custom(u64)
    }

    public fun match_with_guard(c: Color, val: u64): u8 {
        let res = match (c) {
            Color::Red => 1,
            Color::Green if (val > 10) => 2, // if guard expression on match arm
            Color::Blue => 3,
            Color::Custom(x) if (x % 2 == 0) => 4,
            Color::Custom(_) => 5,
        };
        res
    }
}


//# run 0xCAFE::NativeWithVisibility::call_native_functions --args 3u64 5u64


//# run 0xCAFE::UsingNativeWithVisibility::invoke_entry --args 7u64 11u64


//# run 0xCAFE::MatchWithIfGuard::match_with_guard --args 1u8 15u64


//# run 0xCAFE::MatchWithIfGuard::match_with_guard --args 2u8 5u64


//# run 0xCAFE::MatchWithIfGuard::match_with_guard --args 4u8 6u64


//# run 0xCAFE::MatchWithIfGuard::match_with_guard --args 4u8 7u64


// Featurres:
// 001ba520fbde6d873be51c98ab49419d: Define native functions with specific visibility and entry point attributes.
// 89c812ea94a0490e1a31d1e05b4e9dd2: Use the 'use' statement to import modules by their declared module names.
// d5a0a8baa349210b30e6d36b0e91eda3: Add an optional 'if' guard expression to a match arm for conditional matching.
