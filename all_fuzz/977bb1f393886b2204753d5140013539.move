
//# publish
module 0xCAFE::TestAddition {
    // Module to test addition and returning a specific value

    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 10 to verify addition before returning
        sum + 10
    }

    public fun runner() {
        let _result = add_then_return(5u8, 7u8);
    }
}



//# run 0xCAFE::TestAddition::add_then_return --args 5u8 7u8



//# run 0xCAFE::TestAddition::runner



//# publish
module 0xCAFE::TestLambda {
    // Module to test lambda expressions

    public fun apply_lambda(x: u8, y: u8): u8 {
        let sum_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        sum_lambda(x, y)
    }

    public fun nested_lambda(x: u8): u8 {
        let mul_lambda: |u8|u8 has copy+drop = |a: u8| {
            // anonymous function inside another lambda
            let inner_lambda: |u8|u8 has copy+drop = |b: u8| {
                b * 2
            };
            inner_lambda(a) + 3
        };
        mul_lambda(x)
    }

    public fun runner() {
        let _ = apply_lambda(3u8, 4u8);
        let _ = nested_lambda(5u8);
    }
}



//# run 0xCAFE::TestLambda::apply_lambda --args 3u8 4u8



//# run 0xCAFE::TestLambda::nested_lambda --args 5u8



//# run 0xCAFE::TestLambda::runner



//# publish
module 0xCAFE::MyModule {
    // The missing MyModule with function f2, which returns a tuple (u16, u16)
    // as required by TestNestedInline

    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}



//# publish
module 0xCAFE::TestNestedInline {
    // Module to test calling inline function from one module within another module

    // Remove unused 'use TestAddition' to fix warning
    // use 0xCAFE::TestAddition;

    // Inline function that calls inline function f2 in MyModule indirectly

    public fun call_inline_add(x: u16, y: u16): u16 {
        // Use MyModule::f2 to get a tuple then add y
        let (a, b) = 0xCAFE::MyModule::f2(x);
        a + b + y
    }

    public fun runner() {
        let _ = call_inline_add(10u16, 20u16);
    }
}



//# run 0xCAFE::TestNestedInline::call_inline_add --args 10u16 20u16



//# run 0xCAFE::TestNestedInline::runner
