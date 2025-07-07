//# publish
module 0xA11C::BooleanVectorTests {
    const B0: vector<bool> = vector[];
    const B1: vector<bool> = vector[true];
    const B2: vector<bool> = vector[true || false];
    const B3: vector<bool> = vector[true, false && true, true == true];

    const E0: bool = vector<u8>[] == vector[];
    const E1: bool = vector[1, 2]] == vector[100, 200];

    const BoolVec1: vector<bool> = vector[true, false, true];
    const BoolVec2: vector<bool> = vector[false, false];

    fun validate_bools() {
        assert!(vector[true || false, false && true, true == true] == BoolVec1, 0);
        assert!(vector[false, false] == BoolVec2, 0);
        assert!(!vector[true] != vector[false], 0);
    }
}

//#run 0xA11C::BooleanVectorTests::validate_bools