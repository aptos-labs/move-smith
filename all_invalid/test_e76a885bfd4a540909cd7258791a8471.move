//# publish
module 0xA::TestModule {
    public fun error(): bool {
        abort 999
    }

    // A helper function to check overflow during casting to u8.
    public fun cast_u8(value: u128): bool {
        if (value > 255) {
            abort 998;
        }
        value as u8
    }

    // A helper function to check overflow during casting to u16.
    public fun cast_u16(value: u128): bool {
        if (value > 65535) {
            abort 997;
        }
        value as u16
    }

    // A helper function to check overflow during casting to u32.
    public fun cast_u32(value: u128): bool {
        if (value > 4294967295) {
            abort 996;
        }
        value as u32
    }
}

 //# run
script {
use 0xA::TestModule;

fun test_logical_short_circuit() {
    let called = false;

    // The error function should not be called because left operand is true.
    true || { 
        // This block should not run
        let _ = TestModule::error(); 
        called = true; 
    };
    assert!(!called, 100);
    
    // The error function should not be called because left operand is false, but right is true.
    false && { 
        // This block should not run
        let _ = TestModule::error(); 
        called = true; 
    };
    assert!(!called, 101);

    // Test with left operand true, right operand calling error; error should be skipped.
    true || {
        // Should not execute
        let _ = TestModule::error();
    };
    // Just to ensure code gets here without aborts
    assert!(true, 102);

    // Test with left operand false, right operand false
    false && {
        // Should not execute
        let _ = TestModule::error();
    };
    // Confirm success
    assert!(true, 103);
}
}

 //# run
script {
use 0xA::TestModule;

fun test_type_casting_behavior() {
    // Values within range
    assert!(
        TestModule::cast_u8(255),
        200,
        "Casting 255 to u8 should succeed"
    );
    assert!(
        TestModule::cast_u16(65535),
        201,
        "Casting 65535 to u16 should succeed"
    );
    assert!(
        TestModule::cast_u32(4294967295),
        202,
        "Casting 4294967295 to u32 should succeed"
    );

    // Values at boundary
    assert!((TestModule::cast_u8(0)), 203, "0 as u8");
    assert!((TestModule::cast_u16(0)), 204, "0 as u16");
    assert!((TestModule::cast_u32(0)), 205, "0 as u32");
    assert!((TestModule::cast_u8(255)), 206, "Max u8");
    assert!((TestModule::cast_u16(65535)), 207, "Max u16");
    assert!((TestModule::cast_u32(4294967295)), 208, "Max u32");

    // Overflow checks - should abort
    // Using 'do' block to catch abort errors
    do {
        // Should abort
        TestModule::cast_u8(256);
        assert!(false, 300, "Overflow test for u8 did not abort");
    } catch (abort) {
        // expected
    }

    do {
        // Should abort
        TestModule::cast_u16(65536);
        assert!(false, 301, "Overflow test for u16 did not abort");
    } catch (abort) {
        // expected
    }

    do {
        // Should abort
        TestModule::cast_u32(4294967296);
        assert!(false, 302, "Overflow test for u32 did not abort");
    } catch (abort) {
        // expected
    }
}
}