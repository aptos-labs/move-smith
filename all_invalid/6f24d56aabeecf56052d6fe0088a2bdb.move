//# publish
module 0xCAFE::TestModule {
    // Test abort propagation and sequencing expressions
    public fun abort_propagation_test() {
        // This function will call another that aborts intentionally
        abort_once();
        // This line should be unreachable if abort_once aborts
        // (to verify abort propagation, we won't execute further)
    }

    fun abort_once() {
        abort 42; // abort with error code 42
        // code below should be unreachable
        // no code here
    }

    // Function with sequenced aborts and unreachable code
    public fun sequence_aborts() {
        abort 1;
        // The following code should be unreachable
        abort 2;
    }

    // Function with fallthrough after abort (should not execute further)
    public fun test_abort_sequence() {
        abort 99;
        // any code here is unreachable
    }
}

// Test variable assignment with 'Assign' expressions
public script {
    fun main() {
        let x = 10;
        // Assign new value to x
        let x = x + 5; // x should now be 15
        let y = *(&x); // dereference for assignment if needed
        // For demonstration, store values in local variables
        // but in Move, variables are immutable unless reassigned
        // The above assignments are for static testing
    }
}

// Test parsing individual access specifiers within list (simulate with struct and access)
module 0xCAFE::AccessSpecifiers {
    struct Example {
        pub public_field: u64,
        private_field: u64,
    }

    public fun test_access() {
        // Create example instance
        let example = Example { public_field: 1, private_field: 2 };
        // Access public field (should succeed)
        let _a = example.public_field;
        // Access private field: no direct access outside module
        // So, need to provide a public function
    }

    public fun get_private_field(e: &Example): u64 {
        e.private_field
    }
}

// Additional test: check negation and constructor parameter parsing
module 0xCAFE::ParserTest {
    // Dummy struct with parameters
    struct Params {
        flag: bool,
        count: u64,
    }

    // Constructor function
    public fun new_params(flag: bool, count: u64): Params {
        Params { flag, count }
    }

    // Function to test parsing constructor with negation
    public fun parse_params() {
        let flag_value = false;
        let count_value = 100;

        // Simulate negation in parsing
        let negated_flag = !flag_value; // should be true
        let params = new_params(negated_flag, count_value);

        // Access fields
        let _flag_field = params.flag; // true
        let _count_field = params.count; // 100
    }

    // Simulate assignment with different access specifiers
    public fun assign_access_specifiers() {
        let private_value = 7;
        // For illustration: assign to a variable with constructor
        let constructor_param = private_value; // in explicit parsing, simulate with manually assigned value
        // No actual syntax for 'negation' in move assignment not supported directly
        // include for test completeness
    }
}

// Run the tests
//# run 0xCAFE::TestModule::abort_propagation_test
//# run 0xCAFE::TestModule::sequence_aborts
//# run 0xCAFE::TestModule::test_abort_sequence
//# run 0xCAFE::AccessSpecifiers::test_access
//# run 0xCAFE::AccessSpecifiers::get_private_field --signers 0xCAFE --args
//# run 0xCAFE::ParserTest::parse_params
//# run 0xCAFE::ParserTest::assign_access_specifiers

// Featurres:
// 0dbce85205ae1679273cb52846e30321: Test that abort propagation and sequencing expressions correctly handle aborts and unreachable code in Move functions.
// f4e30cc9e9519cf1b7ee32cdb8f66aa8: Assign values to variables with `Assign` expressions.
// e7e1b7f3526f987faa22de0e1db0cc94: Parse individual access specifiers within the list, considering negation and constructor parameters.
