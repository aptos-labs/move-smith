
//# run
script {
    // Evaluate variable scope, shadowing, and loop behavior
    let x: u8 = 0;
    let counter: u8 = 0; // 'counter' needs to be mut for mutation
    while (counter < 3) {
        let x: u8 = counter; // Shadow outer x
        assert!(x == counter, 900 + counter as u64); // Confirm shadowed x
        counter = counter + 1;
    };
    // After loop, check that outer x remains unchanged
    assert!(x == 0, 901); // Outer x should still be 0
}


//# run
script {
    // Define and test internal functions' accessibility

//# publish
module 0xBADD::InternalTest {
    fun internal_func(): u64 {
        42
    }

    public fun call_internal(): u64 {
        internal_func()
    }
}

// Call internal function via public wrapper (should succeed)
let result = 0xBADD::InternalTest::call_internal();
assert!(result == 42, 910);

// Try to call internal_func directly outside module (should fail if uncommented)
// let _ = 0xBADD::InternalTest::internal_func(); // Should be inaccessible here

}


//# run
script {
    // Convert a script into a module with internal functions and verify usage

//# publish
module 0xC0DE::ConversionTest {
    fun internal_add(a: u64, b: u64): u64 {
        a + b
    }

    public fun use_internal_add(a: u64, b: u64): u64 {
        internal_add(a, b)
    }
}

// Call the module function, should work fine
let sum = 0xC0DE::ConversionTest::use_internal_add(10, 20);
assert!(sum == 30, 920);
}


//# run
script {
    // Clone a struct, modify it, and check changes
    struct Data has copy, drop, store {
        value: u64
    }

    fun main(): u64 {
        let original = Data { value: 123 };
        // Clone to a local variable
        let clone = copy original;
        // Mutate clone
        clone.value = 999;

        // Assert original remains unchanged
        assert!(original.value == 123, 930);
        // Assert clone has new value
        assert!(clone.value == 999, 931);
        // Return the mutated value as final expression
        clone.value
    }
}
