
//# run
script {
    // Evaluate variable scope, shadowing, and loop behavior
    let x: u8 = 0;
    let counter: u8 = 0;
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

    // Try to call internal_func directly outside module (should FAIL if uncommented)
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

    public fun main() {
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


// Featurres:
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 0a38877e9df2d5e826a5ae54b1bf6abf: Convert scripts into modules when the experiment for attaching compiled modules is enabled.
// e1b3992c50b1d1b0ea6c1022cd2610ef: Test that assigning a local copy of a struct and then modifying a field through a mutable reference affects the original struct as expected, and that the correct field value is returned.
