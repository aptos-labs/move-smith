
//# publish
module 0xCAFE::TestModule1 {
    public fun test_function_one() {
    }
}


//# publish
module 0xCAFE::TestModule2 {
    public fun test_function_two() {
    }
}


//# run 0xCAFE::TestModule1::test_function_one --signers 0xCAFE

//# run 0xCAFE::TestModule2::test_function_two --signers 0xCAFE

// Script to call functions with explicit parameters and reference named address syntax

//# run
script {
    fun main() {
        // Calling test function from module 1
        0xCAFE::TestModule1::test_function_one();

        // Calling test function from module 2
        0xCAFE::TestModule2::test_function_two();

        // Example of calling a function with explicit parameters in a module
        // (assuming such a function exists, here just for illustration)
        // 0xCAFE::SomeModule::some_function(param_name: u64);
    }
}

// Featurres:
// bec8f12b899563b482c5a8f54ee72fde: Write scripts with potentially the same main function name, which are automatically disambiguated by the compiler.
// 90412034e9d821593c8fc32a21266754: Declare function parameters with explicit variable names and types using the syntax 'name: Type'.
// ed76520c813b9347b95ad8df42fbf757: Reference named address syntax (`address_name::module_name`) to access a module in your Move code if the named address is declared.
