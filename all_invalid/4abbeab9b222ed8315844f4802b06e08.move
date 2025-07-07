
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