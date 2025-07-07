//# publish
module 0xCAFE::TestModule {
    // Test 1: Multiple attributes in the same #[...]
    #[test, test_only]
    public fun multiple_attributes(): u64 {
        // Just return a constant to check the function runs
        42u64
    }

    // Test 2: Lambda expressions with lvalue parameters and captured variables
    // We create a runner that defines a captured variable, a lambda that takes lvalue param, modifies it and returns it.
    public fun test_lambda(): u64 {
        let mut x = 10u64;
        let mut y = 100u64;

        // lambda capturing y by ref and x by copy, and taking lvalue param ref mut
        let mut add_and_capture = move |r: &mut u64| {
            *r = *r + x + y;
            y = 1;   // mutate captured variable y by ref
            *r
        };

        let res1 = add_and_capture(&mut x);  // x = 10+10+100=120
        // after call y was updated to 1
        let res2 = add_and_capture(&mut x);  // x = 120+10+1=131

        // Return total sum to verify values changed
        res1 + res2 + y  // 120 + 131 + 1 = 252
    }

    // Test 3: Use '*' wildcard pattern matching
    public fun test_wildcard(): u64 {
        let tup = (1u8, 2u16, 3u32);
        let (a, *, c) = tup;
        (a as u64) + (c as u64) // 1 + 3 = 4
    }

    // Runner function to call all tests without args
    public fun runner(): u64 {
        let r1 = multiple_attributes();
        let r2 = test_lambda();
        let r3 = test_wildcard();
        r1 + r2 + r3
    }
}
//# run 0xCAFE::TestModule::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::TestModule;

    fun main(account: signer) {
        let result = TestModule::runner();
        // No assertions needed per instructions
    }
}

// Featurres:
// f6f6137f4023d007e19a35166482e887: Specify multiple attributes inside the brackets following '#' and separate them with commas.
// f73060b6d1076a931e5179d4883248f2: Use lambda (anonymous function) expressions with lvalue parameters and captured variables.
// 01b3da323fc7fbad7b996ceadd3198ce: Use '*' as a wildcard name in Move code.
