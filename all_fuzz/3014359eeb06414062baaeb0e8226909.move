
//# publish
module 0xCAFE::LambdaAndInline {

    // inline function f2 - replaces the missing MyModule::f2(a) function
    // returns tuple of (a, a+1) as example
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }

    // Function that adds two u8 values and returns x + y + 10
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    // Function that uses an anonymous function (lambda) to multiply x by itself and add y
    public fun lambda_mul_add(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * a + b
        };
        lambda(x, y)
    }

    // Function that calls the inline function f2 from this module and sums the tuple results
    public fun call_inline_and_sum(a: u16): u16 {
        let (x, y) = f2(a);
        x + y
    }

    // Runner function that calls all above functions without argument (uses constants)
    public fun runner(): u8 {
        let v1 = add_and_offset(7u8, 8u8);
        let v2 = lambda_mul_add(3u8, 4u8);
        let v3 = call_inline_and_sum(10u16);

        // sum all results, cast u16 v3 to u8 (safe because v3 = 10+11 =21 <256)
        let total = v1 + v2 + (v3 as u8);
        total
    }
}



//# run 0xCAFE::LambdaAndInline::add_and_offset --args 12u8 34u8



//# run 0xCAFE::LambdaAndInline::lambda_mul_add --args 5u8 3u8



//# run 0xCAFE::LambdaAndInline::call_inline_and_sum --args 15u16



//# run 0xCAFE::LambdaAndInline::runner
