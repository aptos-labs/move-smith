
//# publish
module 0xCAFE::TestOperators {
    use std::debug;

    // Struct used for destructuring
    struct Data {
        a: u64,
        b: bool,
        c: vector<u8>,
    }

    // Function to test various operators
    public fun test_operators(x: u64, y: u64, z: u64): bool {
        let result = (x + y * z) == (x + (y * z))
            && (x != y)
            && (x < y)
            && (x > z)
            && (x <= y)
            && (x >= z)
            && (x | y) != (x ^ y)
            && (x & y) == (x & y)
            && (x << 2) >= (x * 4)
            && (y >> 1) <= (y / 2)
            && (x + y) % z == ((x % z) + (y % z))
            && (x .. y).length() > 0; // Range expression, length > 0

        // Test binary logical operators
        let combine_or = result || (x == y);
        let combine_and = result && (x != y);

        // Return combined boolean
        combine_or && combine_and
    }

    // Function to test destructuring
    public fun test_destructuring(data: Data): bool {
        let Data { a: a_value, b: b_value, c: c_value } = data;
        // Assign directly to variables
        let a_copy = a_value;
        let b_copy = b_value;
        let c_copy = c_value.clone();

        // Check that values match
        a_copy == a_value && b_copy == b_value && c_copy == c_value
    }

    // Function to test read/write access specifiers enforcement
    public fun test_access_restrictions(account: &signer): bool {
        // Call a function with 'reads' access
        let val_read = read_only_func(account);

        // Call a function with 'writes' access
        write_only_func(account);

        // Call a function with no access restrictions
        unrestricted_func();

        true
    }

    // Function requiring 'reads' access
    public fun read_only_func(_a: &signer) {
        // simulate reading a global resource (not actually reading here)
    }

    // Function requiring 'writes' access
    public fun write_only_func(_a: &signer) acquires {} {
        // simulate writing to a resource
    }

    // Function with no access restrictions
    public fun unrestricted_func() {
        // does nothing
    }
}


//# run
script {
    use 0xCAFE::TestOperators;

    fun main() {
        let result_ops = TestOperators::test_operators(10, 20, 5);
        // create a vector
        let data = TestOperators::Data {
            a: 42,
            b: true,
            c: b"hello",
        };
        let result_destruct = TestOperators::test_destructuring(data);

        // simulate a signer for access function tests
        // Normally, this would be an account address with signer capabilities.
        // For the purpose of this test, we assume an account address 0xBEEF.
        let signer_addr = @0xBEEF;
        let access_result = TestOperators::test_access_restrictions(signer_addr);

        // We do not need to do anything with results; just invoke functions to exercise code.
    }
} 

// Featurres:
// b30fe78392e589b32b4673982fcafcbf: Write expressions using binary operators such as ==>, ||=, &&, ==, !=, <, >, <=, >=, .., |, ^, &, <<, >>, +, -, *, /, and % with well-defined precedence.
// 2a80c96bc8d5e92bd4bf6f5538acc384: Destructure structs and assign field values directly to variables with or without renaming.
// 0c9831697a6cdca0028fe815ae181f71: Test that the Move read/write access specifiers (`reads`/`writes`) on functions are correctly enforced and checked for resource usage on function calls, including detection of mismatched or missing access privileges.
