
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_and_return_constant(a: u8, b: u8): u8 {
        // Compute the sum but ignore it, return constant 42u8
        let _sum = a + b;
        42u8
    }

    public fun apply_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |n: u8| {
            n * 2
        };
        lambda(x)
    }

    public fun call_another_inline(a: u16): u16 {
        let (x, _y) = 0xCAFE::MyModule::f2(a);
        // x is a+1 as per f2, return x + 10u16
        x + 10u16
    }

    struct ComplexStruct<T1, T2> has store {
        first: T1,
        second: T2,
    }

    public fun create_complex_struct(): ComplexStruct<0xCAFE::MyModule::E, u8> {
        let enum_inst = 0xCAFE::MyModule::E::V3 { a: true };
        ComplexStruct<E, u8> { first: enum_inst, second: 255u8 }
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_constant --args 3u8 5u8


//# run 0xCAFE::LambdaTest::apply_lambda --args 21u8


//# run 0xCAFE::LambdaTest::call_another_inline --args 100u16


//# run 0xCAFE::LambdaTest::create_complex_struct


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 0e4cd145b3fbce7fdaf079c8eda0a79e: Construct complex types using Move's type system
