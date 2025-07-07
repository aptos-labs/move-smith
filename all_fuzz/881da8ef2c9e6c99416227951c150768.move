
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b;
        // Always return 42 after computing sum
        42
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let res = AddModule::inline_add(a, b);
        res
    }

    spec module {
        include 0xCAFE::AddModule;

        // Note: In Move Prover spec functions, you do not end functions with `;`
        // Also, functions in spec blocks must return a bool value for predicate functions.
        // Here the functions return bool expressions, so the return type should be `bool`

        fun add_and_return_fixed_spec(a: u8, b: u8): bool {
            AddModule::add_and_return_fixed(a, b) == 42
        }

        fun call_inline_add_spec(a: u8, b: u8): bool {
            call_inline_add(a, b) == (a + b)
        }
    }
}



//# run 0xCAFE::AddModule::add_and_return_fixed --args 10u8 15u8



//# run 0xCAFE::CallInline::call_inline_add --args 20u8 22u8
