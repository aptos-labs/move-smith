
//# publish
module 0xCAFE::AddU8 {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }
}


//# run 0xCAFE::AddU8::add_and_return --args 5u8 6u8


//# publish
module 0xCAFE::LambdaExample {
    public fun run_lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        let z = lambda(x, y);

        let lambda2: |u8| u8 has copy + drop = |v: u8| {
            v * 2
        };
        let doubled = lambda2(z);

        doubled
    }
}


//# run 0xCAFE::LambdaExample::run_lambda_example --args 3u8 4u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddU8;

    public fun call_inline_addition(x: u8, y: u8): u8 {
        AddU8::add_and_return(x, y)
    }
}


//# run 0xCAFE::InlineCaller::call_inline_addition --args 7u8 8u8


//# publish
module 0xCAFE::ReservedKeywordFun {
    public fun for(x: u8): u8 {
        x + 10
    }
}


//# run 0xCAFE::ReservedKeywordFun::for --args 5u8


//# publish
module 0xCAFE::NonNativeFunctions {
    public fun non_native_function_1(x: u8): u8 {
        x + 1
    }

    public fun non_native_function_2(): u8 {
        100u8
    }
}


//# run 0xCAFE::NonNativeFunctions::non_native_function_1 --args 9u8


//# run 0xCAFE::NonNativeFunctions::non_native_function_2


//# publish
module 0xCAFE::UnpackTest {
    struct Container has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct Wrapper has copy, drop, store {
        inner: Container
    }

    public fun unpack_structs() {
        let container = Container { a: 5u8, b: 6u8 };
        let Container { a: x, b: y } = container;

        let wrapper = Wrapper { inner: container };
        let Wrapper { inner: Container { a: a1, b: b1 } } = wrapper;
    }
}


//# run 0xCAFE::UnpackTest::unpack_structs


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 36c0747efc0d381d827c603922045c9c: Test that functions can be named using reserved keywords such as 'for' without causing parsing or compilation errors.
// 6b96d6915bf62b0b7ab660278c334d1e: Write non-native functions within target modules that will be checked by the compiler.
// f2ddebe7ab5d5fec40a8fffc3a2b297b: Process positional unpacking of struct fields in Move code, including nested unpacking of variable references.
