//# publish
module 0xAABBCC::test_module {
    // Define constants with bit-shifted values
    const HIGH_BIT: u16 = 1 << 15; // 32768
    const LOW_BIT: u16 = 1 >> 3;   // 0

    // Define a function to verify the sum of shifted constants
    public fun sum_constants(): u16 {
        HIGH_BIT + LOW_BIT
    }

    // Define a runner function to test the constants
    public fun run_tests() {
        let result = sum_constants();
        assert!(result == 32768, 100);
    }
}

 //# run 0xAABBCC::test_module::run_tests --signers 0xAABBCC

//# run
script {
    // Initialize a variable
    let mut flag = false;
    // Loop condition set to false; loop body should not execute
    while (flag) {
        flag = true; // This line should never run
    }
    // After loop, verify the variable remains false
    assert!(!flag, 101);
}