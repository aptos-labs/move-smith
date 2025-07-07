
//# publish
module 0xCAFE::LambdaTest {
    // Test lambda expressions and addition functionality

    public fun add_two(x: u8, y: u8): u8 {
        x + y
    }

    public fun add_with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        lambda(x, y)
    }

    public fun add_nested_lambda(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| {
            let inner_lambda: |u8, u8| u8 has copy+drop = |x1: u8, y1: u8| { x1 + y1 };
            inner_lambda(a, b)
        };
        add(x, y)
    }

    public fun runner(): u8 {
        let r1 = add_two(4u8, 5u8);
        let r2 = add_with_lambda(3u8, 6u8);
        let r3 = add_nested_lambda(10u8, 20u8);
        r1 + r2 + r3
    }
}



// Define MyModule here since referencing it externally is not allowed.
// This module includes a function `f2` that returns a tuple (u16, u16).


//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}



//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::MyModule;

    // Call the inline function f2 in MyModule and unpack tuple results
    public fun call_my_module_f2(a: u16): u16 {
        let (x, y) = MyModule::f2(a);
        x + y
    }

    public fun runner(): u16 {
        call_my_module_f2(100u16)
    }
}




//# run 0xCAFE::LambdaTest::add_two --args 7u8 8u8



//# run 0xCAFE::LambdaTest::add_with_lambda --args 9u8 10u8



//# run 0xCAFE::LambdaTest::add_nested_lambda --args 11u8 12u8



//# run 0xCAFE::LambdaTest::runner



//# run 0xCAFE::InlineCallTest::call_my_module_f2 --args 50u16



//# run 0xCAFE::InlineCallTest::runner
