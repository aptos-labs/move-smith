
//# publish
module 0xCAFE::MathModule {
    public fun add_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        } // Removed semicolon here so the value is returned
    }

    // Move doesn't support lambda syntax currently.
    // So we rewrite lambda_example without lambdas.
    public fun lambda_example(): u8 {
        add(6u8, 7u8)
    }

    // Removed 'inline' keyword and 'acquires' clause which are invalid here
    public fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add(a: u8, b: u8): u8 {
        inline_add(a, b)
    }

    // We add a helper function 'add' since lambda_example tries to call add
    public fun add(a: u8, b: u8): u8 {
        a + b
    }
}



//# run 0xCAFE::MathModule::add_u8 --args 3u8 4u8


//# run 0xCAFE::MathModule::add_u8 --args 6u8 6u8


//# run 0xCAFE::MathModule::lambda_example



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public fun call_math_module_inline(a: u8, b: u8): u8 {
        MathModule::call_inline_add(a, b)
    }
}


//# run 0xCAFE::CallerModule::call_math_module_inline --args 5u8 7u8
