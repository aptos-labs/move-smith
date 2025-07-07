
//# publish
module 0xCAFE::AddAndLambda {
    /// Adds two u8 numbers and returns the sum plus a fixed offset 10
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10u8;
        result
    }

    /// Returns a lambda that increments an input u8 by 1
    /// In Move, function pointers are specified as `fun(u8): u8`
    public fun get_increment_lambda(): fun(u8): u8 {
        fun (x: u8): u8 { x + 1u8 }
    }

    /// Uses a function pointer to apply a function twice to an input u8
    public fun apply_twice(f: fun(u8): u8, x: u8): u8 {
        let first = f(x);
        let second = f(first);
        second
    }

    /// Runner function to test get_increment_lambda and apply_twice
    public fun lambda_runner(): u8 {
        let inc = get_increment_lambda();
        apply_twice(inc, 5u8)
    }
}




//# run 0xCAFE::AddAndLambda::add_with_offset --args 3u8 7u8




//# run 0xCAFE::AddAndLambda::lambda_runner




//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndLambda;

    /// Calls AddAndLambda::add_with_offset internally and multiplies result by 2
    public fun multiply_add_result(a: u8, b: u8): u8 {
        let addition_result = AddAndLambda::add_with_offset(a, b);
        addition_result * 2u8
    }

    /// Calls AddAndLambda::lambda_runner and adds a fixed offset 5
    public fun nested_lambda_call(): u8 {
        let val = AddAndLambda::lambda_runner();
        val + 5u8
    }
}




//# run 0xCAFE::NestedCalls::multiply_add_result --args 4u8 6u8




//# run 0xCAFE::NestedCalls::nested_lambda_call





//# publish
module 0xCAFE::NamedAddressTest {
    use std::vector;
    use std::address;

    /// Return fixed well known named address 0xCAFE
    public fun get_named_address(): address {
        // address::from_bytes takes vector<u8> (without '[ ]'), use vector::empty & vector::push_back or directly vector::from_u8_array
        // The easiest, native is address with literal 0xCAFE0000000000000000000000000000
        // Move currently supports address literals like 0xCAFE0000000000000000000000000000
        @0xCAFE0000000000000000000000000000
    }

    /// Verifies that module address matches the named address by comparing with input address
    public fun verify_current_address(addr: address): bool {
        addr == get_named_address()
    }
}




//# run 0xCAFE::NamedAddressTest::get_named_address




//# run 0xCAFE::NamedAddressTest::verify_current_address --args 0xCAFE0000000000000000000000000000
