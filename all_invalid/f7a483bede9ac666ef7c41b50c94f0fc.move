
//# publish
module 0xBADD::LoopTest {
    use std::vector;
    use std::string;

    // Constant referencing another module's constant
    const MODULE_MAGIC: u32 = 0xCADE;
    const SOME_CONST: u64 = 12345;

    // A simple constant in this module
    const MY_CONST: u8 = 10;

    // Function to test reference to external constant constant with module qualification
    public fun get_module_magic(): u32 {
        MODULE_MAGIC
    }

    public fun get_some_const(): u64 {
        SOME_CONST
    }
}


//# run 0xBADD::LoopTest::get_module_magic

//# run 0xBADD::LoopTest::get_some_const


//# publish
module 0xBADD::LoopAndRef {
    use std::vector;

    // Function that performs a loop with empty body (for loop expression)
    public fun loop_with_empty_body() {
        let i = 0;
        for (i = 0; i < 5; i = i + 1) {
            // empty body
        };
        // verify loop executed, just for coverage
        assert!(i == 5, 0);
    }

    // Function that performs a loop with body accumulating sum
    public fun loop_with_body(): u32 {
        let sum = 0;
        let i = 0;
        for (; i < 3; i = i + 1) {
            sum = sum + i;
        };
        sum
    }

    // Function referencing a constant from another module
    public fun reference_external_constant(): u64 {
        // Access the external constant
        0xBADD::LoopTest::SOME_CONST
    }

    // Function demonstrating a loop with a break condition
    public fun loop_with_break(): u32 {
        let counter = 0;
        while (true) {
            if (counter >= 4) {
                break;
            };
            counter = counter + 1;
        };
        counter
    }
}


//# run 0xBADD::LoopAndRef::loop_with_empty_body

//# run 0xBADD::LoopAndRef::loop_with_body

//# run 0xBADD::LoopAndRef::reference_external_constant

//# run 0xBADD::LoopAndRef::loop_with_break

// Featurres:
// cdcdafb2e2568672a036eadd1b1179b2: Use address specifier 'Literal' to specify a concrete address directly.
// e41df40c11331f9327feead28ff6e8d1: Reference constants with optional module qualification.
// 90b396f0cda421632ed164532a7cc258: Create loop expressions with optional bodies.
