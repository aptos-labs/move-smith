
//# publish
module 0xCAFE::CalcModule {
    use std::signer;

    const ConstVal: u8 = 42;

    struct Data has copy, drop, store {
        field1: u8,
        field2: u8,
    }

    // lint_skip("unused_variable")]
    public fun add_two_values(a: u8, b: u8): u8 {
        let c = a + b;
        // Return a constant after computing addition
        ConstVal
    }

    public fun run_lambda_example(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::CalcModule::add_two_values --args 5u8 7u8


//# run 0xCAFE::CalcModule::run_lambda_example --args 3u8 4u8



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::CalcModule;

    public fun call_inline_addition(x: u8, y: u8): u8 {
        // Call the add_two_values function from CalcModule which returns ConstVal (42)
        let val = CalcModule::add_two_values(x, y);
        val
    }

    public fun runner_no_args(): u8 {
        call_inline_addition(10u8, 20u8)
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_addition --args 1u8 2u8


//# run 0xCAFE::NestedCallModule::runner_no_args



//# publish
module 0xCAFE::StructConstantsModule {
    const MaxCount: u64 = 100;

    struct ComplexStruct has store, drop, copy {
        a_field: u64,
        b_field: u8,
        c_field: bool,
    }

    public fun create_struct(a: u64, b: u8, c: bool): ComplexStruct {
        ComplexStruct {a_field: a, b_field: b, c_field: c}
    }
}


//# run 0xCAFE::StructConstantsModule::create_struct --args 50u64 10u8 true


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 3c50d21bbb4567ffaa575f96d84c2c36: Use attribute-based lint skip annotations on Move functions to suppress specific lints.
// 107f519cdb04a9583c77986ee754dd01: Define struct fields with types, and ensure each field has a unique name within the struct definition.
// 33a822d31d9a501c5ed6c5bdebc0581a: Name struct constants or schemas with an initial uppercase ASCII letter
