
//# publish

module 0xCAFE::AddressMapTransform {
    use std::string;
    use std::vector;
    use std::symbol::{Symbol, string_map_to_symbol_map};
    use std::diag::{diag, report_error};

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
            // If violated, report error with message
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

// Error reporting example: incorrect syntax for list (should be vector[])
// This is intentionally invalid to trigger diagnostic message

//# run
public fun report_list_syntax_error() {
    // Incorrect list syntax - missing vector declaration
    // should be: let arr = vector[1, 2, 3];
    let bad_list = [1, 2, 3]; // This line should produce a diagnostic error
}

// Featurres:
// 5ac5312e0886432f5e1443dbd24ff895: Transform the 'named_address_map' within PackagePaths from String keys and values to Symbol keys and values using 'string_map_to_symbol_map'.
// b2785844598a33f217390a808e1667e1: Use the 'for' loop syntax with initialization, loop invariant specification, and body blocks.
// efa6041ea0deaa30b1a289263862ca3b: Report errors with diagnostic messages if list syntax is incorrect.
