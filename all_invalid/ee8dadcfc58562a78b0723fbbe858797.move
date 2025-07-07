
//# run
script {
    // Outer loop with nested if-continue and outer condition break test
    let i: u64 = 0;
    let sum: u64 = 0;
    // Execute loop while i < 20
    while (i < 20) {
        // If i is divisible by 3, skip this iteration
        if (i % 3 == 0) {
            i = i + 1;
            continue;
        }
        // If i exceeds 15, break the loop
        if (i > 15) {
            break;
        }
        // Accumulate sum
        sum = sum + i;
        i = i + 1;
    };
    // Expected sum is sum of numbers 1..15 excluding multiples of 3
    // i.e., 1,2,4,5,7,8,10,11,13,14,15
    // sum up to 15, excluding multiples of 3
    assert!(sum == (1 + 2 + 4 + 5 + 7 + 8 + 10 + 11 + 13 + 14 + 15), 100);
}

// Read the compiled module from binary file and verify deserialization

    let module_bytes = std::fs::read(b"test_module.mv");
    assert!(module_bytes.is_ok(), 101);
    let bytes = module_bytes.unwrap();

    let module_opt = move_std::move_vm::file_format::CompiledModule::deserialize(&bytes);
    assert!(module_opt.is_ok(), 102);
    let module = module_opt.unwrap();

    // Verify module name matches expected (assuming 0xDEAD::Test module)
    let module_name_option = module.metadata().name();
    assert!(module_name_option.is_some(), 103);
    let module_name = module_name_option.unwrap();
    // Check that module name contains "Test"
    assert!(module_name.contains(b"Test"), 104);
}

// Validation function for address assignment strings

    fun validate_address_assignment_str(s: &vector<u8>): bool {
        let count_eq = 0;
        let i = 0;
        let len = vector::length(s);
        while (i < len) {
            if (*vector::borrow(s, i) == b'=') {
                count_eq = count_eq + 1;
            };
            i = i + 1;
        };
        // Valid if exactly one '=' character
        count_eq == 1
    }

    // Test cases
    let valid_str: vector<u8> = b"address=0x1234".to_vector();
    let invalid_str_no_equal: vector<u8> = b"address0x1234".to_vector();
    let invalid_str_multiple_equal: vector<u8> = b"addr==0x5678".to_vector();

    assert!(validate_address_assignment_str(&valid_str), 105);
    assert!(!validate_address_assignment_str(&invalid_str_no_equal), 106);
    assert!(!validate_address_assignment_str(&invalid_str_multiple_equal), 107);
}


// Featurres:
// 312e4630fd94dea2ace81bdc0229c624: Test that nested if-continue statements correctly interact with an outer loop, allowing the loop to break when the condition is false.
// 2b30b1d02d5a7dd1436a0503aacee40a: Deserialize a compiled Move module from a file.
// 38c8fed9c8f68f65a6ce8f0a9b4bc138:  Validate that the address assignment string is correctly formatted with exactly one '=' character.
