
//# publish
module 0xCAFE::AbilitiesAndFunctions {
    use std::signer;

    // 1. Declare struct or resource abilities using the 'has' keyword followed by a comma-separated list of abilities
    struct ResourceWithAbilities has key, store, drop {
        a: u64,
        b: u8,
    }

    struct CopyDropStoreStruct has copy, drop, store {
        val: u32,
    }

    struct CopyOnlyStruct has copy {
        val: bool,
    }

    struct StoreOnlyStruct has store {
        val: vector<u8>,
    }

    /// Function types that take arguments: 
    /// Here we demonstrate filtering via function usage and calling only functions with multiple args

    public fun function_with_no_args(): u8 {
        42u8
    }

    public fun function_with_one_arg(x: u8): u8 {
        x + 1
    }

    public fun function_with_two_args(a: u8, b: u64): u64 {
        let sum = (a as u64) + b;
        sum
    }

    public fun function_with_three_args(a: u8, b: u64, c: bool): u64 {
        let add = (a as u64) + b;
        if (c) {
            add + 1
        } else {
            add
        };
    }

    public fun filter_and_call_funcs() {
        // We cannot literally filter types in Move, 
        // but we illustrate that only function types with multiple args are called here
        let res1 = function_with_two_args(3u8, 10u64);
        let res2 = function_with_three_args(2u8, 5u64, true);
        let _res3 = function_with_three_args(2u8, 5u64, false);
        let _res4 = function_with_one_arg(5u8);

        // Only res1, res2 and _res3 are functions with multiple args actually executed here
        // res4 is called but with only one argument

        // no return value needed
    }

    // 3. Functions with multiple arguments of different types can be called and evaluated correctly

    public fun multi_type_args(s: signer, flag: bool, count: u64, code: u8) : u64 {
        let addr = signer::address_of(&s);
        let base = count + (code as u64);
        if (flag) {
            base + 1u64
        } else {
            base
        };
    }

    public fun runner() {
        function_with_no_args();
        function_with_one_arg(10u8);
        function_with_two_args(7u8, 8u64);
        function_with_three_args(1u8, 2u64, true);
        filter_and_call_funcs();
    }
}


//# run 0xCAFE::AbilitiesAndFunctions::runner


//# run 0xCAFE::AbilitiesAndFunctions::multi_type_args --signers 0xBEEF --args true 999u64 255u8


// Featurres:
// c5a306a2c2b0597752c1920c84745b1c: Declare struct or resource abilities using the 'has' keyword followed by a comma-separated list of abilities in your Move module or script.
// ebf5db0acc3e2719405d4f628f579c1d: Filter a list of types to include only function types with function arguments.
// fbecde6e0ef8ff1643ebca3b4f63890f: Test that functions with multiple arguments of different types can be called and evaluated correctly.
