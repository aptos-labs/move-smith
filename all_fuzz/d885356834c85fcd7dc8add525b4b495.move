
//# publish
module 0xCAFE::LambdaAndInline {

    public fun add_and_return(y: u8): u8 {
        let lambda_add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let sum = lambda_add(3u8, y);
        sum + 1u8
    }

    public fun lambda_caller(x: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let s = a + b;
            let m = a * b;
            (s, m)
        };
        lambda(x, 5u8)
    }

    // Implement the f2 function here to replace MyModule::f2
    public fun f2(a: u16): (u16, u16) {
        // Example logic for f2: return (a, a * 2)
        (a, a * 2)
    }

    public fun call_inline(a: u16): (u16, u16) {
        f2(a)
    }
}



//# run 0xCAFE::LambdaAndInline::add_and_return --args 7u8



//# run 0xCAFE::LambdaAndInline::lambda_caller --args 4u8



//# run 0xCAFE::LambdaAndInline::call_inline --args 10u16
