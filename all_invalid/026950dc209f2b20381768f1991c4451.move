
//# publish
module 0xCAFE::ConstantsAndLambdas {
    // Testing constant declarations and usage within a module
    const CONST_ONE: u64 = 1;
    const CONST_TWO: u64 = 2;

    // Struct with store, drop for test closure with mutable reference
    struct Data has store, drop {
        value: u64,
    }

    // Public function returning sum of CONST_ONE and CONST_TWO
    public fun sum_constants(): u64 {
        CONST_ONE + CONST_TWO
    }

    // Public function to test mutable reference mutation in inner closure with drop ability
    public fun mutable_lambda_mutation() {
        let data = Data { value: 0 };

        // Outer closure capturing mutable reference to data
        let outer_lambda = || {
            let inner_lambda = |d: &mut Data| {
                d.value = CONST_ONE;
            };
            inner_lambda(&mut data);
        };

        outer_lambda();
        // To use data.value and avoid warning, add a dummy let statement
        let _ = data.value;
    }

    // Runner function for test without arguments
    public fun runner() {
        let _ = sum_constants();
        mutable_lambda_mutation();
    }
}


//# run 0xCAFE::ConstantsAndLambdas::runner
