//# publish
module 0xA::VectorTests {
    struct S { value: u64 }

    // Function to create an empty vector of the struct S
    public fun create_empty_struct_vector(): vector<S> {
        vector[]
    }

    // Function to create an empty vector of address (signers)
    public fun create_empty_signer_vector(): vector<address> {
        vector[]
    }

    // Generic function to create an empty vector of any type T
    public fun create_empty_generic_vector<T>(): vector<T> {
        vector[]
    }

    // Function to create nested vectors of structs
    public fun create_nested_struct_vectors(): vector<vector<S>> {
        vector[]
    }

    // Function to create nested vectors of signers
    public fun create_nested_signer_vectors(): vector<vector<address>> {
        vector[]
    }

    // Generic function for nested vector of type T
    public fun create_nested_generic_vectors<T>(): vector<vector<T>> {
        vector[]
    }

    // Runner functions for each of the above to facilitate testing via script commands
    public fun run_create_empty_struct_vector(): vector<S> {
        Self::create_empty_struct_vector()
    }

    public fun run_create_empty_signer_vector(): vector<address> {
        Self::create_empty_signer_vector()
    }

    public fun run_create_empty_generic_vector<T>(): vector<T> {
        Self::create_empty_generic_vector<T>()
    }

    public fun run_create_nested_struct_vectors(): vector<vector<S>> {
        Self::create_nested_struct_vectors()
    }

    public fun run_create_nested_signer_vectors(): vector<vector<address>> {
        Self::create_nested_signer_vectors()
    }

    public fun run_create_nested_generic_vectors<T>(): vector<vector<T>> {
        Self::create_nested_generic_vectors<T>()
    }
}

//# run 0xA::VectorTests::run_create_empty_struct_vector --signers 0x1 --args
//# run 0xA::VectorTests::run_create_empty_signer_vector --signers 0x1 --args
//# run 0xA::VectorTests::run_create_empty_generic_vector --signers 0x1 --args --type-args 0xA::VectorTests::S
//# run 0xA::VectorTests::run_create_nested_struct_vectors --signers 0x1 --args
//# run 0xA::VectorTests::run_create_nested_signer_vectors --signers 0x1 --args
//# run 0xA::VectorTests::run_create_nested_generic_vectors --signers 0x1 --args --type-args 0xA::VectorTests::S

//# run
script {
    fun main(): () {
        // Testing that the for loop iterates correctly from 0 to 10
        let sum = 0;
        for (i in 0..10) {
            sum = sum + i;
        };
        assert!(sum == 55, 0); // sum of numbers 0 to 10 is 55
    }
}

//# run
script {
    fun main() {
        // Testing labeled continue with nested loops
        let total = 0;
        'outer: while (true) {
            let inner_counter = 0;
            'inner: while (true) {
                if (inner_counter >= 5) {
                    // break inner loop
                    break 'inner;
                }
                total = total + 1;
                inner_counter = inner_counter + 1;
                if (inner_counter == 3) {
                    // continue outer loop after some inner iteration
                    continue 'outer;
                }
            }
            // After inner loop completes, break outer loop
            break;
        }
        // total should be 3 (when inner_counter==2) plus the counts after continue, should sum to 3+ (rest of iterations)
        // But since we break after first outer, total should be 3
        assert!(total == 3);
    }
}

// The above code covers the following:
   // - Testing creation and return of empty vectors of structs, signers, and generics, including nested vectors
   // - Testing iteration over range 0..10
   // - Testing nested loops with labeled continue that affects control flow
   // - Combining the features in new ways to ensure interaction correctness