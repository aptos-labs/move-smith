//# publish
module 0xBADD::TestFeatures {
    use std::vector;

    // Define a simple function with arguments and return type
    public fun add_u32(a: u32, b: u32): u32 {
        a + b
    }

    // Define a function that takes a function as argument and applies it
    public fun apply_function(f: |u32, u32| -> u32, x: u32, y: u32): u32 {
        f(x, y)
    }

    // Create a function to return a function (first-class function)
    public fun get_adder(): |u32, u32| -> u32 {
        |a: u32, b: u32| -> u32 {
            a + b
        }
    }

    // Function to test that function value can be stored and invoked
    public fun call_function_value(f: |u32, u32| -> u32, x: u32, y: u32): u32 {
        f(x, y)
    }

    // Nesting functions as values
    public fun higher_order(x: u32): u32 {
        // capture the add_u32 function and apply
        let f1 = add_u32;
        let f2 = get_adder();
        // apply both functions
        let res1 = f1(x, 2);
        let res2 = f2(x, 3);
        res1 + res2
    }

    // Testing quantified binding: for some type 'T' (simulate with explicit type here)
    // In Move, explicit param is needed, so we add a generic, but in test, mimic behavior
    // For simplicity, test with vector type as quantified binding
    public fun list_length<T: copy + drop>(lst: vector<T>): u64 {
        vector::length(&lst)
    }

    // Test scenario for destructuring a tuple (simulating with inlined destructure)
    // Since Move does not have pattern destructuring, use explicit let binding
    public fun baz(t: (u64, u64)): u64 {
        let (a, b) = t;
        a - b // produce difference of tuple elements
    }
}


//# run 0xBADD::TestFeatures::add_u32 --args 10 20


//# run 0xBADD::TestFeatures::apply_function --signers 0xCAFE --args 5 7


//# run 0xBADD::TestFeatures::call_function_value --args 15 25


//# run 0xBADD::TestFeatures::higher_order --args 10


//# run 0xBADD::TestFeatures::list_length --args 1 2 3


//# run 0xBADD::TestFeatures::baz --args (100, 42)
