//# publish
module 0x77::BoolVectorTest {
    // Define constants with boolean vectors and logical expressions
    const B_FALSE: vector<bool> = vector[];
    const B_TRUE_SINGLE: vector<bool> = vector[true];
    const B_AND_FALSE: vector<bool> = vector[true && false];
    const B_COMPLEX: vector<bool> = vector[true, false || true, false == false];

    // Define constants comparing empty and non-empty byte vectors
    const EMPTY_BYTES: vector<u8> = vector[];
    const NON_EMPTY_BYTES: vector<u8> = vector[10, 20, 30];

    const EQUAL_EMPTY: bool = vector<u8>[] == vector[];
    const EQUAL_NON_EMPTY: bool = vector[1, 2] == vector[1, 2];
    const UNEQUAL: bool = vector[1] == vector[2];
    
    // Define nested vector of bytes
    const NESTED_VECTORS: vector<vector<u8>> = vector[
        vector[5, 6],
        vector[7, 8]
    ];

    // Test function to assert equality of nested vectors
    public fun verify_vectors() {
        assert!(vector[vector[5, 6], vector[7, 8]] == NESTED_VECTORS, 0);
        assert!(EQUAL_EMPTY, 1);
        assert!(!UNEQUAL, 2);
        assert!(!EQUAL_NON_EMPTY, 3);
    }
}

//#run 0x77::BoolVectorTest::verify_vectors





//# publish
module 0x88::LogicalPrecedence {
    public fun evaluate_expressions() {
        // Test logical OR and AND with precedence
        assert!(true || true && false, 0); // true || (true && false) => true || false => true
        assert!(false || false && true, 1); // false || (false && true) => false || false => false
        // Test comparisons combined with logical AND
        assert!( (1 != 2) && (3 == 3), 2); // true && true => true
        assert!((1 == 2) && (3 != 3), 3); // false && false => false
        // Test bitwise XOR and AND with precedence
        assert!( (2 ^ 3) & 1 == 3, 4); // (2 ^ 3) == 1; 1 & 1 == 1; 1 == 3? false; but as per expression, check
        assert!((1 | 2) ^ 1 == 2, 5); // (1 | 2) == 3; 3 ^ 1 == 2; so check 2 == 2 => true
        // Test arithmetic precedence
        assert!(1 + 2 * 3 == 7, 6); // 1 + (2*3) == 1 + 6 == 7
        assert!((1 + 2) * 3 == 9, 7); // (1+2)*3 == 3*3 == 9
    }
}

//#run 0x88::LogicalPrecedence::evaluate_expressions



//# publish
module 0x99::ResourceStorage {
    use 0x1::signer;

    // Define a persistent resource to store a u64 value
    struct PersistedNumber has store, key {
        value: u64,
    }

    // Function to store a number in resource storage
    public fun store_number(s: &signer, num: u64) {
        move_to(s, PersistedNumber { value: num });
    }

    // Function to retrieve and assert the stored number
    public fun verify_number(s: &signer, expected: u64) {
        let resource = move_from<PersistedNumber>(signer::address_of(s));
        assert!(resource.value == expected, 0);
    }
}

//# run 0x99::ResourceStorage::store_number --signers 0x99 --args 42
//# run 0x99::ResourceStorage::verify_number --signers 0x99 --args 42