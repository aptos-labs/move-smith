
//# publish
module 0xCAFE::TestModule {
    // Constants with uppercase starting names
    const MAX_COUNT: u64 = 1000;
    const DEFAULT_NAME: vector<u8> = b"TestName";

    // Struct with uppercase starting fields
    struct User {
        Id: u64,
        Name: vector<u8>,
    }

    // Inline function to test lambda application
    public inline fun foo(x: u64): u64 {
        let sum = 0;
        // First lambda: add 10
        let result1 = |a: u64| a + 10;
        // Second lambda: multiply by 2
        let result2 = |a: u64| a * 2;

        // Apply the lambdas and sum results
        let r1 = result1(x);
        let r2 = result2(x);
        sum = r1 + r2;
        sum
    }

    // Function to test struct assignment and mutation
    public fun test_struct_mutation() {
        // Create a new user
        let user = User { Id: 1, Name: DEFAULT_NAME };
        // Assign a new ID
        user.Id = 42;
        // Mutate the name (simulate by reassigning)
        user.Name = b"NewName";

        // Assign to a local variable
        let local_id = user.Id;
        let local_name = user.Name;

        // Mutate local variables
        local_id = 100;
        local_name = b"LocalName";

        // Perform mutation on struct fields again
        user.Id = local_id;
        user.Name = local_name;
    }

    // Function to test multiple assignments with the inline function
    public fun test_inline_function(x: u64): u64 {
        foo(x)
    }
}



//# run 0xCAFE::TestModule::test_struct_mutation --signers 0xBEEF


//# run 0xCAFE::TestModule::test_inline_function --signers 0xBEEF --args 5u64

// Features:
// 6cd4a42e5ac6afcaf25b8d3fd2bb08c1: Use valid module member names that start with an uppercase letter for constants, structs, and schemas.
// 17e32096043b947e097ce2fa11e19fc5: Perform assignments to local variables, struct fields, or perform mutate operations with the `assign` and `mutate` expressions.
// e3e6532e767446e6ef8561091d72a7b2: Test that the inline function `foo` correctly applies multiple lambda functions to input values and sums their results as expected.