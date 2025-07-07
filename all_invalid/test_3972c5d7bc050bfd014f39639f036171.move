//# publish
module 0x99::BooleanByteVectorTests {
    // Constants with various boolean vectors
const B_FALSE: vector<bool> = vector[];
const B_TRUE: vector<bool> = vector[true];
const B_MIXED: vector<bool> = vector[true, false, true && false];
const B_COMPLEX: vector<bool> = vector[false, true || false, true == (3 - 3)];

// Constants comparing empty and non-empty byte vectors
const EMPTY_BYTES: vector<u8> = vector[];
const NON_EMPTY_BYTES: vector<u8> = vector[10, 20, 30];

const E_EMPTY_NEQ: bool = vector[] != vector[1, 2];
const E_EMPTY_EQ: bool = vector[] == vector[];
const E_NONEMPTY_EQ: bool = vector[50, 60] == vector[50, 60];
const E_NONEMPTY_NEQ: bool = vector[1, 2, 3] != vector[4, 5, 6];

// Complex nested vector example
const NESTED_VECTOR: vector<vector<u8>> = vector[
    vector[1, 2],
    vector[3, 4, 5]
];

// Function to check logical operators and vector comparisons
public fun validate() {
    // Check boolean vector constructions and logical expressions
    assert!([true] == B_TRUE, 0);
    assert!([false] == B_FALSE, 0);
    assert!([true, false, false] == B_MIXED, 0);
    assert!([false, true || false, true == (3 - 3)] == B_COMPLEX, 0);

    // Check equality/inequality between empty and non-empty byte vectors
    assert! (vector[] != vector[1], 0);
    assert! (vector[] == vector[], 0);
    assert! (vector[50, 60] == vector[50, 60], 0);
    assert! (vector[1, 2, 3] != vector[4, 5, 6], 0);

    // Validate nested vector structure
    assert! (vector[vector[1, 2], vector[3, 4, 5]] == NESTED_VECTOR, 0);
}
}

//#run 0x99::BooleanByteVectorTests::validate