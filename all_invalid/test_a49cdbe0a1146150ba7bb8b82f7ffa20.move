//# publish
module 0x99::resource_borrow_tests {
    // Define a global resource with ownership and key ownership
    struct Res has key, store {
        id: u64,
        owner: address,
    }

    // Initialize and publish a resource under a signer
    public fun init(s: &signer, id: u64) {
        move_to(s, Res { id, owner: signer::address_of(s) });
    }

    // Function to borrow a global resource with a specific address string - valid case
    public fun borrow_valid_address(addr_str: &str): bool acquires Res {
        // Parse the address string to an address reference
        // For simplicity in this test, assume the address is directly accessible
        // and matches an existing resource
        // In actual implementation, parsing and error handling would be needed
        let addr_opt = address::from_hex(addr_str);
        if (addr_opt.is_none()) {
            return false;
        }
        let addr = addr_opt.unwrap();

        // Attempt to borrow the global resource at the given address
        // Using borrow_global with a specific address
        match borrow_global<Res>(addr) {
            res => {
                // Check that resource owner matches address
                return res.owner == addr;
            }
            // If borrow fails (resource doesn't exist), return false
            _ => false,
        }
    }

    // Function to borrow with an invalid address string (not hex, or invalid scope)
    public fun borrow_invalid_address(addr_str: &str): bool {
        // Attempt to parse invalid address
        match address::from_hex(addr_str) {
            some => {
                // If parse succeeded unexpectedly, try borrow
                borrow_global<Res>(some).is_some()
            }
            none => {
                // Parsing failed; expected for invalid input
                false
            }
        }
    }

    // Function to attempt borrowing from an address with insufficient scope (simulate cross-module scope)
    public fun attempt_cross_scope_borrow(signer_addr: address): bool acquires Res {
        // For test: try to borrow from an address not owning the resource (simulate invalid scope)
        // For simplicity, just attempt to borrow from a different address
        let dummy_addr: address = @0xdeadbeef;
        // borrow_global should fail if resource not at dummy_addr
        borrow_global<Res>(dummy_addr).is_some()
    }

    public fun test_borrows(s: &signer) {
        // Initialize resources under different addresses (simulate)
        // Note: In real Move tests, actual signers are used, but for test here, assume addresses

        // Initialize resource at signer's address
        init(s, 100);

        // Borrow with valid address string, matching the resource owner's address
        let owner_addr_str = signer::address_of(s).to_hex();

        // Should succeed
        assert!(Self::borrow_valid_address(&owner_addr_str), 1);

        // Borrow with invalid address string (not hex)
        assert!(!Self::borrow_invalid_address("invalid_addr"), 2);

        // Borrow from an address not owning any resource
        // Using a different address string
        assert!(!Self::borrow_valid_address(&"0x1234").to_string(), 3);

        // Attempt cross-scope borrow (simulate)
        // In this simplified test, just check borrow fails
        assert!(!Self::attempt_cross_scope_borrow(signer::address_of(s)), 4);
    }
}

//# run --verbose --signers 0x1 -- 0x99::resource_borrow_tests::test_borrows