
//# publish
module 0xCAFE::VectorFunctionTest {
    // No need to import std::vector if not used explicitly
    // Use vector literals (built-in language feature) as below

    // Function that returns an empty vector<u8> using the vector literal expression
    public fun empty_vector_u8(): vector<u8> {
        vector[]
    }

    // Function that returns a vector<u64> with elements given
    public fun vector_u64_with_elements(): vector<u64> {
        vector[10u64, 20u64, 30u64]
    }

    // Function that returns a vector<vector<bool>>, nested vectors with elements
    public fun nested_vectors_bool(): vector<vector<bool>> {
        vector[
            vector[true, false],
            vector[false, false, true],
            vector[]
        ]
    }

    // Function type taking an u8 and returning u8
    public fun apply_function(f: &|u8| u8, x: u8): u8 {
        *f(x)
    }

    // Correct the function types for function references:
    // The higher order function takes a reference to a function that takes 
    // (reference to function &|u8| u8, u8) and returns u8.
    // The Move syntax for function types uses |param1, param2| return_type.
    // Function references are prefixed by '&' and function types are 
    // declared with the |...| syntax.
    public fun apply_higher_order(
        f: &(|&|u8| u8, u8| u8), 
        g: &|u8| u8, 
        x: u8
    ): u8 {
        *f(g, x)
    }

    // Runner function - returns sum of applying functions
    public fun runner(): u8 {
        // Declare lambdas as references
        let inc = |a: u8| { a + 1u8 };
        let dec = |a: u8| { a - 1u8 };

        let use_inc = apply_function(&inc, 5u8);
        let use_dec = apply_function(&dec, 6u8);

        let hof = |func: &|u8| u8, val: u8| {
            let v1 = *func(val);
            let v2 = *func(v1);
            v2
        };

        let use_hof = apply_higher_order(&hof, &inc, 4u8);
        use_inc + use_dec + use_hof
    }
}




//# run 0xCAFE::VectorFunctionTest::empty_vector_u8




//# run 0xCAFE::VectorFunctionTest::vector_u64_with_elements




//# run 0xCAFE::VectorFunctionTest::nested_vectors_bool




//# run 0xCAFE::VectorFunctionTest::apply_function --args 7u8  --signers 0xCAFE




//# run 0xCAFE::VectorFunctionTest::apply_higher_order --args 5u8  --signers 0xCAFE




//# run 0xCAFE::VectorFunctionTest::runner
