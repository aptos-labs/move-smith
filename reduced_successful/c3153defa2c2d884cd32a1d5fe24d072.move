
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;
    use std::vector;

    struct R has key, store {
        val: u8
    }

    /// LambdaTest has friend property, just for test purpose
    // friend]
    struct FriendStruct has key, store {
        dummy: u8
    }

    // Testing abilities specification with colon-separated list and plus-separated list
    struct CpdStruct has copy, drop, store {
        a: u8
    }

    // Simple function returning addition of two u8 values then adds 5u8 and returns
    public fun add_then_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 5u8;
        result
    }

    // Function using lambda expressions (anonymous functions)
    public fun lambda_usage(x: u8): u8 {
        let add_two: |u8| u8 has copy + drop = |a: u8| { a + 2 };
        let mul_three: |u8| u8 has copy + drop = |a: u8| { a * 3 };
        let res_add = add_two(x);
        let res_mul = mul_three(x);
        res_add + res_mul
    }

    // Inline function to test cross-module inline call and nested calls
    public inline fun inline_double(val: u8): u8 {
        val * 2
    }

    // Function to publish resource R to the signer's address
    public fun publish_resource(s: &signer, val: u8) {
        let r = R { val };
        move_to<R>(s, r);
    }

    // Inline function returning a reference to a global resource
    public inline fun borrow_global_r(addr: address): &R {
        borrow_global<R>(addr)
    }

    // Function to test referencing borrowed resource and reading from it
    public fun read_resource(s: &signer): u8 {
        let r_ref = borrow_global_r(signer::address_of(s));
        r_ref.val
    }
}



//# publish
module 0xCAFE::Caller {
    use std::signer;
    use 0xCAFE::LambdaTest;

    // Calls inline function in LambdaTest, doubles input then adds 3
    public fun call_inline_double(a: u8): u8 {
        let doubled = LambdaTest::inline_double(a);
        doubled + 3u8
    }

    // Calls LambdaTest::add_then_offset to check nested call returns
    public fun call_add_then_offset(a: u8, b: u8): u8 {
        LambdaTest::add_then_offset(a, b)
    }

    // Calls LambdaTest::lambda_usage with some u8
    public fun call_lambda_usage(x: u8): u8 {
        LambdaTest::lambda_usage(x)
    }

    // Calls functions that publish and read from resource R via LambdaTest
    public fun publish_and_read_resource(s: &signer, value: u8): u8 {
        LambdaTest::publish_resource(s, value);
        LambdaTest::read_resource(s)
    }
}



//# run 0xCAFE::LambdaTest::add_then_offset --args 10u8 20u8



//# run 0xCAFE::LambdaTest::lambda_usage --args 4u8



//# run 0xCAFE::Caller::call_inline_double --args 7u8



//# run 0xCAFE::Caller::call_add_then_offset --args 11u8 22u8



//# run 0xCAFE::Caller::call_lambda_usage --args 5u8



//# run 0xCAFE::Caller::publish_and_read_resource --signers 0xABCD --args 55u8
