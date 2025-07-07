
//# publish
module 0xCAFE::FeatureTest {
    use std::signer;
    use std::vector;
    use std::string;

    struct Singleton has key, store {
        field1: u8,
        field2: u8,
        field3: u8,
    }

    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let _sum = x + y;
        // Returns a fixed u8 value independent of sum
        42u8
    }

    public fun lambda_usage_example(x: u8, y: u8): (u8, u8) {
        let adder: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let prod = a * b;
            (sum, prod)
        };
        adder(x, y)
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }

    public fun nested_inline_call(a: u8, b: u8): u8 {
        inline_adder(a, b)
    }

    const MODULE_ADDRESS: address = @0xCAFE;

    public fun access_only_here() {
        // Try to call access_error indicating an unauthorized module access
        let loc = string::utf8(b"0xCAFE::FeatureTest");
        let ctx = string::utf8(b"Unauthorized access to internal data");
        abort 1000; // Simulate an access error abort
        // Note: In Move std, access_error is not a public function.
        // So simulate abort with known code and message here.
    }

    public fun fall_through_example(x: u8): u8 {
        if (x == 0) {
            1u8
        } else if (x == 1) {
            2u8
        } else {
            3u8
        };
        // Fall-through to this return no matter what
        99u8
    }

    public fun create_singleton(s: signer, f1: u8, f2: u8, f3: u8) {
        let single = Singleton { field1: f1, field2: f2, field3: f3 };
        move_to<Singleton>(&s, single);
    }

    public fun get_singleton_fields(s: signer): (u8, u8, u8) {
        let single_ref = borrow_global<Singleton>(signer::address_of(&s));
        (single_ref.field1, single_ref.field2, single_ref.field3)
    }

    public fun iterate_and_sum_fields(s: signer): u8 {
        let single_ref = borrow_global<Singleton>(signer::address_of(&s));
        let fields = vector[ single_ref.field1, single_ref.field2, single_ref.field3 ];
        let sum = 0u8;
        let len = vector::length(&fields);
        let i = 0;
        while (i < len) {
            let val_ref = vector::borrow(&fields, i);
            sum = sum + *val_ref;
            i = i + 1;
        };
        sum
    }
}


//# run 0xCAFE::FeatureTest::add_and_return_fixed --args 10u8 32u8


//# run 0xCAFE::FeatureTest::lambda_usage_example --args 7u8 3u8


//# run 0xCAFE::FeatureTest::nested_inline_call --args 20u8 22u8


//# run 0xCAFE::FeatureTest::fall_through_example --args 0u8


//# run 0xCAFE::FeatureTest::fall_through_example --args 1u8


//# run 0xCAFE::FeatureTest::fall_through_example --args 5u8


//# run 0xCAFE::FeatureTest::create_singleton --signers 0xBEEF --args 5u8 10u8 15u8


//# run 0xCAFE::FeatureTest::get_singleton_fields --signers 0xBEEF


//# run 0xCAFE::FeatureTest::iterate_and_sum_fields --signers 0xBEEF


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 5a9eeb2526a25b17285009271b7ae4d8: Invoke `access_error` to enforce that certain operations are only performed within the defining module of the code, providing location and context information in the error message.
// b294e957fc393c15df7c6577a8bbcc6c: Implement fall-through control flow by allowing execution to continue to subsequent instructions without a jump.
// 1d7edf1820fc309d35fa070ea5d7c5cb: Access and iterate over the fields of a singleton struct layout.
