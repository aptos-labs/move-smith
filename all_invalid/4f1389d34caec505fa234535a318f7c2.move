
//# publish
module 0xBADD::ChoiceQuantifiers {
    // Declare choice quantifiers with 'choose' and 'min' specifications
    // These are just function signatures to test parser recognition
    public fun choose_max_u8(): u8 {
        255u8
    }

    public fun choose_min_u8(): u8 {
        0u8
    }

    public fun choose_max_u16(): u16 {
        65535u16
    }

    public fun choose_min_u16(): u16 {
        0u16
    }

    // Declare a function with 'min' annotation inside the module
    // This is to check if 'min' is recognized as a special keyword
    public fun find_min_u8(): u8 {
        choose min u8;
        0u8
    }

    // A function that uses 'choose' to select a value
    public fun select_value(condition: bool): u8 {
        if (condition) {
            choose 10u8
        } else {
            choose 20u8
        }
    }
}


//# publish
address 0xFEED {
    // Inside an address block, declare a module named 'SenderModule'
    module 0xFEED::SenderModule {
        // Declare a specification function
        public fun verify_choice_u8(val: u8): bool {
            val <= 255u8
        }

        // Declare a native function (not implemented here, just declaration)
        native fun native_spec_function() acquires sender;

        // Declare a function that calls external spec functions
        public fun run_specifications() {
            assert!(verify_choice_u8(choose 100u8), 1);
            // Call native function (mock, no effect)
            native_spec_function();
        }
    }
}


//# run 0xBADD::ChoiceQuantifiers::choose_max_u8


//# run 0xBADD::ChoiceQuantifiers::choose_min_u8


//# run 0xBADD::ChoiceQuantifiers::choose_max_u16


//# run 0xBADD::ChoiceQuantifiers::choose_min_u16


//# run 0xBADD::ChoiceQuantifiers::find_min_u8


//# run 0xBADD::ChoiceQuantifiers::select_value --args true


//# run 0xFEED::SenderModule::run_specifications --signers 0xDEAD


// Featurres:
// 7d659b239afc3a6eb1b7ff0ac8f5c922: Declare choice quantifiers using the syntax 'choose' and specify whether to select minimal elements with 'min'.
// ff0e1ae15b3f12bb2b442c47cdeae366: Declare a module inside an 'address <address> { ... }' block to assign the sender address.
// f5aa7ac54063febf350e6a0e16c6871d: Create specification functions with the `fun` or `native` keywords.
