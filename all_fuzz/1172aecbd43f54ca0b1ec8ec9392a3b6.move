
//# publish
module 0xCAFE::AddLambda {
    // Test function computing addition of two u8 before returning a specific value.
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42u8
        42u8
    }

    // Function with lambda that captures environment and computes sum and product
    public fun lambda_operations(a: u8, b: u8): (u8, u8) {
        let f: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let s = x + y;
            let p = x * y;
            (s, p)
        };
        f(a, b)
    }

    // Runner function that creates and calls lambda internally
    public fun lambda_runner(): u8 {
        let lambda: |u8| u8 has copy+drop = |x: u8| { x * 2 };
        lambda(21u8)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddLambda;

    // Function that calls AddLambda lambda_operations and add_and_return_fixed inline
    public fun call_nested_functions(a: u8, b: u8): (u8, u8, u8) {
        let (sum, product) = AddLambda::lambda_operations(a, b);
        let fix_val = AddLambda::add_and_return_fixed(a, b);
        (sum, product, fix_val)
    }
}


//# run 0xCAFE::AddLambda::add_and_return_fixed --args 10u8 32u8


//# run 0xCAFE::AddLambda::lambda_operations --args 3u8 4u8


//# run 0xCAFE::AddLambda::lambda_runner


//# run 0xCAFE::CallerModule::call_nested_functions --args 7u8 8u8

//--------------------------------------------
// Named addresses mapping and parsing test:
// For this transactional test, 
// assume named addresses are defined in the test environment with mappings:
// { "Alice" => 0xABCD, "Bob" => 0xB0B0 }
// We then create modules and scripts using these named addresses.
//
// The below modules and commands test that named addresses propagate correctly.
//
// Note: No address alias usage inside Move code, only addresses directly.


//# publish
module 0xABCD::NamedAddrMod {
    // Simple function to return named address 0xABCD as u64
    public fun get_named_addr_u64(): u64 {
        0xABCD
    }
}


//# publish
module 0xB0B0::UseNamedAddrMod {
    use 0xABCD::NamedAddrMod;

    public fun get_sum_with_named() : u64 {
        let addr = NamedAddrMod::get_named_addr_u64();
        // returns addr + 1 for test
        addr + 1u64
    }
}


//# run 0xABCD::NamedAddrMod::get_named_addr_u64


//# run 0xB0B0::UseNamedAddrMod::get_sum_with_named


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// bba044143266d7d877a176758bba1c70: Define per-directory named address mappings and propagate those named addresses into parsed Move modules and scripts.
