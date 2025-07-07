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

//# run
script {
    fun main() {
        let s = 0xCAFE::DeprecationTest::create_struct(42, 100);
        // Access deprecated member directly
        let val1 = 0xCAFE::DeprecationTest::get_value1(&s);
        // Access non-deprecated member
        let val2 = 0xCAFE::DeprecationTest::get_value2(&s);
        // Access deprecated member via imported module
        let val3 = 0xCAFE::ImportingModule::access_deprecated_member(&s);
    }
}

//# publish
module 0xCAFE::VariableReassignment {
    // Variables in Move are mutable by default, but for clarity, we can declare them as mutable.
    // We'll test reassignment order and correctness within conditional branches.

    // Function to test reassignments in branches
    public fun reassign_in_branches(input: u64): u64 {
        let result = 0;
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
        let x = input1;
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
        // Test reassignments within branches
        let res1 = 0xCAFE::VariableReassignment::reassign_in_branches(10);
        let res2 = 0xCAFE::VariableReassignment::reassign_in_branches(60);
        let res3 = 0xCAFE::VariableReassignment::reassign_in_branches(55);
        // Test multiple reassignments with different inputs
        let val1 = 0xCAFE::VariableReassignment::multiple_reassignments(70, 5);
        let val2 = 0xCAFE::VariableReassignment::multiple_reassignments(30, 15);
        let val3 = 0xCAFE::VariableReassignment::multiple_reassignments(20, 25);
    }
}

// Featurres:
// b2a04f5a0e0ae5a6de09d743766345e2: Receive deprecation warnings in the Move compiler when using members tagged as deprecated in either the same module or from an imported module.
// dd5ae49180662dd16ec747e5d90fd681: Write Move source files that can include file-level comments matched to code definitions.
// 1e412a57ffc70a3d7841548f2d8239b5: Test that variables reassigned in multiple conditional branches within a single expression are evaluated in the correct order and produce the expected result.
