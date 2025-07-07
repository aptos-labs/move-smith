
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;

        // If sum equals 42, return 100, otherwise return sum
        if (sum == 42) {
            100
        } else {
            sum
        }
    }
}



//# run 0xCAFE::TestAdd::add_and_check --args 20u8 22u8



//# run 0xCAFE::TestAdd::add_and_check --args 10u8 5u8



//# publish
module 0xCAFE::LambdaTest {
    public fun run_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = add_lambda(a, b);

        // Return result + 1
        result + 1
    }
}



//# run 0xCAFE::LambdaTest::run_lambda --args 15u8 20u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::TestAdd;

    // Calls the inline function inside TestAdd module indirectly
    public inline fun get_inline_sum(a: u16): (u16, u16) {
        // Reuse inline function f2 from TestAdd, but TestAdd has no f2, so create our own here
        (a + 1, a + 2)
    }

    public fun nested_call(a: u8, b: u8, c: u16): u8 {
        // Call add_and_check from TestAdd module
        let sum_result = TestAdd::add_and_check(a, b);

        // Call get_inline_sum inline function defined here
        let (_x, y) = get_inline_sum(c);

        // Return sum_result as u16 plus y as u16 cast back to u8
        ((sum_result as u16) + y) as u8
    }
}



//# run 0xCAFE::NestedCall::nested_call --args 10u8 15u8 20u16
