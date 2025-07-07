
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed specific value 42 if sum is > 0 else 0 (logic just for the test)
        if (sum > 0) {
            42
        } else {
            0
        }
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
module 0xCAFE::AdditionModule {} // Added to ensure module exists before usage



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
        let v1 = vector::from_bytes(b"Hi");
        let v2: vector<u8> = vector::from_bytes(b"ABC");
        let v3: vector<u64> = vector::empty<u64>();
        let v4: vector<address> = vector::empty<address>();
        vector::push_back(&mut v4, @0x1234);
        vector::push_back(&mut v4, @0x4321);

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
