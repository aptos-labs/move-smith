//# publish
module 0x1::VariableAssignmentTest {
    // A helper function to perform variable assignment inside an if statement
    public fun update_variable_in_if() {
        let mut x = 10;
        if (x > 5) {
            x = 20;
        } else {
            x = 5;
        }
        x
    }

    // A helper function to perform variable assignment inside nested if statements
    public fun nested_if_assignment() {
        let mut y = 0;
        if (true) {
            if (false) {
                y = 1;
            } else {
                y = 2;
            }
        } else {
            y = 3;
        }
        y
    }

    // A helper function to test the assignment with a false condition
    public fun assignment_with_false_condition() {
        let mut z = 100;
        if (false) {
            z = 50;
        }
        z
    }
}

//# run
script {
    fun main() {
        // Call the function that updates variable inside an if statement
        0x1::VariableAssignmentTest::update_variable_in_if();
        // Call the nested if assignment function
        0x1::VariableAssignmentTest::nested_if_assignment();
        // Call the assignment with false condition
        0x1::VariableAssignmentTest::assignment_with_false_condition();
    }
}