
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed specific value 42 if sum is > 0 else 0 (logic just for the test)
        if (sum > 0) {
            42
        } else {
            0
        };
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_specific --args 20u8 22u8


//# publish
module 0xCAFE::LambdaModule {
    public fun run_lambda_example(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::LambdaModule::run_lambda_example --args 3u8 7u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AdditionModule;

    public inline fun call_inline_and_nested(a: u8, b: u8): u8 {
        AdditionModule::add_and_return_specific(a, b)
    }
}


//# run 0xCAFE::InlineCaller::call_inline_and_nested --args 1u8 41u8


//# publish
module 0xCAFE::VectorAndEnsures {
    use std::vector;

    public fun create_vectors_and_check() {
        let v1 = vector[b'H', b'i'];
        let v2: vector<u8> = vector[b'A', b'B', b'C'];
        let v3: vector<u64> = vector[];
        let v4: vector<address> = vector[@0x1234, @0x4321];

        // Test push_back and pop_back
        let v5 = vector::empty<u8>();
        vector::push_back(&mut v5, 10);
        vector::push_back(&mut v5, 20);

        assert!(*vector::borrow(&v5, 0) == 10, 1001);
        assert!(*vector::borrow(&v5, 1) == 20, 1002);
        assert!(vector::pop_back(&mut v5) == 20, 1003);
        assert!(vector::pop_back(&mut v5) == 10, 1004);
    }

    public fun sum_and_ensures(a: u8, b: u8): u8
    ensures result > 0 {
        let sum = a + b;
        sum
    }
}


//# run 0xCAFE::VectorAndEnsures::create_vectors_and_check


//# run 0xCAFE::VectorAndEnsures::sum_and_ensures --args 5u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d139b53871f4a67fd9722cb7af8e5085: Use vector/array literals with or without type arguments.
// ef89fb716321f49d8a65468e9d0e9179: Use 'ensures' to specify postconditions that must hold after a function executes.
