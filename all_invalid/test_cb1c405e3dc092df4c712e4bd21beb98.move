//# publish
module 0xAABB::ConstantsRefMut {
    // Define some constants for testing
    const MAX_U8: u8 = 255;
    const MESSAGE: vector<u8> = b"test message";

    // Function to test references and no mutation of constants
    public fun check_constants() {
        // Verify constants hold expected values
        assert!(MAX_U8 == 255, 101);
        assert!(MESSAGE == b"test message", 102);

        // Borrow references to constants
        let ref_max = &MAX_U8;
        let ref_msg = &MESSAGE;
        // Verify referencing constants does not mutate
        assert!(*ref_max == 255, 103);
        assert!(*ref_msg == b"test message", 104);
    }

    // Function to test mutable borrows behavior on local variables
    public fun mutate_local() {
        let mut counter: u64 = 10;
        let ref_mut_counter = &mut counter;
        *ref_mut_counter = *ref_mut_counter + 5; // mutate local variable through reference
        assert!(counter == 15, 105);
    }

    // Runner function for testing references and mutability
    public fun run_checks() {
        check_constants();
        mutate_local();
    }
}

//# run 0xAABB::ConstantsRefMut::run_checks

//# publish
module 0x123::BooleanLogic {
    // Function that updates a local variable based on logical expressions involving inputs
    public fun evaluate(a: bool, b: bool): u64 {
        let result: u64 = 0;
        let mut temp_x: u64 = 1; // initialize local variable

        // perform logical AND operation; if true, multiply x by 4
        if (a && true) {
            temp_x = temp_x * 4;
        } else {
            temp_x = temp_x * 2; // fallback
        }

        // perform logical OR operation; if true, multiply x by 6
        if (b || false) {
            temp_x = temp_x * 6;
        } else {
            temp_x = temp_x * 3; // fallback
        }

        temp_x
    }
}

//# run
script {
use 0x123::BooleanLogic;

fun main() {
    assert!(BooleanLogic::evaluate(false, false) == 12, 106); // (a && true)?: 1*2*6=12
    assert!(BooleanLogic::evaluate(false, true) == 24, 107);  // (a && true)?:2*6=12*2=24
    assert!(BooleanLogic::evaluate(true, false) == 24, 108);  // (a && true)?:1*4*6=24
    assert!(BooleanLogic::evaluate(true, true) == 24, 109);   // (a && true)?:1*4*6=24 (a true, b true)
}
}

 //# publish
module 0xC0DE::Counter {
    // Function to test multiple calls to a mutable increment function
    public fun inc(x: &mut u64): u64 {
        *x = *x + 1;
        *x
    }

    // Function that calls inc multiple times and verifies correct updates
    public fun test_increment(): u64 {
        let mut counter: u64 = 0;
        let first = inc(&mut counter); // counter = 1
        let second = inc(&mut counter); // counter = 2
        let third = inc(&mut counter); // counter = 3
        first + second + third // should be 1+2+3=6
    }
}

//# run 0xC0DE::Counter::test_increment