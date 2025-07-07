
//# publish
module 0xCAFE::AddressMapTransform {
    use std::string;
    use std::vector;
    use std::symbol::Symbol;
    use std::symbol::string_map_to_symbol_map;
    use std::diag::diag;
    use std::diag::report_error;

    // Struct to hold address map for transformation
    struct PackagePaths {
        named_address_map: vector<(string, string)>,
    }

    // Function to transform address map to symbol map
    public fun transform_address_map(addr_map: &vector<(string, string)>): vector<(Symbol, Symbol)> {
        let symbol_map = string_map_to_symbol_map(addr_map);
        symbol_map
    }
}


//# run 0xCAFE::AddressMapTransform::test_transform

public fun test_transform() {
    let address_list = vector[
        (b"zero.s".to_owned(), b"0x0".to_owned()),
        (b"main.s".to_owned(), b"0x1".to_owned()),
        (b"test.s".to_owned(), b"0x2".to_owned())
    ];

    // Transform the address list using string_map_to_symbol_map
    let symbol_map = 0xCAFE::AddressMapTransform::transform_address_map(&address_list);
}


//# run 0xCAFE::LoopWithInvariant::loop_with_invariant

module 0xCAFE::LoopWithInvariant {
    use std::diag::diag;

    // Function demonstrating a 'for' loop with initialization, invariant, and body
    public fun loop_with_invariant() {
        let sum: u64 = 0;
        let i: u64 = 0;

        // Loop: i from 0 to 9 inclusive
        for (let end = 10; i < end; i = i + 1) {
            // Loop invariant: sum equals the sum of first i-1 numbers
            // (Invariant condition: sum == (i * (i - 1)) / 2) for i > 0
            if (i > 0) {
                let expected_sum = (i - 1) * i / 2;
                if (sum != expected_sum) {
                    diag(report_error(b"Loop invariant violated: sum does not match expected value."));
                }
            }
            sum = sum + i;
        }

        // After loop, sum should be 45 for 0..9
        if (sum != 45) {
            diag(report_error(b"Sum after loop is incorrect: expected 45."));
        }
    }
}


//# run 0xCAFE::LoopWithInvariant::loop_with_invariant

// No need to report list syntax error in the transactional test, remove the script as it's invalid.