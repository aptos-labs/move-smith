
//# publish
module 0xCAFE::LambdaAndInlineFunctions {

    /// A local function f1 to replace the missing MyModule::f1.
    /// Returns sum + 1 if the second argument is true, else returns sum.
    fun f1(x: u8, flag: bool): u8 {
        if (flag) {
            x + 1
        } else {
            x
        }
    }

    /// A local inline function f2 to replace the missing MyModule::f2.
    /// Returns a tuple (a, a + 1).
    inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }

    public fun add_and_return_sum_then_magic(a: u8, b: u8): u32 {
        let sum = a + b;

        // Use the local f1 function instead of missing MyModule::f1
        let value = f1(sum, true);

        // Compose a u32 result embedding the sum and value returned by f1
        let result: u32 = (sum as u32) * 100 + (value as u32);
        result
    }

    public fun with_lambda_expression(x: u8, y: u8): u8 {
        let sum_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let product_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let sum = sum_lambda(x, y);
        let product = product_lambda(x, y);

        // Return sum + product as u8 (safe since u8 max 255)
        sum + product
    }

    public fun call_inline_f2_and_add_one(a: u16): u16 {
        // Use local inline f2 instead of missing MyModule::f2
        let (v1, v2) = f2(a);
        v1 + v2 + 1
    }
}



//# run 0xCAFE::LambdaAndInlineFunctions::add_and_return_sum_then_magic --args 5u8 10u8



//# run 0xCAFE::LambdaAndInlineFunctions::with_lambda_expression --args 3u8 4u8



//# run 0xCAFE::LambdaAndInlineFunctions::call_inline_f2_and_add_one --args 7u16
