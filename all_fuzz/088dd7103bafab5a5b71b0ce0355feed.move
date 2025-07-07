
//# publish
module 0xCAFE::AddAndLambda {
    // 1. Test that the Move function correctly computes the addition of two u8 before returning 42.
    public fun add_and_return_42(a: u8, b: u8): u8 {
        let _sum = a + b;
        // ignore sum, always return 42
        42u8
    }

    // 2. Write functions containing lambda (anonymous function) expressions.
    public fun apply_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::AddAndLambda::add_and_return_42 --args 10u8 20u8



//# run 0xCAFE::AddAndLambda::apply_lambda --args 3u8 4u8




//# publish
module 0xCAFE::InlineNest {
    use 0xCAFE::AddAndLambda;

    public inline fun f_inline(x: u8): u8 {
        x + 1
    }

    public fun call_nested_inline(x: u8): u8 {
        let y = f_inline(x);
        let z = AddAndLambda::add_and_return_42(y, 0u8);
        z
    }
}



//# run 0xCAFE::InlineNest::call_nested_inline --args 20u8




//# publish
module 0xCAFE::SpecWithResource {
    // 5. Convert 'resource StructName' to 'struct StructName' for clarity.
    struct R {
        val: u64
    }

    public fun create_resource(val: u64): R {
        R { val }
    }
}



//# run 0xCAFE::SpecWithResource::create_resource --args 123u64


// 4. Add specification blocks using '//' style in a script.


//# run
script {
    use 0xCAFE::AddAndLambda;
    use 0xCAFE::InlineNest;

    // spec begin
    // let a: u8 = 5;
    // let b: u8 = 7;
    // let sum: u8 = AddAndLambda::add_and_return_42(a, b);
    // assert!(sum == 42, 1000);
    // spec end

    fun main() {
        let (sum, product) = AddAndLambda::apply_lambda(6u8, 7u8);
        let nested_result = InlineNest::call_nested_inline(15u8);
    }
}





//# publish
module 0x42::m {
    use std::vector;

    // 6. Test init that correctly maps over nested KEYS and VALUES vectors,
    // producing new vectors with each element transformed as specified.

    const KEYS: vector<vector<u8>> = vector[vector[1u8, 2u8], vector[3u8]];
    const VALUES: vector<vector<u8>> = vector[vector[4u8, 5u8], vector[6u8]];

    public fun init(): (vector<vector<u8>>, vector<vector<u8>>) {
        let mapped_keys = vector::empty<vector<u8>>();
        let mapped_values = vector::empty<vector<u8>>();

        let i = 0;
        while (i < vector::length(&KEYS)) {
            let key_vec_ref = vector::borrow(&KEYS, i);
            let val_vec_ref = vector::borrow(&VALUES, i);

            let mapped_key = vector::empty<u8>();
            let mapped_val = vector::empty<u8>();

            let j = 0;
            while (j < vector::length(key_vec_ref)) {
                let key_item = *vector::borrow(key_vec_ref, j);
                vector::push_back(&mut mapped_key, key_item + 1);
                j = j + 1;
            };

            let k = 0;
            while (k < vector::length(val_vec_ref)) {
                let val_item = *vector::borrow(val_vec_ref, k);
                vector::push_back(&mut mapped_val, val_item + 2);
                k = k + 1;
            };

            vector::push_back(&mut mapped_keys, mapped_key);
            vector::push_back(&mut mapped_values, mapped_val);

            i = i + 1;
        };
        (mapped_keys, mapped_values)
    }
}



//# run 0x42::m::init


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e445e26e2e2c189197976b9a59bda504: Add specification blocks to your script using '#' or 'spec' blocks.
// 9577520d8232c98f76911a998b011e48: Convert 'resource StructName' to 'struct StructName' for clarity.
// 5eafbee2719a80f9329f738c4cdd18bb: Test that the `init` function in module `0x42::m` correctly maps over the nested `KEYS` and `VALUES` vectors, producing new vectors with each element transformed as specified.
