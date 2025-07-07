
//# publish
module 0xCAFE::LambdaTesting {
    public fun add_and_transform(a: u8, b: u8): u8 {
        let sum = a + b;

        let transformer: |u8| u8 has copy + drop = |x: u8| {
            if (x > 10) {
                x - 10
            } else {
                x + 10
            }
        };
        transformer(sum)
    }

    public fun run_lambda_expr() {
        let add_lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let _r = add_lambda(8u8, 7u8);

        let conditional_lambda: |u8| bool has copy + drop = |v: u8| {
            if (v % 2 == 0) {
                true
            } else {
                false
            }
        };
        let _flag = conditional_lambda(3u8);
    }
}



//# run 0xCAFE::LambdaTesting::add_and_transform --args 4u8 9u8



//# run 0xCAFE::LambdaTesting::run_lambda_expr



//# publish
module 0xCAFE::CrossModuleCall {

    // Define the called function inline here, since referencing external module is disallowed.
    public fun f2(x: u16): (u16, u16) {
        // Just split x into two values, e.g., (x, x * 2)
        (x, x * 2)
    }

    public fun call_inline_function(x: u16): (u16, u16) {
        f2(x)
    }

    public fun nested_call(x: u16): u32 {
        let (a, b) = call_inline_function(x);
        // return sum of tuple components as u32
        (a + b) as u32
    }
}



//# run 0xCAFE::CrossModuleCall::call_inline_function --args 20u16



//# run 0xCAFE::CrossModuleCall::nested_call --args 30u16
