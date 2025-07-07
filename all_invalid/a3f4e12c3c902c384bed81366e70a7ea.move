
//# publish
module 0xCAFE::AliasModule {
    // A simple module to be imported with alias
    public fun fun_alias_test(x: u8): u8 {
        if (x > 5) {
            42
        } else {
            7
        };
        // Unreachable code below (should be dead code)
        let _unreachable: u8 = 99;
        0u8
    }
}


//# publish
module 0xCAFE::UseAliasTest {
    use 0xCAFE::AliasModule as AM;

    // Call function from alias module to test alias imported correctly.
    public fun call_alias_fun(x: u8): u8 {
        AM::fun_alias_test(x)
    }

    public fun dead_code_example(): u8 {
        let res = 1u8;
        return res;
        // Unreachable code: this should cause unreachable bytecode
        let _dead = 999u8;
        0u8
    }

    public fun nested_use_and_unreachable(): u8 {
        let val = AM::fun_alias_test(10u8);
        if (val == 42) {
            100u8
        } else {
            0u8
        };
        // Unreachable code below
        let unreachable_after_if = 123u8;
        0u8
    }
}


//# run 0xCAFE::AliasModule::fun_alias_test --args 10u8


//# run 0xCAFE::AliasModule::fun_alias_test --args 2u8


//# run 0xCAFE::UseAliasTest::call_alias_fun --args 10u8


//# run 0xCAFE::UseAliasTest::call_alias_fun --args 2u8


//# run 0xCAFE::UseAliasTest::dead_code_example


//# run 0xCAFE::UseAliasTest::nested_use_and_unreachable


// Featurres:
// a090c98b9fdad4813b04db1286cbf6c3: Rely on the compiler to perform various required transformations and additional checks on your Move code.
// 14991b7ba6a9c075cb9057501327b151: Use the 'use' statement to import modules or give them aliases.
// 19ae64286d50498255dba95d60895376: Identify and highlight unreachable code segments in the bytecode.
