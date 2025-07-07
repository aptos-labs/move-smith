// transactional_test.move
module 0x1::TransactionalTest {
    use 0x1::Debug;
    use 0x1::Vector;

    /// A simple function returning multiple values as a tuple.
    public fun return_multiple_values(): (u64, bool) {
        // Return a tuple with a number and a boolean.
        (42, true)
    }

    /// A function that creates a vector of u64 using Seq expression
    public fun create_sequence_vector(): vector<u64> {
        // Using Seq to create sequence of expressions for vector
        // Seq here means { expr1; expr2; expr3 }, but in Move, this is a block expression returning last expr
        // We'll simulate usage of a bunch of sequence items by combining multiple statements.
        
        // Build a vector using a sequence of pushes
        let mut v = Vector::empty<u64>();
        // Seq expression: each push is an expression in sequence
        {
            Vector::push_back(&mut v, 10);
            Vector::push_back(&mut v, 20);
            Vector::push_back(&mut v, 30);
        };
        v
    }

    /// This function tests that values returned from functions can be saved and reused properly.
    public fun use_function_return_multiple_times(): u64 {
        // Call function once and store in local
        let (x, flag) = return_multiple_values();

        // Use the locals multiple times:
        // e.g., multiply x by 2, and if flag is true, add 100, else add 0.
        let mut result = x * 2;
        if (flag) {
            result = result + 100;
        };

        // Use result multiple times on stack:
        // Compute result + result + x:
        let total = result + result + x;

        // Return total
        total
    }

    /// Test function that calls creating vector and using locals multiple times.
    public fun transactional_test_main(): u64 {
        // Create sequence vector
        let seq_vec = create_sequence_vector();

        // Check vector contents using Debug::print and sum them.
        let len = Vector::length(&seq_vec);
        let mut sum = 0u64;
        let mut i = 0;
        while (i < len) {
            let val = *Vector::borrow(&seq_vec, i);
            Debug::print(&val);
            sum = sum + val;
            i = i + 1;
        };

        // Use function that returns multiple values and reuse locals
        let total = use_function_return_multiple_times();

        // Sum the vector sum and total for final result
        sum + total
    }
}

// Transactional Test block 
script {
    use 0x1::TransactionalTest;

    fun main() {
        let final_result = TransactionalTest::transactional_test_main();
        // Just print the result, ensuring all features tested
        0x1::Debug::print(&final_result);
    }
}

// Featurres:
// 884d6f3be845aa12df3f53c251cc91b8: Define sequence items with expressions using `Seq`.
// 2a06a5c3c4311fb5835a792534913bac: Test that values returned from a function are properly saved to locals and managed on the stack when they must be used multiple times in subsequent operations.
// fd4b1b73077e99bf22a55a18ee5a78fa: Declare 'use' statements in modules to import members from other modules.
