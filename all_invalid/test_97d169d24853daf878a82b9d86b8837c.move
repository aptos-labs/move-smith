//# publish
module 0xDEADBEEF::TestModule {
    // Define a simple struct for testing struct return values
    struct StructExample has copy, drop {
        field1: u8,
        field2: u64,
    }

    // Function that returns a StructExample with specific values
    public fun create_struct(): StructExample {
        StructExample {
            field1: 42u8,
            field2: 9876543210u64,
        }
    }
}

//# run 0xDEADBEEF::TestModule::create_struct

//# publish
module 0xFEEDFACE::ConditionalModule {
    // Runner function to test conditional branching
    public fun run_conditional_test(): () {
        let condition_true = true;
        if (condition_true) {
            // Branch when condition is true
            return;
        } else {
            // Branch when condition is false
            return;
        }
    }
}

//# run 0xFEEDFACE::ConditionalModule::run_conditional_test

//# publish
module 0xBADDAD::InteractionTest {
    // Function to call the other module's create_struct and validate returned values
    public fun execute_and_validate(): StructExample {
        let result = 0xDEADBEEF::TestModule::create_struct();
        // Assume additional validation logic here (ignored as per instructions)
        result
    }
}

//# run 0xBADDAD::InteractionTest::execute_and_validate --signers 0xBADDAD
