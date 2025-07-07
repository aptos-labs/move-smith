//# publish
module 0xCAFE::LiteralAndMatchTest {
    use std::signer;

    // Declare module attribute constants with u64 literal values
    const MAX_AMOUNT: u64 = 1000000u64;
    const MIN_AMOUNT: u64 = 10u64;

    struct Data has copy, drop, store, key {
        value: u64,
    }

    public fun create_data(s: signer, amount: u64): Data {
        let data = Data { value: amount };
        move_to<Data>(&s, data);
        data
    }

    public fun check_amount(amount: u64): u64 {
        let result = match amount {
            0u64 => 0u64,
            x if x < MIN_AMOUNT => {
                // Returns the minimum amount if less than MIN_AMOUNT
                MIN_AMOUNT
            },
            x if x > MAX_AMOUNT => {
                // Returns max amount if exceeds MAX_AMOUNT
                MAX_AMOUNT
            },
            _ => amount,
        };
        result
    }

    public fun get_value(s: signer): u64 {
        let data_ref: &Data = borrow_global<Data>(signer::address_of(&s));
        // Use a match expression with block body that returns the contained value or zero if below minimum
        let checked_value = match data_ref.value {
            x if x < MIN_AMOUNT => {
                0u64
            },
            _ => data_ref.value,
        };
        checked_value
    }

    public fun runner() {
        let _ = create_data(signer::spec_address(), 5u64);
        let _ = create_data(signer::spec_address(), 1500000u64);
        let _ = check_amount(0u64);
        let _ = check_amount(50u64);
        let _ = get_value(signer::spec_address());
    }
}

//# run 0xCAFE::LiteralAndMatchTest::runner

// Featurres:
// 88246674b0b0aae5441982b302638d41: Declare model attributes that use u64 literal values.
// 477f6a0d7e3e657c8ff5d179eb8af0c8: Declare scripts with associated function names.
// 854f81617e84b9895feb9ed044a5d0b8: Include an expression as the body of a match arm, which can be a block or a single expression.
