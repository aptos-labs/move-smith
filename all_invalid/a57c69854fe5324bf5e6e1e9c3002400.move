
//# publish
module 0xCAFE::InliningTest {
    use std::vector;

    // Define flags for function inlining behavior controlled via compiler or feature flags.
    // For test purposes, we simulate this via different functions and toggles.
    // We assume functions may be inlined or lifted based on compile-time flags.

    // Functions with inline attribute (simulated via naming)
    public fun inline_func(): u8 {
        42
    }

    // Functions marked as lifted (simulated as not inline)
    public fun lifted_func(): u8 {
        99
    }

    // Function that calls inline functions directly and via function pointers
    public fun call_inline_functions(): (u8, u8, u8, u8) {
        let result_direct_inline = inline_func();
        let result_direct_lifted = lifted_func();

        let fp_inline: fun() -> u8 = inline_func;
        let fp_lifted: fun() -> u8 = lifted_func;

        let result_fp_inline = fp_inline();
        let result_fp_lifted = fp_lifted();

        (result_direct_inline, result_direct_lifted, result_fp_inline, result_fp_lifted)
    }

    // Expected failure: assigned function pointer with incompatible signature
    // expected_failure]
    public fun assign_wrong_function_pointer() {
        // This should fail if function signature mismatch or invalid assignment
        let wrong_fp: fun() -> u32 = inline_func; // Error: return type mismatch
        let _ = wrong_fp();
    }

    // Struct with function pointer field
    struct FuncHolder has copy, drop {
        func: fun() -> u8,
    }

    public fun create_holder_with_inline(): FuncHolder {
        let holder = FuncHolder {func: inline_func};
        holder
    }

    public fun create_holder_with_lifted(): FuncHolder {
        let holder = FuncHolder {func: lifted_func};
        holder
    }

    // Call the function stored in the struct
    public fun call_struct_func(holder: &FuncHolder): u8 {
        (holder.func)()
    }

    // Enum with function pointer field
    enum FuncEnum has copy, drop {
        InlineVariant { func: fun() -> u8 },
        LiftedVariant { func: fun() -> u8 },
    }

    public fun dummy_enum() {
        let inline_variant = FuncEnum::InlineVariant { func: inline_func };
        let lifted_variant = FuncEnum::LiftedVariant { func: lifted_func };
        // Call functions via enum
        match inline_variant {
            FuncEnum::InlineVariant { func } => {
                let _ = func();
            },
            _ => {},
        };
        match lifted_variant {
            FuncEnum::LiftedVariant { func } => {
                let _ = func();
            },
            _ => {},
        };
    }

    // Struct with a closure (function pointer) field
    struct ClosureStruct has copy, drop {
        closure: fun(u8) -> u8,
    }

    public fun make_closure_double(): ClosureStruct {
        let closure = |x: u8| { x * 2 };
        let s = ClosureStruct {closure};
        s
    }

    public fun call_closure(s: &ClosureStruct, value: u8): u8 {
        (s.closure)(value)
    }
}


//# run 0xCAFE::InliningTest::call_inline_functions --args

//# run 0xCAFE::InliningTest::assign_wrong_function_pointer

//# run 0xCAFE::InliningTest::create_holder_with_inline

//# run 0xCAFE::InliningTest::create_holder_with_lifted

//# run 0xCAFE::InliningTest::call_struct_func --signers 0xCAFE --args

//# run 0xCAFE::InliningTest::dummy_enum

//# run 0xCAFE::InliningTest::make_closure_double

//# run 0xCAFE::InliningTest::call_closure --args 10u8


// Featurres:
// 296137f73b01ca107f2e516f6e55c58b: Use function inlining and control whether to keep or lift inline functions
// 102340960f7b8935d785196f3be8d626: Annotate test functions with #[expected_failure] to indicate tests expected to fail.
// 42960b7e2c8fb6648fd946d72d3a6450: Test that the Move module correctly defines and uses function pointer types (closures) within structs and enums, and that calling these function pointers produces the expected results.
