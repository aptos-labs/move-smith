
//# publish
module 0xCAFE::AdditionTest {
    // Test adding two u8 values and returning a specific value
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;

        let unused_var = 999u64; // unused variable to test detection

        // Unused parameter to test detection: b

        sum + 1
    }

    // Function containing lambda expressions
    public fun lambda_test(): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        let multiplier: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x * y };

        let added = adder(5u8, 7u8);
        let multiplied = multiplier(3u8, 4u8);
        added + multiplied
    }

    public fun unused_params_example(_unused_param: u8, used_param: u8): u8 {
        used_param + 10
    }
}




//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AdditionTest;

    // Inline function in this module
    public inline fun inline_fun(x: u8): u8 {
        x * 2
    }

    // Call to inline function of AdditionTest and nested calls
    public fun nested_calls(x: u8, y: u8): u8 {
        let added = AdditionTest::add_and_return_special(x, y);
        let doubled = inline_fun(added);
        doubled + 5
    }
}




//# run
script {
    use 0xCAFE::AdditionTest;
    use 0xCAFE::InlineCaller;

    fun main() {
        // Test addition function
        let res1 = AdditionTest::add_and_return_special(10u8, 20u8);
        // call lambda function
        let res2 = AdditionTest::lambda_test();
        // test inline caller nested calls
        let res3 = InlineCaller::nested_calls(2u8, 3u8);

        // test unused params identified by compiler by ignoring _unused_param
        let res4 = AdditionTest::unused_params_example(1u8, 9u8);
    }
}
