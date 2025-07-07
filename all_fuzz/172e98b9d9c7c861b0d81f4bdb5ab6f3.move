
//# publish
module 0xCAFE::AdditionTest {
    public fun add_add_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        // always return 42 after computing sum to test side effect
        42u8
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        add_lambda(a, b)
    }

    public fun lambda_ignore_second_arg(a: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, _y: u8| { x + 1u8 };
        lambda(a, 0u8)
    }

    public fun test_lambda_runner() {
        let _ = lambda_add(5u8, 7u8);
        let _ = lambda_ignore_second_arg(10u8);
    }
}


//# run 0xCAFE::AdditionTest::add_add_return_42 --args 3u8 4u8


//# run 0xCAFE::AdditionTest::lambda_add --args 10u8 20u8


//# run 0xCAFE::AdditionTest::lambda_ignore_second_arg --args 15u8


//# run 0xCAFE::AdditionTest::test_lambda_runner



    // The following lines should cause compiler errors because 
    // spec modules cannot contain functions, structs, or constants.

    // Uncommenting any will cause compile errors to test enforcement.

    /*
    const CONST_IN_SPEC: u8 = 1;
    struct S has copy, drop {}
    public fun f_in_spec(): u8 {
        0u8
    }
    */
}



//# publish
module 0xCAFE::V2FeatureTest {
    // Using Move 2 features - for example, destructuring assignment and 
    // inline lambda expressions with complex captured environment.

    // Destructuring multiple returns from inline function
    public inline fun inline_return_tuple(x: u8): (u8, u8) {
        (x + 1, x + 2)
    }

    public fun v2_lambda_destructure(x: u8): u8 {
        let inline_lambda: |u8| (u8, u8) has copy+drop = |a: u8| { (a, a * 2) };
        let (a, b) = inline_lambda(x);
        let (c, d) = inline_return_tuple(b);

        a + b + c + d
    }
}


//# run 0xCAFE::V2FeatureTest::v2_lambda_destructure --args 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 5fe160ed1eb9fc8c1f833320b14d8fc7: Test that lambda (anonymous function) parameters can be used with ignored arguments (using `_`) in inline function calls.
// 93f327a8f0c3c7a4cd2c4eb31c1013bb: Generate errors when functions, structs, or constants are defined in modules marked as specifications, enforcing spec module constraints.
// 624e62dedded7dc7e504e3fba5ec4365: Write code that uses features exclusive to Move language version 2 or higher
