//# publish
module 0xCAFE::Test_Module_123_Abc {

    // Example of identifiers with letters, digits, and underscores
    struct Data_1_2_3 has copy, drop, store {
        value: u64,
    }

    // A "runner" function to be called without arguments
    public fun runner() {
        // Define a lambda function (anonymous function)
        let add_one = |x: u64| -> u64 {
            x + 1
        };

        let result = add_one(41);
        let _data = Data_1_2_3 { value: result };
    }

    // Another function with nested blocks and 'use' statement
    public fun block_use_lambda() {
        {
            use 0xCAFE::Test_Module_123_Abc::Data_1_2_3;

            // lambda function to double a number
            let double = |n: u64| -> u64 {
                n * 2
            };
            
            let value = 21;
            let doubled_value = double(value);
            let _d = Data_1_2_3 { value: doubled_value };
        }
    }
}

//# run 0xCAFE::Test_Module_123_Abc::runner

//# run 0xCAFE::Test_Module_123_Abc::block_use_lambda

// Featurres:
// 04655542e1b7366c9fa9bd2314371092: Create names and identifiers composed of letters, digits, and underscores.
// e8bfbbe8f9b7e36b69b5ae1aabb4fdf3: Import names into block scope using 'use' statements at the beginning of a block.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
