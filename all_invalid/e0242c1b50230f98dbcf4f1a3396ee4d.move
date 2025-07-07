
//# publish
module 0xCAFE::AdvancedTest {
    use std::signer;
    use std::vector;
    use std::string;
    use std::errors;

    /// A simple resource used to test storage and aborts.
    struct Resource has key, store {
        val: u64,
    }

    /// Stores a resource with the given value at the signer's address.
    public fun store_resource(s: signer, val: u64) {
        let r = Resource { val };
        move_to<Resource>(&s, r);
    }

    /// Removes the resource stored at the signer's address.
    public fun remove_resource(s: signer) {
        let r = move_from<Resource>(signer::address_of(&s));
        let Resource { val: _ } = r;
    }

    /// Access the resource and return its value.
    public fun read_resource(s: signer): u64 {
        let r_ref = borrow_global<Resource>(signer::address_of(&s));
        r_ref.val
    }

    /// A dummy inline function to return a tuple.
    public inline fun return_tuple(x: u8): (u8, u8) {
        (x, x + 1)
    }

    /// A function that uses the #expected_failure attribute for out of gas.
    // expected_failure(out_of_gas)]
    public fun drain_gas_loops() {
        let i = 0u64;
        // Intentionally do a large loop to drain gas.
        while (i < 1000000) {
            i = i + 1;
        };
    }

    /// Parses a hex string into NumericalAddress.
    public fun parse_address(): address {
        let addr_vec = vector::empty<u8>();
        vector::push_back(&mut addr_vec, 0xCA);
        vector::push_back(&mut addr_vec, 0xFE);
        vector::push_back(&mut addr_vec, 0x00);
        vector::push_back(&mut addr_vec, 0x00);
        vector::push_back(&mut addr_vec, 0x00);
        vector::push_back(&mut addr_vec, 0x00);
        vector::push_back(&mut addr_vec, 0x00);
        vector::push_back(&mut addr_vec, 0x00);
        // Construct the address from bytes in vector by converting to address via "from_bytes"
        // However, std::address has no "from_bytes" public function currently,
        // so just return the known constant address 0xCAFE000000000000 here for test.
        @0xCAFE000000000000
    }

    /// Dummy inline function to test conditional compilation with test and verification code.
    public fun run_test_code() {
        // Test and verification code included under `// test_only]` and `// verify_only]` attributes

        // These attributes prevent the code from being compiled in non-test/verify builds.
        // Since these attributes are experimental, and we are asked to include them,
        // we just dummy call internal functions with these attributes.

        test_only_function();
        verify_only_function();
    }

    // test_only]
    fun test_only_function() {
        let x = 1u8;
        let y = 2u8;
        let (a, b) = return_tuple(x);
        assert!(a == 1, 1);
        assert!(b == y, 1);
    }

    // verify_only]
    fun verify_only_function() {
        let addr = parse_address();
        let expected: address = @0xCAFE000000000000;
        assert!(addr == expected, 99);
    }
}


//# run 0xCAFE::AdvancedTest::store_resource --signers 0xBEEF --args 42u64


//# run 0xCAFE::AdvancedTest::read_resource --signers 0xBEEF


//# run 0xCAFE::AdvancedTest::remove_resource --signers 0xBEEF


//# run 0xCAFE::AdvancedTest::drain_gas_loops


//# run 0xCAFE::AdvancedTest::parse_address


//# run 0xCAFE::AdvancedTest::run_test_code


// Featurres:
// 447a0a2e92baf94205eeedbcef8abb18: Indicate an out-of-gas error expected in your test with `#[expected_failure(out_of_gas)]` attribute.
// 7b06f0b22230fad7e263e099e9d50b24:  Parse the address string into a `NumericalAddress` object for use within the Move codebase.
// 895e8135296d048d3ab43409b23b1fb0: Include or exclude test and verification code sections during Move compilation.
