
//# publish
module 0xCAFE::TestFeatures {
    use std::debug;
    use std::vector;

    const CONST_VALUE: u8 = 42;

    const CONST_REGISTRY_INIT: vector<u8> = vector[];

    struct ConstantRegistry has store {
        constants: vector<u8>,
    }

    public fun add_constant(registry: &mut ConstantRegistry, val: u8) {
        let found = false;
        let len = vector::length(&registry.constants);
        let i = 0;
        while (i < len) {
            let c = *vector::borrow(&registry.constants, i);
            if (c == val) {
                found = true;
            };
            i = i + 1;
        };
        if (!found) {
            vector::push_back(&mut registry.constants, val);
        };
    }

    public fun create_registry(): ConstantRegistry {
        ConstantRegistry { constants: vector[] }
    }

    public fun get_constants_len(registry: &ConstantRegistry): u64 {
        vector::length(&registry.constants)
    }

    public fun compute_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 255u8) { // sum will never overflow because u8 saturates, but just check
            255u8
        } else {
            // Return fixed value 123 on purpose after computing sum
            123u8
        }
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun call_inline(a: u8): u8 {
        let (x, y) = inline_add_sub(a);
        x + y
    }

    public inline fun inline_add_sub(v: u8): (u8, u8) {
        (v + 1, 1)
    }

    public fun dump_bytecode(message: vector<u8>) {
        debug::print(&message);
    }
}


//# run 0xCAFE::TestFeatures::compute_and_return --args 100u8 23u8


//# run 0xCAFE::TestFeatures::with_lambda --args 21u8 21u8


//# run 0xCAFE::TestFeatures::call_inline --args 20u8


//# run 0xCAFE::TestFeatures::dump_bytecode --args b"Dumping bytecode for debugging\n"


//# run 0xCAFE::TestFeatures::create_registry


//# run 0xCAFE::TestFeatures::add_constant --args 0u8


//# run 0xCAFE::TestFeatures::add_constant --args 42u8


//# run 0xCAFE::TestFeatures::add_constant --args 42u8


//# run 0xCAFE::TestFeatures::get_constants_len


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 6368e3be802f97bc891c1d6ad6d9ce48: Automatically dump the bytecode of functions during pipeline execution for debugging purposes.
// 317fa7b3c5a552d9524c0b3f9e17ab77: Add constants to the module's constant registry while checking for duplicates.
