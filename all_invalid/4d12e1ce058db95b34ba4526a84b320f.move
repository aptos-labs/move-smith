//# publish
module 0xCAFE::BinaryLoopLambdaTest {
    use std::signer;
    use std::vector;

    struct Data has store, key {
        values: vector<u8>,
        sum: u64,
    }

    public fun create_data(s: signer) {
        let values = vector::empty<u8>();
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

        let mut i = 0u8;
        let mut result = 0u8;
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
        let mut sum = 0u64;
        for (i in 3..8) {
            // each iteration sum += i as u64
            sum = sum + (i as u64);
        };
        sum
    }

    public fun lambda_double(x: u8): u8 {
        let doubler: |u8|u8 has copy+drop = |a: u8| {
            a * 2
        };
        doubler(x)
    }
}

//# run 0xCAFE::BinaryLoopLambdaTest::create_data --signers 0xBEEF

//# run 0xCAFE::BinaryLoopLambdaTest::binary_and_mutation --signers 0xBEEF

//# run 0xCAFE::BinaryLoopLambdaTest::for_loop_sum

//# run 0xCAFE::BinaryLoopLambdaTest::lambda_double --args 21u8

// Featurres:
// dd4eff7e3f7a385386f7e25b5d20f03f: Use binary operations, mutation, while loops, and indexing expressions.
// b64c89f57033b655cd607100490684a0: Create a traditional 'for' loop that iterates from a lower bound to an upper bound with variable declarations.
// 6a689f124f862b298761784ba512abd7: Define lambda (anonymous) functions in your Move code, which will be automatically converted to named functions via lambda lifting by the compiler.
