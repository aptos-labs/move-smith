
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 for known output
        sum + 10
    }

    public fun lambda_test(value: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = adder(value, 1u8);
        result
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 5u8 7u8


//# run 0xCAFE::AddModule::lambda_test --args 10u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddModule;

    public inline fun call_add_and_double(a: u8, b: u8): u8 {
        let sum = AddModule::add_two_values(a, b);
        sum * 2
    }
}


//# run 0xCAFE::InlineCaller::call_add_and_double --args 3u8 4u8


//# publish
module 0xCAFE::IntervalDebugger {
    use std::string;
    use std::vector;

    public fun generate_live_interval_string(): vector<u8> {
        let events = vector[
            b's', // start
            b'L', // live
            b'E', // end
        ];
        events
    }
}


//# run 0xCAFE::IntervalDebugger::generate_live_interval_string


//# publish
module 0xCAFE::SelfAssignTest {
    public fun self_assign_branch(x: u8, cond: bool): u8 {
        let a = x;

        if (cond) {
            a = a;
        } else {
            a = a;
        };

        a
    }
}


//# run 0xCAFE::SelfAssignTest::self_assign_branch --args 20u8 true


//# run 0xCAFE::SelfAssignTest::self_assign_branch --args 20u8 false


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4c58d7885ded84952dba85ff5adf684b: Generate a string representation of live interval events for debugging or analysis
// f0a90e1b880f018d7976fefd57824345: Test that assigning a variable to itself multiple times within different branches of an if-else statement does not affect the function’s correctness or return value.
