
//# publish
module 0xCAFE::AddModule {
    // Test addition of two u8 and return a specific value (sum + 1)
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Private function - only accessible within this module
    fun private_helper(x: u8): u8 {
        x * 2
    }

    // Friend function - accessible only by friends declared in the same package (for test, just use friend to test visibility)
    friend fun friend_helper(x: u8): bool {
        x % 2 == 0
    }

    // Lambda function returns a u8 which is sum of input and result of private helper
    public fun lambda_test(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let partial = private_helper(a);
            partial + b
        };
        f(x, y)
    }
}


//# run 0xCAFE::AddModule::add_and_increment --args 10u8 20u8


//# run 0xCAFE::AddModule::lambda_test --args 4u8 3u8


//# publish
module 0xCAFE::InlineCaller {
    // Package visibility restricts accessibility to within the same package 
    // but for test example, we just define the function with this visibility
    package fun call_add_and_increment(a: u8, b: u8): u8 {
        // Call public function from another module
        0xCAFE::AddModule::add_and_increment(a, b)
    }

    // Public function calls the package function above and returns the result incremented by 1
    public fun call_with_extra(a: u8, b: u8): u8 {
        let base = call_add_and_increment(a, b);
        base + 1
    }
}


//# run 0xCAFE::InlineCaller::call_with_extra --args 1u8 2u8


//# run 0xCAFE::InlineCaller::call_add_and_increment --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 61eb046aa92c303317f8da1054b49302: Use public, friend, and private visibility for functions to control their accessibility.
// 7f06a6ddd1a6fd0080a3c81aa0d71531: Refer to standard modules (such as 'vector' and 'cmp') as implicit dependencies without needing direct imports.
// 40695500bde0323f00aa864d292abae6: Declare functions or modules with 'package' visibility to restrict access within the same package.
