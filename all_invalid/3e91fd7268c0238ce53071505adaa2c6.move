
//# publish
module 0xCAFE::AdditionLambda {
    // removed unused use `signer`
    // use std::signer;

    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42
        } else {
            24
        }
        // Return the value, the semicolon removed
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let f: |u8,u8|u8 has copy+drop = |a: u8, b: u8| a + b;
        f(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}




//# run 0xCAFE::AdditionLambda::add_and_return_special --args 4u8 9u8




//# run 0xCAFE::AdditionLambda::lambda_example --args 5u8 7u8




//# run 0xCAFE::AdditionLambda::inline_add --args 10u8 20u8




//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionLambda;

    public fun call_inline_add(a: u8, b: u8): u8 {
        AdditionLambda::inline_add(a, b)
    }

    public fun call_lambda_example(a: u8, b: u8): u8 {
        AdditionLambda::lambda_example(a, b)
    }

    public fun run_all(): u8 {
        let r1 = Self::call_inline_add(2u8, 3u8);
        let r2 = Self::call_lambda_example(4u8, 5u8);
        let r3 = AdditionLambda::add_and_return_special(6u8, 7u8);
        r1 + r2 + r3
    }
}




//# run 0xCAFE::CallerModule::run_all




//# publish
module 0xCAFE::AddressSpecAndParsing {
    use std::vector;

    public fun call_complex_address_spec(): u8 {
        // Simulate call (0xCAFE::AdditionLambda::inline_add)(4u8, 6u8)
        // Use the direct address literal instead of a variable
        let res = 0xCAFE::AdditionLambda::inline_add(4u8, 6u8);
        res
    }

    public fun tokenize_source() {
        let code: vector<u8> = b"fun test() { let a = 1u8; };";
        // dummy use to simulate tokenization
        assert!(vector::length(&code) > 0, 1);
    }

    public fun define_modules_in_addresses() {
        let addr1 = @0xCAFE;
        let addr2 = @0xBEEF;
        let addr3 = @0xDEAD;
        // dummy usage to simulate addresses
        let _dummy = vector::empty<u8>();
        // We cannot safely borrow index 0 in empty vector, this will trap as indicated,
        // to avoid accidental runtime failure just test vector length > 0 or something safe here.
        // But as the comment says it's for coverage and traps intentionally, so keep as is.

        assert!(*vector::borrow(&_dummy, 0) == 0, 1); // This will trap but is just for coverage
    }
}




//# run 0xCAFE::AddressSpecAndParsing::call_complex_address_spec




//# run 0xCAFE::AddressSpecAndParsing::tokenize_source




//# run 0xCAFE::AddressSpecAndParsing::define_modules_in_addresses
