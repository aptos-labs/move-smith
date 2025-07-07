
//# publish
module 0xCAFE::AddAndLambda {
    // Module to test addition and lambdas

    // Simple struct to hold two u8 values
    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    // Function that adds two u8 values and returns their sum + 5
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 5
    }

    // Function with a lambda that multiplies by 2 and adds 3
    public fun lambda_double_add(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |v: u8| {
            v * 2 + 3
        };
        f(x)
    }

    // Runner function internally calls both above and returns their sum
    public fun runner(x: u8, y: u8): u8 {
        let a = add_and_offset(x, y);
        let b = lambda_double_add(x);
        a + b
    }
}



//# publish
module 0xCAFE::CallInline {
    // Instead of using non-existent MyModule, define the function f2 inline here 
    // or replace with a suitable function.

    // Here, we replicate a function f2 that returns a pair of u16 values given a u16 input.
    // This is a plausible dummy implementation to avoid errors.

    public fun f2(x: u16): (u16, u16) {
        // For example, split input x into two halves: upper and lower bytes
        let v1 = x / 2;
        let v2 = x - v1;
        (v1, v2)
    }

    use 0xCAFE::AddAndLambda;

    public fun test_call_inline(x: u16, a: u8, b: u8): u32 {
        let (v1, v2) = f2(x);
        let sum_ab = AddAndLambda::add_and_offset(a, b);
        (v1 as u32) + (v2 as u32) + (sum_ab as u32)
    }
}



//# run 0xCAFE::AddAndLambda::add_and_offset --args 10u8 15u8



//# run 0xCAFE::AddAndLambda::lambda_double_add --args 7u8



//# run 0xCAFE::AddAndLambda::runner --args 3u8 4u8



//# run 0xCAFE::CallInline::test_call_inline --args 20u16 5u8 10u8
