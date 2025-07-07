
//# publish
module 0xCAFE::AddModule {
    // Demonstrates simple addition of two u8 values and returns a fixed value 42u8

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignored = sum; // just to ensure sum is computed
        42u8
    }

    // deprecated = "Use add_and_return_fixed instead"]
    public fun old_add_function(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 3u8 4u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    // Nested call to the inline function from the first module

    public inline fun inline_add(a: u16): (u16, u16) {
        (a + 10u16, a + 20u16)
    }

    public fun call_nested_functions(x: u8, y: u8, z: u16): u8 {
        let sum = AddModule::add_and_return_fixed(x, y);
        let (r1, r2) = inline_add(z);
        let result = sum + (r1 as u8) + (r2 as u8);
        result
    }

    // deprecated = "No longer used"]
    public fun deprecated_call() {
        let _ = AddModule::old_add_function(1u8, 2u8);
    }
}


//# run 0xCAFE::NestedCallModule::call_nested_functions --args 1u8 2u8 3u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 3220df2133f8fbcc8780511b273236cf: Use suffixes 'u8', 'u16', 'u32', 'u64', 'u128', or 'u256' to specify the exact numeric type of integer literals in Move code.
// caf68958502e03d1c87701fe1f6fd804: Mark modules or address definitions as deprecated by adding attributes, enabling deprecation notices.
