
//# publish
module 0xCAFE::VectorFunctionTest {
    use std::vector;

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
    public fun apply_function(f: |u8| u8, x: u8): u8 {
        f(x)
    }

    // Function with a function argument that itself takes a function and a u8, returns u8
    public fun apply_higher_order(f: |( |u8|u8 ), u8| u8, g: |u8|u8, x: u8): u8 {
        f(g, x)
    }

    // Runner function - returns sum of applying functions
    public fun runner(): u8 {
        let inc = |a: u8| { a + 1u8 };
        let dec = |a: u8| { a - 1u8 };

        let use_inc = apply_function(inc, 5u8);
        let use_dec = apply_function(dec, 6u8);

        let hof = |func: |u8| u8, val: u8| {
            let v1 = func(val);
            let v2 = func(v1);
            v2
        };

        let use_hof = apply_higher_order(hof, inc, 4u8);
        use_inc + use_dec + use_hof
    }
}


//# run 0xCAFE::VectorFunctionTest::empty_vector_u8


//# run 0xCAFE::VectorFunctionTest::vector_u64_with_elements


//# run 0xCAFE::VectorFunctionTest::nested_vectors_bool


//# run 0xCAFE::VectorFunctionTest::apply_function --args 7u8  --signers 0xCAFE
// We need a wrapper if complex arg is required, but here just run with literal


//# run 0xCAFE::VectorFunctionTest::apply_higher_order --args 5u8  --signers 0xCAFE


//# run 0xCAFE::VectorFunctionTest::runner


// Featurres:
// 7282f71ab15dd29def3d23bb4a2e2dad: Allow parsing of empty lists when the end token immediately follows the start.
// f3e24db18607697bed66b248e6934b8c: Create vectors with the `vector` expression, specifying element type arguments and element expressions.
// e2ec2675fa5452090605f390b98f65b1: Define function types that include other functions as arguments.
