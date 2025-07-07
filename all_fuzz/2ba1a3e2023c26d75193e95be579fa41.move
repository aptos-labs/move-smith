
//# publish
module 0xCAFE::MathOps {
    // Test that the Move function correctly computes the addition of two u8 values before returning a specific value.

    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    // Write functions containing lambda (anonymous function) expressions.
    public fun compute_with_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::MathOps::add_then_return_sum --args 10u8 15u8



//# run 0xCAFE::MathOps::compute_with_lambda --args 3u8 7u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::MathOps;

    // Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
    public inline fun call_add_then_return_sum_nested(): u8 {
        let a = 20u8;
        let b = 22u8;

        // Call add_then_return_sum from MathOps
        let sum = MathOps::add_then_return_sum(a, b);
        // add 1 to the result
        sum + 1
    }
}



//# run 0xCAFE::InlineCaller::call_add_then_return_sum_nested



//# publish
module 0xCAFE::TypeParamFormatter {
    use std::vector;

    // A struct representing type parameters with name and constraint flag
    struct TypeParam has copy, drop, store {
        name: vector<u8>,
        has_constraints: bool,
    }

    // Format a list of type parameters with their names and constraints into a string suitable for code generation.
    public fun format_type_params(params: vector<TypeParam>): vector<u8> {
        let result = b"<";
        let len = vector::length(&params);
        let i = 0u64;
        while (i < len) {
            let param = *vector::borrow(&params, i);
            // param.name is vector<u8>, append expects vector<u8>, so pass directly
            vector::append(&mut result, param.name);

            if (param.has_constraints) {
                vector::append(&mut result, b": constraint");
            };
            i = i + 1;
            if (i < len) {
                vector::push_back(&mut result, 44u8);  // ','
                vector::push_back(&mut result, 32u8);  // ' '
            };
        };
        vector::push_back(&mut result, 62u8);  // '>'
        result
    }

    // A runner function to create example type params and format them
    public fun run_format_example(): vector<u8> {
        let tp1 = TypeParam { name: b"T", has_constraints: false };
        let tp2 = TypeParam { name: b"U", has_constraints: true };
        let params = vector::empty<TypeParam>();
        vector::push_back(&mut params, tp1);
        vector::push_back(&mut params, tp2);
        format_type_params(params)
    }
}



//# run 0xCAFE::TypeParamFormatter::run_format_example



//# publish
module 0xCAFE::BlockOrder {
    // Test that blocks used as function arguments are evaluated in the correct left-to-right order,
    // each block can mutate local variables, and the final result reflects these side effects.

    public fun test_order(): u64 {
        let x = 0u64;
        let y = 0u64;

        // local function definitions are not supported inside Move functions,
        // so move add function logic inline:
        let res = ( {
            x = x + 1;
            x
        } ) + ( {
            y = y + 10;
            y
        } );
        // After evaluation x = 1, y = 10, res = 1 + 10 = 11
        res
    }
}



//# run 0xCAFE::BlockOrder::test_order


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4122afb27c5fe0f1f8211da9cf3e0924: Format a list of type parameters with their names and constraints into a string suitable for code generation.
// 8ab2c2b88ea0c5733f361b383914e6f8: Test that blocks used as function arguments are evaluated in the correct left-to-right order, each block can mutate local variables, and the final result reflects these side effects.
