// Internal function access restrictions, and module alias referencing.
// No references to specific modules like 0xCAFE::MyModule or 0xCAFE::StorageUsage.

// Declare variables outside and inside loops, perform assignments, and verify correctness.

// External module alias for referencing a module at address 0xDEAD (example address)
// Since the original code references 0xCAFE::MyModule which does not exist,
// replace with a valid module address like 0xDEAD::SomeModule or define a dummy module.

// For this example, assume we define a dummy module for aliasing purposes:

// Dummy module definition to enable aliasing
//# publish
module 0xDEAD::SomeModule {
    public fun f1(input: u8, flag: bool): u8 {
        input
    }

    public fun f2(input: u16): (u16, u16) {
        (input + 1, input + 2)
    }

    public struct S {
        x: u16,
        y: u16,
    }

    public fun f3(input: u16): S {
        S { x: input + 1, y: input + 2 }
    }

    public fun f4() {
        // dummy function
    }

    public fun f6<F: rect(<u8>)>(func: F, val: u8): u8 {
        func(val)
    }
}


// Main script for testing script entry points and variable scoping
// Correctly formatted scripts (each in their own module script)
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

// Use address alias to reference module functions
// Here, alias is created for 0xDEAD::SomeModule

//# publish
module AliasModule {
    use 0xDEAD::SomeModule as Alias;
}

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

    let c = Alias::f6(|x: u8| { x + 2 }, 4u8);
    assert!(c == 6, 444);
}

//# run
script {
    let sum = 0u64;
    let k = 0u64;
    while (k < 4) {
        let local_var = k * 2;
        sum = sum + local_var;
        k = k + 1;
    };
    assert!(sum == (0 + 2 + 4 + 6), 555);
}

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

// Restrict function access with internal visibility
// Using 'internal' functions

//# publish
module 0xDEAD::InternalTest {
    fun internal_func(): u64 {
        999u64
    }

    public fun call_internal_from_module(): u64 {
        internal_func()
    }
}

//# run
script {
    // Call the public wrapper that internally calls internal_func
    let result = 0xDEAD::InternalTest::call_internal_from_module();
    assert!(result == 999, 54321);
}
