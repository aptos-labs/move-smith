//# publish
module 0xCAFE::EnsuresRequiresTest {
    use std::signer;

    struct Data has store {
        value: u8,
    }

    // Create and store Data only if value is less than 200 (requires)
    // Ensures that stored value is equal to input value after creation
    #[requires(val < 200)]
    #[ensures(borrow_global<Data>(signer::address_of(&s)).value == val)]
    public fun create_data(s: signer, val: u8) {
        let data = Data { value: val };
        move_to<Data>(&s, data);
    }

    // Increment stored value by 1, only if value is less than 254 (requires)
    // Ensures that new stored value is old + 1
    #[requires(exists<Data>(signer::address_of(&s)))]
    #[ensures(borrow_global<Data>(signer::address_of(&s)).value == old(borrow_global<Data>(signer::address_of(&s))).value + 1)]
    public fun increment_data(s: signer) {
        let data_ref = borrow_global_mut<Data>(signer::address_of(&s));
        assert!(data_ref.value < 254, 777);
        let old_value = data_ref.value;
        data_ref.value = old_value + 1;
    }

    // Compare addresses given as decimal and hex literals for equality
    // Returns true if they are equal, false otherwise
    public fun compare_addresses(): bool {
        let addr_hex: address = @0xAABB;
        let addr_dec: address = @43707; // 0xAABB decimal = 43707
        addr_hex == addr_dec
    }

    // Empty public function with lint skip attribute to test skipping lints
    #[allow(unused_imports)]
    public fun lint_skip_example() {
        // purposely empty and unused imports would normally cause warning
    }

}

//# run 0xCAFE::EnsuresRequiresTest::create_data --signers 0xBEEF --args 123u8

//# run 0xCAFE::EnsuresRequiresTest::increment_data --signers 0xBEEF

//# run 0xCAFE::EnsuresRequiresTest::compare_addresses

//# run 0xCAFE::EnsuresRequiresTest::lint_skip_example

// Features:
// df10cfb48ff6d4d43dd25ddb8db9e759: Use 'ensures' and 'requires' conditions to specify postconditions and preconditions for functions.
// d6737f4684fc194ee60b487b2ee0ce39: Test that hexadecimal and decimal address literals with equivalent values are considered equal in address comparisons.
// ca6f2174749451b030fe92100d561cbe: Use attributes to specify lint checks to skip during compilation.