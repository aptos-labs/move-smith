
//# publish
module 0xCAFE::ComputeModule {
    // This module provides basic computation and lambda usage.

    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_return_42(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        // If the sum is computed correctly, function returns 42.
        42u8
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b + x
        };
        lambda(x, y)
    }

    // Runner function for nested call test.
    public fun nested_call_runner(x: u8, y: u8): u8 {
        // Call add_u8 and apply_lambda to produce a value
        let add_result = add_u8(x, y); // sum
        let lambda_result = apply_lambda(x, y);
        add_result + lambda_result
    }
}



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::ComputeModule;

    public fun nested_invoke(x: u8, y: u8): u8 {
        // call ComputeModule::nested_call_runner and add 10
        let val = ComputeModule::nested_call_runner(x, y);
        val + 10u8
    }
}



//# run
script {
    use std::debug;

    fun main() {
        // Test add_and_return_42 returns 42 after adding 5 and 10
        let res1 = 0xCAFE::ComputeModule::add_and_return_42(5u8, 10u8);
        debug::print(&b"Test add_and_return_42 result: ");
        debug::print(&std::string::utf8(res1));

        // Test lambda applying addition
        let lambda_res = 0xCAFE::ComputeModule::apply_lambda(3u8, 4u8);
        debug::print(&b"Test apply_lambda result: ");
        debug::print(&std::string::utf8(lambda_res));

        // Test nested call returns expected value: add_u8(2,3) + apply_lambda(2,3) + 10
        let nested_val = 0xCAFE::NestedCallModule::nested_invoke(2u8, 3u8);
        debug::print(&b"Test nested_invoke result: ");
        debug::print(&std::string::utf8(nested_val));
    }
}
