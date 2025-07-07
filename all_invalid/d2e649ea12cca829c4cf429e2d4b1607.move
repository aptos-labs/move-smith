
//# publish
module 0xCAFE::AdvancedFeaturesTest {
    use std::vector;
    use std::ops::Add; // Import Add trait for generics

    struct InnerStruct has copy, drop, store {
        inner_field1: u8,
        inner_field2: u16,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        outer_field: u64,
    }

    // Function to retrieve deeply nested fields' values
    public fun get_inner_fields(outer: &OuterStruct): (u8, u16) {
        let inner_ref = &outer.inner;
        let a = inner_ref.inner_field1;
        let b = inner_ref.inner_field2;
        (a, b)
    }

    // Function to create nested struct and access inner fields
    public fun create_and_access(): (u8, u16) {
        let inner = InnerStruct {inner_field1: 42, inner_field2: 99};
        let outer = OuterStruct {inner: inner, outer_field: 12345};
        get_inner_fields(&outer)
    }

    // Function demonstrating nested while loops and variable shadowing
    public fun shadowing_variables() {
        let x: u64 = 0;
        let outer_x = x;
        let i: u64 = 0;

        // outer loop
        while (i < 3) {
            // shadowing inner_x
            let inner_x = outer_x + i;
            let inner_b = inner_x;

            // inner loop
            let j: u64 = 0;
            while (j < 2) {
                // shadowed inner_x
                let inner_x = inner_b + j;
                // verify that inner_x is correctly computed
                assert!(inner_x == outer_x + i + j, 42);
                inner_b = inner_x;
                // increment inner loop counter
                j = j + 1;
            };
            // verify outer_x remains unchanged
            assert!(outer_x == x, 42);
            // increment outer loop index
            outer_x = outer_x + 1;
            // increment outer loop index variable
            i = i + 1;
        };
    }

    // A generic function that adds two values
    public fun add_generic<T: copy + drop + Add<Output = T>>(a: T, b: T): T {
        a + b
    }

    // Wrapper function that passes a function as argument and invokes it
    public fun use_function<F: copy + drop + (fn(T, T): T), T: copy + drop + Add<Output = T>>(f: F, a: T, b: T): T {
        f(a, b)
    }

    // Function that tests first-class functions: assign functions to variables and pass around
    public fun test_functions() {
        // Assign the add_generic function to a variable
        let f_add = copy add_generic::<u32>;
        // Call the function via use_function
        let res1 = use_function::<fn(u32, u32): u32, u32>(f_add, 10, 20);
        assert!(res1 == 30, 42);

        // Create a closure (simulate with a generic function) and assign
        let f_double = copy |a: u32, _b: u32| { a * 2 };
        let res2 = use_function::<fn(u32, u32): u32, u32>(f_double, 7, 0);
        assert!(res2 == 14, 42);
    }

    // Function combining nested struct access and first-class function usage
    public fun complex_interaction() {
        let inner = InnerStruct {inner_field1: 55, inner_field2: 255};
        let outer = OuterStruct {inner: inner, outer_field: 54321};

        // Capture a function that accesses nested inner fields
        let access_func: fn(&OuterStruct): (u8, u16) = get_inner_fields;

        let (a, b) = access_func(&outer);
        assert!(a == 55 && b == 255, 42);

        // Use functions with shadowed variables and inside nested loops
        shadowing_variables();

        // Test function assignment and invocation
        test_functions();
    }
}



//# run 0xCAFE::AdvancedFeaturesTest::create_and_access


//# run 0xCAFE::AdvancedFeaturesTest::complex_interaction


// Features:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
