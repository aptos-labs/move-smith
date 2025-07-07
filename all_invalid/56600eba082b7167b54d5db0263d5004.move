
//# publish
module 0xCAFE::QuantifierAndAddressTest {
    use std::vector;

    // A module to test various address and quantifier features
    public fun test_feature_x() {
        // No specific output, purpose is to exercise parser and compiler
        let addr1: address = 0xDEADBEAF;
        let addr2: address = 0xABCD1234;
        let addr3: address = 0x12345678;

        // Variable binding with address literals
        let a: address = 0xCAFEBABE;
        let b: address = 0xFEEDFACE;

        // Use in a vector (simulate some usage)
        // Correct syntax for vector of addresses
        let addrs: vector<address> = vector[0xCAFE, 0xBABE, 0xF00D];

        // Use at different addresses
        // For testing syntax, multiple address tokens
        let test_addrs: vector<address> = vector[
            0x0A0A0A0A,
            0xBBBBCCCC,
            0x12340000
        ];
    }
}

module 0xCAFE::QuantifierBindings {
    // A module to test variable binding and type annotations after identifiers
    fun bind_and_type_test() {
        // Quantifier-like syntax in comments (not executable code), to simulate test
        // e.g., variable x: u8, y: bool;
        // In Move, actual syntax is variable declaration, but to simulate, we write:
        let x: u8 = 42;
        let y: bool = true;

        // Multiple variable bindings with types
        let a: u16 = 65535;
        let b: u64 = 1234567890;

        // Nested block with bindings
        {
            let inner_x: bool = false;
            let inner_y: u8 = 255;
        }
    }
}

module 0xCAFE::CombinedModule {
    // A module combining address and binding test features
    public fun combined_test(addr: address, flag: bool) {
        // Using address literals
        let addr1: address = 0xFACEB00C;
        let addr2: address = 0xC0FFEE;

        // Variable with type annotation after identifier
        let size: u64 = 1000;

        // Reassign or pass addresses as arguments
        if (flag) {
            let _ = addr1;
            let _ = addr2;
        } else {
            let _ = 0xDEADBEEF;
        };

        // The following simulate multiple binding with quantifiers by multiple variable declarations
        let (x, y): (u8, u8) = (1, 2);
        let (l: u16, m: u16) = (300, 400);
    }
}



//# run 0xCAFE::QuantifierAndAddressTest::test_feature_x

//# run 0xCAFE::QuantifierBindings::bind_and_type_test

//# run 0xCAFE::CombinedModule::combined_test --args 0xDEADC0DE true

// Features:
// e133b83e8cfd6f30e533670f929994bc: Specify literal addresses as address specifiers.
// be9c8068a6bd9f9c5b6daf9e9a617185: Write quantifier expressions that follow a variable name (identifier) and are followed by either a ':' or another identifier, enabling variable binding and type annotation in specifications.
// ae7648d2f1a91ce9629afa86e0cd2a86: Include multiple modules under a single named address in Move packages.