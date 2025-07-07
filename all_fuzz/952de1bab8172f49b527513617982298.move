
//# publish
module 0xCAFE::AddModule {
    public fun add_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 42) {
            42
        } else {
            sum
        }
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let plus = |a: u8, b: u8| {
            a + b
        };
        plus(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun runner() {
        let a = add_u8(20, 22);
        let b = with_lambda(13, 29);
        let c = inline_add(7, 8);
        let (_a, _b, _c) = (a, b, c);
        // values are intentionally ignored but assigned per guidelines
    }
}


//# publish
module 0xCAFE::NestedAddModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add_from_other_module(a: u8, b: u8): u8 {
        AddModule::inline_add(a, b)
    }

    public fun runner() {
        let _result = call_inline_add_from_other_module(15, 27);
    }
}


//# run 0xCAFE::AddModule::add_u8 --args 20u8 22u8


//# run 0xCAFE::AddModule::with_lambda --args 13u8 29u8


//# run 0xCAFE::AddModule::runner


//# run 0xCAFE::NestedAddModule::call_inline_add_from_other_module --args 15u8 27u8


//# run 0xCAFE::NestedAddModule::runner
