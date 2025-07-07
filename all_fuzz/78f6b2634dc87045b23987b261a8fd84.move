
//# publish
module 0xCAFE::AddAndLambda {
    // Test that Move function correctly computes addition of two u8 values and returns a specific value.

    public fun add_then_return_special_value(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return 42 if sum is greater than 40 else return sum
        if (sum > 40) {
            42
        } else {
            sum
        }
    }

    // Function containing a lambda that doubles its argument and applies it to input.
    public fun lambda_double(x: u8): u8 {
        let double: |u8|u8 has copy+drop = |n: u8| { n + n };
        double(x)
    }

    // Function containing two lambdas and composing them.
    public fun lambda_compose(x: u8): u8 {
        let inc: |u8|u8 has copy+drop = |n: u8| { n + 1 };
        let square: |u8|u8 has copy+drop = |n: u8| { n * n };
        let y = inc(x);
        square(y)
    }
}



//# run 0xCAFE::AddAndLambda::add_then_return_special_value --args 20u8 25u8



//# run 0xCAFE::AddAndLambda::add_then_return_special_value --args 10u8 12u8



//# run 0xCAFE::AddAndLambda::lambda_double --args 6u8



//# run 0xCAFE::AddAndLambda::lambda_compose --args 3u8



//# publish
module 0xCAFE::NestedCaller {
    // We can't use 0xCAFE::MyModule or 0xCAFE::StorageUsage or other example modules,
    // so we define inline helper functions here to simulate MyModule::f1 and MyModule::f2

    // Inlined function simulating MyModule::f2: splits u16 into two u8 parts.
    public fun f2(x: u16): (u8, u8) {
        let a: u8 = (x & 0xFF) as u8;
        let b: u8 = ((x >> 8) & 0xFF) as u8;
        (a, b)
    }

    // Inlined function simulating MyModule::f1: returns x or x+1 based on flag.
    public fun f1(x: u8, flag: bool): u8 {
        if (flag) {
            x + 1
        } else {
            x
        }
    }

    // To call AddAndLambda functions, we need to "use" them within this module.
    use 0xCAFE::AddAndLambda;

    // Call an inline function f2 nested inside a function that adds its first element.
    // Then call add_then_return_special_value from AddAndLambda with computed sum and a provided u8.
    public fun nested_call(x: u16, extra: u8): u8 {
        let (a, b) = Self::f2(x);
        let sum_u8 = (a + b) as u8;
        let added = AddAndLambda::add_then_return_special_value(sum_u8, extra);
        added
    }

    // Call lambda_double from AddAndLambda passing a value computed from inline f1.
    public fun call_lambda_double(x: u8, flag: bool): u8 {
        let f1_res = Self::f1(x, flag);
        AddAndLambda::lambda_double(f1_res)
    }
}



//# run 0xCAFE::NestedCaller::nested_call --args 20u16 10u8



//# run 0xCAFE::NestedCaller::call_lambda_double --args 8u8 false
