
//# publish
module 0xCAFE::MyModule {
    // Define the inline function f2 that returns a tuple (u16, u16) for testing nested calls
    // For example, returns (input + 1, input * 2)
    public inline fun f2(x: u16): (u16, u16) {
        (x + 1, x * 2)
    }
}

//# publish
module 0xCAFE::TestFeatures {
    // Removed unused vector import as it is not used
    // use std::vector;

    // 1. Test addition of two u8 values then return a specific value
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    // 2. Functions containing lambda expressions
    public fun lambda_test(x: u8): u8 {
        let add_one: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        let res = add_one(x);
        res
    }

    public fun lambda_capture_test(y: u8): u8 {
        let base = 5u8;
        let add_base: |u8|u8 has copy+drop = |a: u8| { a + base };
        add_base(y)
    }

    // 3. Call inline function from another module which returns a tuple, nest calls
    public fun nested_inline_calls(a: u16): u32 {
        // call MyModule::f2 inline function
        let (b, c) = 0xCAFE::MyModule::f2(a);
        let (d, e) = 0xCAFE::MyModule::f2(b);
        // return sum of all results
        (c as u32) + (d as u32) + (e as u32)
    }

    // 4. while loops with condition expressions and nested control
    public fun while_nested(x: u8): u8 {
        let val = x;
        while (val < 10) {
            if (val % 2 == 0) {
                val = val + 3;
            } else {
                val = val + 1;
            };
        };
        val
    }

    public fun while_nested_loop(x: u8): u8 {
        let val = x;
        while (val < 15) {
            loop {
                if (val % 3 == 0) {
                    val = val + 2;
                    break;
                };
                val = val + 1;
                if (val > 20) {
                    break;
                };
            };
            if (val > 20) {
                break;
            };
        };
        val
    }
}



//# run 0xCAFE::TestFeatures::add_then_return --args 5u8 4u8



//# run 0xCAFE::TestFeatures::add_then_return --args 8u8 7u8



//# run 0xCAFE::TestFeatures::lambda_test --args 10u8



//# run 0xCAFE::TestFeatures::lambda_capture_test --args 7u8



//# run 0xCAFE::TestFeatures::nested_inline_calls --args 5u16



//# run 0xCAFE::TestFeatures::while_nested --args 0u8



//# run 0xCAFE::TestFeatures::while_nested_loop --args 0u8
