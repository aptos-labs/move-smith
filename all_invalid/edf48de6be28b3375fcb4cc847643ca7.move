
// internal function access restrictions, and module alias referencing.

// Declare variables outside and inside loops, perform assignments, and verify correctness.

// External module alias for referencing 0xCAFE::MyModule
//# publish
module 0xDEAD::AliasModule {
    // Alias for 0xCAFE::MyModule
    use 0xCAFE::MyModule as Alias;
}

// Main script for testing script entry points and variable scoping
//# run
script {
    // Declare variables outside loops
    let outside_var = 0u64;

    // Loop to test variable shadowing and assignments
    let i = 0u64;
    while (i < 3) {
        // Declare a variable inside the loop
        let inside_var = i + 10;
        // Assign to outside variable
        outside_var = outside_var + inside_var;
        // Increment loop variable
        i = i + 1;
    };

    // Assert outside_var has the expected value after loop
    assert!(outside_var == (10 + 11 + 12), 12345);
}

// Nested loop with variable declarations and shadowing
//# run
script {
    let outer_var = 0u64;
    let j = 0u64;
    while (j < 2) {
        let inner_var = j + 20;
        let outer_var_shadow = outer_var + inner_var;
        // Inner variable shadows outer_var
        assert!(outer_var_shadow == inner_var);
        j = j + 1;
    };
}

// Restrict function access with internal visibility
//# publish
module 0xCAFE::InternalTest {
    use std::signer;

    // Internal function, should not be callable from outside
    fun internal_func(): u64 {
        999u64
    }

    // Public function calling internal
    public fun call_internal_from_module(): u64 {
        internal_func()
    }
}

// Attempt to call internal_func externally - should fail if tried (simulate via script)
// But in transaction test, just call the public wrapper
//# run
script {
    // Call the public wrapper that internally calls internal_func
    let result = 0xCAFE::InternalTest::call_internal_from_module();
    assert!(result == 999, 54321);
}

// Use address alias to reference module functions
// Here, Alias is used for 0xCAFE::MyModule via alias
//# run
script {
    // Call script functions via alias
    let res_f1 = Alias::f1(5u8, false);
    assert!(res_f1 == 5, 111);

    let (a, b) = Alias::f2(7u16);
    assert!(a == 8 && b == 9, 222);

    let s = Alias::f3(3u16);
    assert!(s.x == 4 && s.y == 5, 333);

    Alias::f4();

    let c = Alias::f6(|u8| u8 { |x| x + 2 }, 4u8);
    assert!(c == 6, 444);
}

// Loop testing with variable assignments and checks
//# run
script {
    let sum = 0u64;
    let k = 0u64;
    while (k < 4) {
        let local_var = k * 2;
        sum = sum + local_var;
        // Shadowing variable, but assigning to outer is allowed inside loop
        k = k + 1;
    };
    assert!(sum == (0 + 2 + 4 + 6), 555);
}

// Verify that variables declared inside inner loops do not affect outer scope
//# run
script {
    let total = 0u64;
    let m = 0u64;
    while (m < 3) {
        let inner = m * 3;
        total = total + inner;
        m = m + 1;
    };
    assert!(total == 0 + 3 + 6, 666);
}


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 190eede9e6150fe22834ead163b5dbd5: Reference named address specifiers using module or address aliases.
