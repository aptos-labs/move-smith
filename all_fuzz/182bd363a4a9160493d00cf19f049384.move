
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value if sum is over 200 as an example
        if (sum > 200) {
            42u8
        } else {
            sum
        }
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let my_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        my_lambda(a, b)
    }
}



//# run 0xCAFE::AddModule::add_two_values --args 100u8 101u8



//# run 0xCAFE::AddModule::add_with_lambda --args 7u8 8u8



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public inline fun inline_add(a: u16): (u16, u16) {
        // Call AddModule::add_two_values and use its u8 result in calculation
        let sum_u8 = AddModule::add_two_values(10u8, 20u8);
        // Use AddModule inline function from MyModule indirectly, re-implement inline f2 locally to test 
        // Because we can't directly call MyModule::f2 (not imported), we implement a similar inline function here
        (a + (sum_u8 as u16), a + 5u16)
    }

    public fun nested_calls(a: u16): u16 {
        let (res1, _res2) = inline_add(a);
        res1
    }
}



//# run 0xCAFE::NestedCallModule::nested_calls --args 50u16
