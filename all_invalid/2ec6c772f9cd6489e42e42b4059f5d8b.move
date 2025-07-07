
//# publish
module 0xCAFE::NestedClosures {
    use AptosStd::Debug;

    // A function returning a closure that returns another closure with explicit return types.
    public fun get_nested_lambda(): |u8| u8 {
        let inner_lambda: |u8| u8 has copy + drop = |x: u8| {
            x + 10
        };
        // Outer closure calls inner closure and returns result.
        let outer_lambda: |u8| u8 has copy + drop = |y: u8| {
            inner_lambda(y) + 5
        };
        outer_lambda
    }

    // A function returns multiple closures to test destructuring them.
    public fun get_two_lambdas(): (|u8| u8, |u8| u8) {
        let lambda1: |u8| u8 has copy + drop = |a: u8| { a + 1 };
        let lambda2: |u8| u8 has copy + drop = |b: u8| { b * 2 };
        (lambda1, lambda2)
    }

    // Use lambdas returned from other functions.
    public fun call_nested_lambda(input: u8): u8 {
        let f = get_nested_lambda();
        f(input)
    }

    public fun call_two_lambdas(input: u8): (u8, u8) {
        let (f1, f2) = get_two_lambdas();
        let r1 = f1(input);
        let r2 = f2(input);
        (r1, r2)
    }

    // A function with multiple attributes combined on it (demonstrate attribute flattening and uniqueness)
    // inline]
    // inline(always)]
    // test]
    public fun annotated_function(x: u8): u8 {
        x + 42
    }

    // Configure error reporting function that calls Debug::print and simulates an error writer.
    public fun error_reporter(msg: &vector<u8>) {
        Debug::print(msg);
    }
}



//# run 0xCAFE::NestedClosures::call_nested_lambda --args 3u8


//# run 0xCAFE::NestedClosures::call_two_lambdas --args 4u8


//# run 0xCAFE::NestedClosures::annotated_function --args 10u8


//# run 0xCAFE::NestedClosures::error_reporter --args x"4572726F7220737461747573207465737421"
