
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_sum(a: u8, b: u8, ret: u8): u8 {
        let sum = a + b;
        let _ignored = sum; // just an example if needed
        ret
    }
}



//# run 0xCAFE::TestAddition::add_and_return_sum --args 3u8 4u8 7u8



//# publish
module 0xCAFE::LambdaModule {
    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 = |x: u8, y: u8| { x + y };
        lambda(10, 20)
    }

    public fun run_lambda_nested(): u8 {
        let outer_lambda: |u8| u8 = |a: u8| {
            let inner_lambda: |u8| u8 = |b: u8| { a + b };
            inner_lambda(5u8)
        };
        outer_lambda(15u8)
    }
}



//# run 0xCAFE::LambdaModule::run_lambda_example



//# run 0xCAFE::LambdaModule::run_lambda_nested



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::TestAddition;

    public inline fun inline_caller(a: u8, b: u8): u8 {
        let c = TestAddition::add_and_return_sum(a, b, a + b);
        c
    }

    public fun caller(): u8 {
        inline_caller(2u8, 3u8)
    }
}



//# run 0xCAFE::InlineCaller::caller



//# publish
module 0xCAFE::ChooseQuantifier {
    use std::vector;

    // Use an inline function returning a vector<u8> to demonstrate choose quantifier usage
    public inline fun sample_data(): vector<u8> {
        vector[5u8, 2u8, 9u8, 1u8, 7u8]
    }

    // Choose minimal element from a vector<u8>
    public fun choose_min(vec: &vector<u8>): u8 {
        let min_val = *vector::borrow(vec, 0);
        let len = vector::length(vec);
        let i = 1;
        while (i < len) {
            let val = *vector::borrow(vec, i);
            if (val < min_val) {
                min_val = val;
            };
            i = i + 1;
        };
        min_val
    }

    // Demonstrate a simple usage of choice quantifier with min selection
    public fun test_choose_min(): u8 {
        let data = sample_data();
        choose_min(&data)
    }
}



//# run 0xCAFE::ChooseQuantifier::test_choose_min
