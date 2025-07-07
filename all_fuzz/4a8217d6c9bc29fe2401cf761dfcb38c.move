
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum // return the sum
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}




//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_adder(x: u8, y: u8): u8 {
        // call inline function from AdditionModule
        let sum = AdditionModule::inline_adder(x, y);
        sum
    }
}




//# publish
module 0xCAFE::LogicShortCircuitModule {
    public fun test_and_operator(x: bool, y: bool): bool {
        // abort 1 if right side evaluated and false
        // left false means right not evaluated
        if (x && (if (!y) { abort 1 } else { true })) {
            true
        } else {
            false
        };
        // Return the input x after testing
        x
    }

    public fun test_or_operator(x: bool, y: bool): bool {
        // abort 2 if right side evaluated and false
        // left true means right not evaluated
        if (x || (if (!y) { abort 2 } else { true })) {
            true
        } else {
            false
        };
        // Return the input x after testing
        x
    }
}




//# publish
module 0xCAFE::VariableAssignModule {
    public fun assign_and_reassign(): u8 {
        let mut_val = 5u8;
        let mut_val = mut_val + 10u8;
        // just to test reassign works, multiple bindings with same name is allowed
        let mut_val = mut_val + 3u8;
        mut_val
    }
}




//# run 0xCAFE::AdditionModule::add_and_return_sum --args 7u8 8u8




//# run 0xCAFE::AdditionModule::with_lambda --args 6u8 12u8




//# run 0xCAFE::NestedCallModule::call_inline_adder --args 10u8 15u8




//# run 0xCAFE::LogicShortCircuitModule::test_and_operator --args false true




//# run 0xCAFE::LogicShortCircuitModule::test_and_operator --args true true




//# run 0xCAFE::LogicShortCircuitModule::test_or_operator --args true false




//# run 0xCAFE::LogicShortCircuitModule::test_or_operator --args false true




//# run 0xCAFE::VariableAssignModule::assign_and_reassign
