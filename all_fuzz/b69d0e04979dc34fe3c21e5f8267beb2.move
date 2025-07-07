
//# publish
module 0xCAFE::FriendModule {
    /// Empty module to declare friend relationship
    /// Needs to be declared before LambdaTest for friendship to be recognized
}



//# publish
module 0xCAFE::LambdaTest {
    /// Declares a struct to test friend visibility
    struct FriendStruct has copy, drop, store {}

    friend 0xCAFE::FriendModule;

    /// Function with lambdas that captures environment and returns result
    public fun use_lambda(x: u8): u8 {
        let add_one: |u8|u8 has copy + drop = |a: u8| {
            a + 1
        };
        let mul_two: |u8|u8 has copy + drop = |b: u8| {
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

    // caller does NOT declare friend of LambdaTest because LambdaTest does not use CallerModule
    // removed "friend 0xCAFE::LambdaTest;" to avoid cyclic dependency error

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



// Expanded FriendModule with the function preserved, placed AFTER LambdaTest for compilation order


//# publish
module 0xCAFE::FriendModule {
    use 0xCAFE::LambdaTest;

    public fun create_and_check_friend(_s: &signer): bool {
        let _fs = LambdaTest::FriendStruct {};
        // Access to FriendStruct is allowed due to friendship
        true
    }
}
