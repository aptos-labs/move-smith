
//# publish
module 0xCAFE::AddModule {
    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun runner() {
        let _ = add_two_numbers(5u8, 6u8);
        let _ = with_lambda(7u8, 8u8);
    }
}



//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::AddModule;

    public fun double_add(x: u8): u8 {
        let first = AddModule::add_two_numbers(x, 1u8);
        let second = AddModule::add_two_numbers(first, 2u8);
        second
    }

    public fun run_inline() {
        let _ = double_add(3u8);
    }
}



//# run 0xCAFE::AddModule::add_two_numbers --args 12u8 23u8



//# run 0xCAFE::AddModule::with_lambda --args 10u8 15u8



//# run 0xCAFE::AddModule::runner



//# run 0xCAFE::InlineCallModule::double_add --args 4u8



//# run 0xCAFE::InlineCallModule::run_inline
