
//# publish
module 0xCAFE::AdditionModule {
    use std::signer;

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 10u8 to check correct addition and arithmetic
        sum + 10u8
    }

    public fun lambda_example(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |v: u8| {
            v * 2
        };
        lambda(x)
    }

    public fun nested_call(x: u8, y: u8): u8 {
        // call add_two_u8 inside this module
        let sum = add_two_u8(x, y);

        // lambda doubles the sum
        let doubled = lambda_example(sum);
        doubled
    }

    public fun get_signer_address(s: signer): address {
        signer::address_of(&s)
    }
}



//# run 0xCAFE::AdditionModule::add_two_u8 --args 5u8 7u8



//# run 0xCAFE::AdditionModule::lambda_example --args 6u8



//# run 0xCAFE::AdditionModule::nested_call --args 3u8 4u8



//# run 0xCAFE::AdditionModule::get_signer_address --signers 0xDEAD
