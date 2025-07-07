
//# publish
module 0xCAFE::LambdaModule {
    // Module to test lambdas and inline function calls with generics

    struct Wrapper<T> {
        value: T
    }

    public inline fun plus_one(x: u64): u64 {
        x + 1
    }

    public fun call_lambda_twice(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |n: u8| { n + 2 };
        let first_result = lambda(x);
        let second_result = lambda(first_result);
        second_result
    }

    public fun call_inline_on_generic<T: copy>(input: T): T {
        let w = Wrapper<T> { value: input };
        w.value
    }

    public fun call_plus_one_from_other_module(x: u64): u64 {
        0xCAFE::InlineCaller::call_plus_one(x)
    }
}


//# run 0xCAFE::LambdaModule::call_lambda_twice --args 10u8


//# run 0xCAFE::LambdaModule::call_inline_on_generic --args 20u64


//# run 0xCAFE::LambdaModule::call_plus_one_from_other_module --args 100u64


//# publish
module 0xCAFE::InlineCaller {
    public inline fun call_plus_one(x: u64): u64 {
        let result = 0xCAFE::LambdaModule::plus_one(x);
        result
    }
}


//# run 0xCAFE::InlineCaller::call_plus_one --args 99u64


//# publish
module 0xCAFE::DisassemblerTest {
    use std::vector;

    public fun disassemble_example() {
        // preparing bytecode for disassembling
        // In Move testing framework, actual disassembly command isn't Move code.
        // This is a placeholder usage to force compile for disassembly.
        let _vec: vector<u8> = vector::empty<u8>();
        vector::push_back(&_vec, 42u8);
    }
}


//# run 0xCAFE::DisassemblerTest::disassemble_example


// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// fa09991c70ad2489dd408fee816518bc: Use type parameters in the types of struct fields.
// d6c49a6fc41110137abb89dae66a9144: Disassemble compiled Move units into human-readable code
