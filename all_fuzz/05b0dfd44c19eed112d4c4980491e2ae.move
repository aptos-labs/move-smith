
//# publish
module 0xCAFE::FriendModule {
    // FriendModule must be published *before* LambdaTest to be a recognized friend
    // No code needed here for this example other than definition
}


//# publish
module 0xCAFE::LambdaTest {
    /// Declares a struct to test friend visibility
    struct FriendStruct has copy, drop, store {}

    friend 0xCAFE::FriendModule;

    /// Function with lambdas that captures environment and returns result
    public fun use_lambda(x: u8): u8 {
        let add_one: |u8|u8 has copy+drop = |a: u8| {
            a + 1
        };
        let mul_two: |u8|u8 has copy+drop = |b: u8| {
            b * 2
        };
        let intermediate = add_one(x);
        let result = mul_two(intermediate);
        result
    }

    /// Inline function returning tuple
    public inline fun inline_adder(a: u64): (u64, u64) {
        (a + 10, a + 20)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaTest;

    friend 0xCAFE::LambdaTest;

    /// Call the inline function from LambdaTest and return the sum of tuple elements
    public fun call_inline(a: u64): u64 {
        let (x, y) = LambdaTest::inline_adder(a);
        x + y
    }

    /// Call LambdaTest's lambda function with input and return output
    public fun call_lambda(x: u8): u8 {
        LambdaTest::use_lambda(x)
    }
}



//# run 0xCAFE::LambdaTest::use_lambda --args 5u8



//# run 0xCAFE::CallerModule::call_inline --args 100u64



//# run 0xCAFE::CallerModule::call_lambda --args 7u8



//# run 0xCAFE::FriendModule::create_and_check_friend --signers 0xBEEF


// Expanded FriendModule with the function preserved, placed after LambdaTest for compilation order

//# publish
module 0xCAFE::FriendModule {
    use std::signer;
    use 0xCAFE::LambdaTest;

    public fun create_and_check_friend(_s: signer): bool {
        let fs = LambdaTest::FriendStruct {};
        // Normally can only access FriendStruct here because friend
        true
    }
}
