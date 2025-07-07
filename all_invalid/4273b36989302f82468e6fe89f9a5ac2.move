
//# publish
module 0xCAFE::TestFeatures {
    use std::signer;

    // Simple function that adds two u8 values and then returns a fixed value
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // fixed return value independent of sum, used for check
        42u8
    }

    // Function containing a lambda expression and returning the result of calling it
    public fun lambda_addition(a: u8, b: u8): u8 {
        let add: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add(a, b)
    }

    // Inline function returning tuple for nested call test
    public inline fun inline_sum_diff(x: u8, y: u8): (u8, u8) {
        (x + y, x - y)
    }

    // Function calling inline function inside a lambda and returning sum
    public fun call_inline_in_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |p, q| {
            let (sum, diff) = inline_sum_diff(p, q);
            sum + diff
        };
        lambda(a, b)
    }

    // Function that uses a loop with a conditional break returning a value
    public fun test_loop_return(x: u8): u8 {
        let count = 0u8;
        loop {
            if (count == x) {
                return count;
            };
            count = count + 1;
        };
        // 200u8 // unreachable, removed
    }

    // A function that returns 100 to test conditional branch execution
    public fun return_100_if_true(flag: bool): u8 {
        if (flag) {
            100u8
        } else {
            0u8
        }
    }
}



//# run 0xCAFE::TestFeatures::add_then_return_fixed --args 10u8 20u8



//# run 0xCAFE::TestFeatures::lambda_addition --args 12u8 30u8



//# run 0xCAFE::TestFeatures::call_inline_in_lambda --args 15u8 5u8



//# run 0xCAFE::TestFeatures::test_loop_return --args 5u8



//# run 0xCAFE::TestFeatures::return_100_if_true --args true
