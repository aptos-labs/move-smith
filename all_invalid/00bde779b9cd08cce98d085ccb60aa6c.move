
//# publish
module 0xBADD::LoopTest {
    use std::vector; // Warning: unused, but keeping for consistency
    use std::string; // Warning: unused, but keeping for now

    // Constant referencing another module's constant
    const MODULE_MAGIC: u32 = 0xCADE;
    const SOME_CONST: u64 = 12345;

    // A simple constant in this module
    const MY_CONST: u8 = 10;

    // Function to test reference to external constant with module qualification
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
        // Corrected for loop syntax: move the init into a variable, then use a while loop
        let i_local = 0;
        while (i_local < 5) {
            i_local = i_local + 1;
        };
        // verify loop executed, just for coverage
        assert!(i_local == 5, 0);
    }

    // Function that performs a loop with body accumulating sum
    public fun loop_with_body(): u32 {
        let sum = 0;
        let i = 0;
        while (i < 3) {
            sum = sum + i;
            i = i + 1;
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