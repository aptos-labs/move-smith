
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        // It returns 42 regardless of sum to test computation + constant return
        42
    }

    public fun apply_lambda_to_sum(): u8 {
        let f: |u8| u8 has copy+drop = |x: u8| {
            x + 1
        };
        let x = 10u8;
        let y = 20u8;
        let sum = x + y;
        f(sum)
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_constant --args 10u8 20u8


//# run 0xCAFE::AdditionModule::apply_lambda_to_sum


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_inline_and_lambda(): u8 {
        let base = 99u8;
        let res = AdditionModule::apply_lambda_to_sum();
        let incr = inline_increment(base);
        res + incr
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_and_lambda


//# publish
module 0xCAFE::Disassembler {
    // Dummy function to simulate disassembly call
    public fun disassemble_dummy_bytes(): vector<u8> {
        // Just return some bytes that could represent a compiled module
        vector[0x0b, 0x1a, 0x2c, 0x3d]
    }
}


//# run 0xCAFE::Disassembler::disassemble_dummy_bytes


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d6c49a6fc41110137abb89dae66a9144: Disassemble compiled Move units into human-readable code
