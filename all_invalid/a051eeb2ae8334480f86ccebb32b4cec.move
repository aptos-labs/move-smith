//# publish
module 0xCAFE::DeprecationTest {
    // Tagging a member as deprecated is simulated by a comment,
    // since Move itself doesn't have deprecation attributes.
    // However, we can test for the compiler warning if such annotations are supported
    // or simply include comments to simulate deprecated members.

    // Define a struct with a "deprecated" member
    struct MyStruct {
        // Simulate deprecated member with comment
        // DEPRECATED: use `value2` instead
        value1: u64,
        value2: u64,
    }

    // A function to access deprecated member
    public fun get_value1(s: &MyStruct): u64 {
        s.value1
    }

    // A function to access the non-deprecated member
    public fun get_value2(s: &MyStruct): u64 {
        s.value2
    }

    // Function to create and set values for the struct
    public fun create_struct(val1: u64, val2: u64): MyStruct {
        MyStruct {
            value1: val1,
            value2: val2,
        }
    }
}

//# publish
module 0xCAFE::ImportingModule {
    // Import the above module
    use 0xCAFE::DeprecationTest;

    // Function to access deprecated member from imported module
    public fun access_deprecated_member(s: &DeprecationTest::MyStruct): u64 {
        // This should generate a deprecation warning if such linter exists
        // For simulation, just access the member
        DeprecationTest::get_value1(s)
    }
}

//# publish
module 0xCAFE::VariableReassignment {
    // Variables in Move are mutable by default, but for clarity, we can declare them as mutable.
    // We'll test reassignment order and correctness within conditional branches.

    // Function to test reassignments in branches
    public fun reassign_in_branches(input: u64): u64 {
        let mut result = 0;
        if (input % 2 == 0) {
            result = 10;
        } else {
            result = 20;
        }

        // Reassign again based on a different condition
        if (input > 50) {
            result = 100;
        } else {
            result = 200;
        }
        result
    }

    // Function to test multiple reassignment paths
    public fun multiple_reassignments(input1: u64, input2: u64): u64 {
        let mut x = input1;
        if (x > 50) {
            x = input2;
        } else {
            x = input1 + input2;
        }

        // Reassign all paths
        if (x % 2 == 0) {
            x = x + 1;
        } else {
            x = x + 2;
        }
        x
    }
}

//# run
script {
    fun main() {
        // Create a struct instance
        let s = 0xCAFE::DeprecationTest::create_struct(42, 100);
        // Access deprecated member directly
        let val1 = 0xCAFE::DeprecationTest::get_value1(&s);
        // Access non-deprecated member
        let val2 = 0xCAFE::DeprecationTest::get_value2(&s);
        // Access deprecated member via imported module
        let val3 = 0xCAFE::ImportingModule::access_deprecated_member(&s);
        // Optionally, just use the variables to avoid unused warnings
        let _ = val1;
        let _ = val2;
        let _ = val3;
    }
}

//# publish
// No changes needed for the other modules; ensure no syntax errors

// Define the reassignments module as above
// Already published in the previous block

//# run
script {
    fun main() {
        // Test reassignments within branches
        let res1 = 0xCAFE::VariableReassignment::reassign_in_branches(10);
        let res2 = 0xCAFE::VariableReassignment::reassign_in_branches(60);
        let res3 = 0xCAFE::VariableReassignment::reassign_in_branches(55);
        // Test multiple reassignments with different inputs
        let val1 = 0xCAFE::VariableReassignment::multiple_reassignments(70, 5);
        let val2 = 0xCAFE::VariableReassignment::multiple_reassignments(30, 15);
        let val3 = 0xCAFE::VariableReassignment::multiple_reassignments(20, 25);
        // Optionally, use the variables to avoid unused warnings
        let _ = res1;
        let _ = res2;
        let _ = res3;
        let _ = val1;
        let _ = val2;
        let _ = val3;
    }
}