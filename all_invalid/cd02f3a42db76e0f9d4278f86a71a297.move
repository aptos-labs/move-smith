
//# publish
module 0xCAFE::ImportAndNativeTest {
    // Import external module with alias
    use 0xCAFE::ExternalModule as ExtMod;

    // Import specific members with alias
    use 0xCAFE::ExternalModule::{CONST_VALUE as EV, some_function as ext_func};

    // Use native functions (simulate external native functions)
    native public fun native_external_function(x: u64): u64;

    // Members declaration with specific aliases
    use 0xCAFE::ExternalModule::{CONST_VALUE as MY_CONST, some_function as my_ext_func};

    // Function to test alias resolution and calling
    public fun test_aliases() {
        // Call via module alias
        let val1 = ExtMod::CONST_VALUE;
        // Call imported member via alias
        let val2 = EV;
        let res1 = ext_func(42u64);
        let res2 = my_ext_func(7u64);
        // Call native function
        let res3 = native_external_function(10);
        // Call via new alias
        let res4 = MY_CONST;
        let res5 = my_ext_func(3u64);

        // Use the results to prevent optimization (no assertion needed)
        let _ = (val1, val2, res1, res2, res3, res4, res5);
    }

    // Declare native functions with signatures to validate recognition
    native public fun native_function_1(x: u8);
    native public fun native_function_2(y: u16): u16;

    // Use the native functions in a call to validate recognition
    public fun test_native_calls() {
        native_function_1(5u8);
        let _ = native_function_2(123u16);
    }
}


//# run 0xCAFE::ImportAndNativeTest::test_aliases


//# run 0xCAFE::ImportAndNativeTest::test_native_calls


// Featurres:
// 183ecf11e40cd8fa5b885c8dfa839e08: Import modules or items using an alias with the 'use' statement in your Move code.
// 4ebd003b016e539a91b7c9e4c96572c2: Use 'members' declarations to import specific members of a module with optional aliasing.
// 4d421e2a96113c450553109c5e78804d: Annotate a function as 'native' to omit its body and mark implementation as external.
