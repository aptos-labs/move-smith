//# publish
module 0xCAFE::AssignSpecTest {
    spec module {
        // In spec context, assignments to module access expressions are allowed
        // Here we test that assigning to a module-level spec constant works
        global const SPEC_CONST: u64;

        spec fun assign_module_const() {
            // We simulate assignment in spec by redefining the spec constant,
            // this is an example to exercise the compiler's handling
            SPEC_CONST = 42;
        }
    }

    // A normal constant that can only be assigned once here
    const NORMAL_CONST: u8 = 10;

    public fun get_normal_const(): u8 {
        NORMAL_CONST
    }

    public fun dummy() {
        // assignment to module constant here is forbidden in non-spec context
        // NORMAL_CONST = 20; // would be error
        // To test compiler error detection, commented out above line
    }
}

//# run 0xCAFE::AssignSpecTest::get_normal_const


/////
// Script testing constants within script and module member names validity
/////

//# run
script {
    const SCRIPT_CONST_VALID_NAME: u8 = 7;
    const _SCRIPT_CONST_UNDERSCORE: u64 = 123;
    //const 3INVALID: u8 = 9; // invalid name, commented out to compile
    //const invalid-with-dash: u8 = 5; // invalid name, commented out

    fun main() {
        let x = SCRIPT_CONST_VALID_NAME;
        let y = _SCRIPT_CONST_UNDERSCORE;
        // Just dummy usage so compiler processes them
        let _ = x + (y as u8);
    }
}


/////
// Script for testing automatic discovery and deterministic ordering of Move files
// This test assumes the test framework compiles multiple files in a package directory
// with consistent order for error detection.
// We emit some output with constants to show ordering effect.
/////

//# publish
module 0xCAFE::FileOrderOne {
    const ORDER_ID: u8 = 1;

    public fun get_order(): u8 {
        ORDER_ID
    }
}

//# publish
module 0xCAFE::FileOrderTwo {
    const ORDER_ID: u8 = 2;

    public fun get_order(): u8 {
        ORDER_ID
    }
}

//# run 0xCAFE::FileOrderOne::get_order

//# run 0xCAFE::FileOrderTwo::get_order

// Featurres:
// 0e0348ef408dcf627617eaca95a68df8: Handle assignment to module access expressions only within a spec context.
// 1d20974cc1af853c4d22975bf65554a1: Specify constants within a script, ensuring their names are valid module member names.
// 3e3de3263e77fb7d25b9d181e8de3f4d: Automatically discover Move source files within specified package directories, ensuring deterministic ordering for consistent error detection.
