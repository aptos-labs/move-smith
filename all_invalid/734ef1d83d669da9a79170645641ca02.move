//# publish
module 0xCAFE::BinaryLoopLambdaTest {
    use std::signer;
    use std::vector;

    struct Data has store, key {
        values: vector<u8>,
        sum: u64,
    }

    public fun create_data(s: signer) {
        let mut values = vector::empty<u8>();
        vector::push_back(&mut values, 10);
        vector::push_back(&mut values, 20);
        vector::push_back(&mut values, 30);

        let data = Data {
            values,
            sum: 0,
        };
        move_to<Data>(&s, data);
    }

    public fun binary_and_mutation(s: signer): u8 {
        let data_ref = borrow_global_mut<Data>(signer::address_of(&s));
        let len = vector::length(&data_ref.values) as u8;

        let mut i: u8 = 0;
        let mut result: u8 = 0;
        while (i < len) {
            let val = *vector::borrow(&data_ref.values, i as usize);
            // binary AND with 0x1 to check if val is odd
            if ((val & 0x1) == 1) {
                result = result + val;
            };
            i = i + 1;
        };

        // store the result (sum of odd numbers) in sum field as u64
        data_ref.sum = result as u64;
        result
    }

    public fun for_loop_sum(): u64 {
        let mut sum: u64 = 0;
        for (i in 3u64..8u64) {
            // each iteration sum += i as u64
            sum = sum + i;
        };
        sum
    }

    public fun lambda_double(x: u8): u8 {
        let doubler: &fun(u8): u8 = &|a: u8| {
            a * 2
        };
        *doubler(x)
    }
}

//# run 0xCAFE::BinaryLoopLambdaTest::create_data --signers 0xBEEF

//# run 0xCAFE::BinaryLoopLambdaTest::binary_and_mutation --signers 0xBEEF

//# run 0xCAFE::BinaryLoopLambdaTest::for_loop_sum

//# run 0xCAFE::BinaryLoopLambdaTest::lambda_double --args 21u8