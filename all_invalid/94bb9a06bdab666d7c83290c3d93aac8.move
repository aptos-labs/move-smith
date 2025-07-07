// #publish
module 0xCAFE::FriendTest {
    // Using friend keyword in pragma, testing special pragma property
    // Note: This pragma syntax is for demonstration as friend is a special keyword
    // in Move pragmas, so we just declare it exactly as requested.
    pragma friend;

    // Function to test nested if-else branches and uninitialized variable
    public fun test_nested_if_else(): bool {
        let mut x: u64;
        let condition1 = true;
        let condition2 = false;

        if (condition1) {
            if (condition2) {
                x = 42;
            } else {
                x = 100;
            }
        } else {
            // x is not initialized here intentionally
            return false;
        }

        // We expect to reach this point with x initialized
        assert!(x == 100, 1);
        true
    }

    // A "runner" function without arguments to call test_nested_if_else, returning bool
    public fun runner(): bool {
        test_nested_if_else()
    }
}
// #run 0xCAFE::FriendTest::runner

// #publish
module 0xCAFE::AddressFilter {
    use std::vector;
    use std::string;

    /// Simple struct representing an address and its module name
    struct AddressModule has copy, drop, store {
        addr: address,
        module_name: vector<u8>, // store module name as bytes (utf8)
    }

    /// Returns vector of AddressModule filtered by address > some threshold
    public fun filter_addresses(addr_mods: vector<AddressModule>, threshold: address): vector<AddressModule> {
        let mut result = vector::empty<AddressModule>();
        let length = vector::length(&addr_mods);
        let mut i = 0;
        while (i < length) {
            let am = *vector::borrow(&addr_mods, i);
            if (am.addr > threshold) {
                vector::push_back(&mut result, am);
            }
            i = i + 1;
        }
        result
    }

    /// Runner function with no arguments, tests filtering addresses
    public fun runner(): u64 {
        let addr1 = @0x100;
        let addr2 = @0x200;
        let addr3 = @0x50;

        let m1 = AddressModule { addr: addr1, module_name: b"ModA" };
        let m2 = AddressModule { addr: addr2, module_name: b"ModB" };
        let m3 = AddressModule { addr: addr3, module_name: b"ModC" };

        let list = vector::empty<AddressModule>();
        vector::push_back(&mut list, m1);
        vector::push_back(&mut list, m2);
        vector::push_back(&mut list, m3);

        let filtered = filter_addresses(list, @0x100);
        // Return number of elements filtered (should be 1, since only addr2 = 0x200 > 0x100)
        vector::length(&filtered)
    }
}
// #run 0xCAFE::AddressFilter::runner

// #run
script {
    use 0xCAFE::FriendTest;
    use 0xCAFE::AddressFilter;
    fun main() {
        let res1 = FriendTest::runner();
        // No assertion needed, just call

        let res2 = AddressFilter::runner();
        // No assertion needed, just call
    }
}

// Featurres:
// 3d4de455fbf6f87677a9c22a23f67039: Use the special 'friend' property in pragmas even though 'friend' is a keyword.
// 1a8bd231b3764def4f6f4e5ff06d711c: Test that the function correctly executes nested if-else branches and reaches an assertion involving uninitialized variable x.
// bd55926960feba0d24f5bc21babb44c0: Filter addresses and their associated modules based on specific criteria.
