
//# publish
module 0xCAFE::TestModule {
    // Precisely define function signatures for clear input/output types
    public fun add_u64_and_u64(x: u64, y: u64): u64 {
        x + y
    }

    public fun sub_u128_and_u128(x: u128, y: u128): u128 {
        x - y
    }

    public fun concat_bytes(a: vector<u8>, b: vector<u8>): vector<u8> {
        [a, b].concat()
    }

    // Function with an abort condition to test expected failure
    public fun divide_u64(dividend: u64, divisor: u64): u64 {
        if (divisor == 0) {
            abort 1; // abort code 1: divide by zero
        }
        dividend / divisor
    }

    // Function that returns a tuple (pair) to test tuple return types
    public fun split_u128(value: u128): (u64, u64) {
        (value as u64, (value >> 64) as u64)
    }

    // A function interacting with a nested struct field
    struct Inner {
        field: u64,
    }

    struct Outer {
        inner: Inner,
    }

    public fun get_inner_field(o: &Outer): u64 {
        let inner_ref = &o.inner;
        inner_ref.field
    }
}


//# run 0xCAFE::TestModule::add_u64_and_u64 --signers 0xCAFE --args 10u64 20u64


//# run 0xCAFE::TestModule::sub_u128_and_u128 --signers 0xCAFE --args 100u128 50u128


//# run 0xCAFE::TestModule::concat_bytes --signers 0xCAFE --args b"Hello" b"World"


//# run 0xCAFE::TestModule::divide_u64 --signers 0xCAFE --args 100u64 0u64
// expected_failure(abort_code = 1)



//# run 0xCAFE::TestModule::divide_u64 --signers 0xCAFE --args 100u64 10u64


//# run 0xCAFE::TestModule::split_u128 --signers 0xCAFE --args 0x112233445566778899aabbccddeeffu128

// Script to test nested struct field access

//# run 0xCAFE::TestModule::get_inner_field --signers 0xCAFE

// Featurres:
// 16fb619de252412c464b95bc01d8ea85: Use function signatures to precisely define input and output types for your functions.
// cb5a6fbd61ea12a0e989e36192ba9357: Provide an abort code or an optional module location when specifying #[expected_failure(abort_code = ...)] to indicate which abort error you expect and from which module.
// e3b75d75b043a543f9b015c19d7f6435: Use dot access to access fields or methods with `e.f`.
