
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;
    use std::signer;

    // Script to test each script entry point with sample data
    public fun run_all_tests() {
        // Invoke script for f1
        let result_f1 = 0xCAFE::FeatureTestScript::test_f1(5u8, true);
        // Invoke script for f2
        let result_f2 = 0xCAFE::FeatureTestScript::test_f2(15u16);
        // Invoke script for f3
        let result_f3 = 0xCAFE::FeatureTestScript::test_f3(20u16);
        // Invoke script for f4
        let result_f4 = 0xCAFE::FeatureTestScript::test_f4();
        // Invoke script for f5
        let result_f5 = 0xCAFE::FeatureTestScript::test_f5();
        // Invoke script for f6
        let result_f6 = 0xCAFE::FeatureTestScript::test_f6( |x: u8| x + 10, 7u8 );
        // Invoke script for f7
        let result_f7 = 0xCAFE::FeatureTestScript::test_f7();
        // Invoke script for f8
        let result_f8 = 0xCAFE::FeatureTestScript::test_f8();

        // Additional tests for variable shadowing and scope
        let result_scope = 0xCAFE::FeatureTestScript::test_variable_scoping();

        // Test conversion of string list to symbols list
        let string_list = vector[b"abc", b"XYZ", b"123"];
        let symbols_list = 0xCAFE::FeatureTestScript::convert_strings_to_symbols(string_list);
        // Run baz with some tuple
        let diff_result = 0xCAFE::FeatureTestScript::baz((10u64, 4u64));
        // Test with multiple params
        let multitest_result = 0xCAFE::FeatureTestScript::multi_param_function(123u8, 456u16, 789u32, 101112u64);
    }
}

// script]
fun test_f1(x: u8, y: bool): u8 {
    let _ = 0xCAFE::MyModule::f1(x, y);
    x
}

// script]
fun test_f2(x: u16): (u16, u16) {
    let (a, b) = 0xCAFE::MyModule::f2(x);
    (a, b)
}

// script]
fun test_f3(x: u16): 0xCAFE::MyModule::S {
    0xCAFE::MyModule::f3(x)
}

// script]
fun test_f4(): () {
    0xCAFE::MyModule::f4()
}

// script]
fun test_f5(): () {
    0xCAFE::MyModule::f5()
}

// script]
fun test_f6(): u8 {
    0xCAFE::MyModule::f6(|n: u8| n + 5, 12u8)
}

// script]
fun test_f7(): () {
    0xCAFE::MyModule::f7()
}

// script]
fun test_f8(): u32 {
    0xCAFE::MyModule::f8()
}

// script]
fun test_variable_scoping(): () {
    let outside_var = 100;
    let shadow_var = outside_var;
    // Outer scope
    let _ = {
        let outside_var = 999; // shadowing outside_var
        let inner_var = outside_var;
        while (inner_var > 900) {
            let temp = inner_var - 1;
            inner_var = temp;
        };
        inner_var
    };
    // After loop, shadow_var should still be the outer one
    let _ = shadow_var;
}

// script]
fun convert_strings_to_symbols(strings: vector<vector<u8>>): vector<0xCAFE::MyModule::Symbol> {
    let symbols = vector::empty<0xCAFE::MyModule::Symbol>();
    let len = vector::length(&strings);
    let i = 0u64;
    while (i < len) {
        let s = vector::borrow(&strings, i);
        let symbol = 0xCAFE::MyModule::string_to_symbol(s);
        vector::push_back(&mut symbols, symbol);
        i = i + 1;
    };
    symbols
}

// script]
fun baz(tuple: (u64, u64)): u64 {
    let (a, b) = tuple;
    a - b
}

// script]
fun multi_param_function(a: u8, b: u16, c: u32, d: u64): u64 {
    d + (c as u64) + (b as u64) + (a as u64)
}


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 78af512b113f55770b2a635ce9a9d77c: Convert a list of strings into a list of symbols for usage in your Move code
// db704c14966cb65407dde2298e82b08c: Test that the `baz` function correctly destructures a tuple and computes the difference between its elements.
// db4fe51540cd1aa460cf057f1108ff92: Define functions with multiple parameters of arbitrary types
